#!/usr/bin/env sage
# -*- coding: utf-8 -*-

r"""
    Example script to invoke an (I)LP solver from Sage.
"""
__version__ = "2015-12-01"

reset()

from sage.numerical.mip import MIPSolverException

# creating random LP
n_rows = 3
n_cols = 4
A = random_matrix(ZZ, n_rows, n_cols)
cost_vec = random_vector(ZZ, n_cols)
rhs = random_vector(ZZ, n_rows)

# creating ILP objects
ilp = MixedIntegerLinearProgram(maximization=false, solver="GLPK")
x = ilp.new_variable(binary=True)
cost_func = ilp.sum([x[i]*cost_vec[i] for i in range(n_cols)])  # variable is also initialized by this statement
ilp.set_objective(cost_func)
ilp.add_constraint(A*x <= rhs)
ilp.show()

opt_val = None
optimizer = None

try:
    opt_val = ilp.solve()
    print "optimal value:", opt_val

    try:
        # get_values() may raise a MIPSolverException too
        optimizer = vector(ZZ,ilp.get_values(x).values())   # rounds implicitly
        print "optimizer:", optimizer
    except TypeError as e:
        print "Rounding the optimizer went wrong."
        print "TypeError: ", e

except MIPSolverException as me:
    print me

print "\ndone"

