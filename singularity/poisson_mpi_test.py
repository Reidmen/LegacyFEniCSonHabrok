#!/usr/bin/python
"""Solves a Poisson problem on a unit cube with pure Dirichlet boundary conditions.

Uses PETSc's Krylov-Schur solver and Hypre's BoomerAMG preconditioner.
It runs in parallel and is therefore suitable for testing scaling of FEniCS on clusters.

Author: Chris Richardson, University of Cambridge <chris@bpi.cam.ac.uk>
Minor Modifications: Jack S. Hale, University of Luxembourg <jack.hale@uni.lu>
"""

try:
    import petsc4py
    petsc4py.init(['-log_summary'])
except ImportError:
    pass

import sys

args = [sys.argv[0]] + """
--petsc.ksp_monitor
--petsc.ksp_view
--petsc.pc_hypre_boomeramg_print_debug 1
""".split()

from dolfin import *
parameters.parse(args)
# set_log_level(PROGRESS)

parameters["form_compiler"]["optimize"]     = True
parameters["form_compiler"]["cpp_optimize"] = True
# parameters["form_compiler"]["representation"] = "quadrature"
parameters["form_compiler"]["cpp_optimize_flags"] = "-O3 -ffast-math -march=native"

def main():
    t0 = Timer("Z Creating mesh...")
    # Initial number of DOFs per MPI process
    ndofs = 20
    # Number of times to refine initial mesh
    refine_levels = 3
    # Get number of MPI processes
    ncores = MPI.size(MPI.comm_world)
    N = (ndofs*ncores)
    print(f"number of cores {ncores}")
    
    # Refinement levels
    Nx = int(N**(1./3.) + 0.5)
    while (N%Nx != 0):
        Nx -= 1
    Ny = int((N/Nx)**0.5 + 0.5)
    while ((N/Nx)%Ny != 0):
        Ny -= 1
    Nz = int(N/Nx/Ny)

    info("Z Initial Nx: %s" % Nx)
    info("Z Initial Ny: %s" % Ny)
    info("Z Initial Nz: %s" % Nz)

    mesh = UnitCubeMesh(Nx, Ny, Nz)

    for i in range(refine_levels):
        print("Refinement %s..."% str(i+1))
        t0 = Timer("Z Refinement %s..." % str(i+1))
        mesh = refine(mesh, redistribute=False)
        del(t0)
    print("Finished refinement")

    t0 = Timer("Z FunctionSpace...")
    V = FunctionSpace(mesh, "Lagrange", 1)
    del(t0)

    info("Z Degrees of freedom:                  %s" % V.dim())
    info("Z Degrees of freedom per core: %s" %
         (V.dim()/MPI.size(MPI.comm_world)))

    # Define Dirichlet boundary (x = 0 or x = 1)
    def boundary(x):
        return x[0] < DOLFIN_EPS or x[0] > 1.0 - DOLFIN_EPS

    # Define boundary condition
    t0 = Timer("Z DirichletBC...")
    u0 = Constant(0.0)
    bc = DirichletBC(V, u0, boundary)
    del(t0)

    t0 = Timer("Z Expression...")
    f = Expression("10*exp(-(pow(x[0] - 0.5, 2) + pow(x[1] - 0.5, 2)) / 0.02)", degree=4)
    g = Expression("sin(5*x[0])", degree=4)
    del(t0)

    t0 = Timer("Z Forms...")
    # Define variational problem
    u = TrialFunction(V)
    v = TestFunction(V)
    a = inner(grad(u), grad(v))*dx
    L = f*v*dx + g*v*ds
    del(t0)
    
    # Set some PETSc solver options
    t0 = Timer("Z PETSC Options...")

    # Number of levels of aggresive coarsening for BoomerAMG (note:
    # increasing this appear to lead to substantial memory savings)
    PETScOptions.set("pc_hypre_boomeramg_agg_nl", 4)
    PETScOptions.set("pc_hypre_boomeramg_agg_num_paths", 2)

    # Truncation factor for interpolation (note: increasing towrds 1
    # appears to reduce memory useage)
    PETScOptions.set("pc_hypre_boomeramg_truncfactor", 0.9)

    # Max elements per row for interpolation operator
    PETScOptions.set("pc_hypre_boomeramg_P_max", 5)

#    PETScOptions.set("pc_hypre_boomeramg_max_levels", 10)

    # Strong threshold (BoomerAMG docs recommend 0.5-0.6 for 3D Poisson)
    PETScOptions.set("pc_hypre_boomeramg_strong_threshold", 0.5)

    # Compute solution
    u = Function(V)
    del(t0)
    t0 = Timer("Z Assembling...")
    A = assemble(a)  
    b = assemble(L)
    bc.apply(A, b)
    del(t0)

    t0 = Timer("Z Solving...")
    solver = PETScKrylovSolver("cg", "hypre_amg")
    solver.parameters["relative_tolerance"] = 1e-10
    solver.set_from_options()
    info(solver.parameters, True)
    solver.solve(A, u.vector(), b)
    del(t0)

if __name__ == "__main__":
    try:
        from memory_profiler import profile
        main = profile(main)
    except ImportError:
        pass

    main()
    list_timings(TimingClear.keep, [TimingType.wall])
