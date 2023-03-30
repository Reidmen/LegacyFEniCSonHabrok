from dolfin import *
set_log_level(15)
mesh = UnitCubeMesh(8, 8, 8)
V = FunctionSpace(mesh, 'CG', 1)
u = TrialFunction(V)
v = TestFunction(V)
a = inner(grad(u), grad(v))*dx
L = Constant(1)*v*dx
bc = DirichletBC(V, Constant(0), 'on_boundary')

A, b = assemble_system(a, L, bc)
u = Function(V)
solve(A, u.vector(), b, 'cg')
print(norm(u))
