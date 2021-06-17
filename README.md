# CPLEX-SPA

This respository was created in order to enable student project allocation, utilising the CPLEX optimiser in order to do so.

It contains example code (.mod files) for student project allocation (SPA), together with some example data (.dat files). You will need IBM iLOG CPLEX Optimization Studio (https://www.ibm.com/uk-en/products/ilog-cplex-optimization-studio) to optimize the models given in the code. Thanks to the IBM Academic Initiative (https://www.ibm.com/academic/home), this software is currently free for academic staff & students upon registration.

The two directories are organised as follows:

(1) **SPA (student choice only)** -- this folder includes both a .mod and and example .dat file, which enables student project allocation based on student preferences for projects, but taking into account maximum student capacities for staff and projects. 
A .dat file is required, which itself includes a list of student choices, projects (with a maximum quota of students for each, together with  a Y/N representing whteher the rpoject is shared across more than one staff member or not) and staff (noting which projects are linked to each staff member and the maxmimum capacity for each staff member as well).

(2) **SPA (student choice and student mark)** -- this folder again includes both a .mod and and example .dat file. Here, this enables student project allocation based on student preferences for projects togeher with a certain weighting dependent on previous student performance (listed as student_mark), still taking into account maximum student capacities for staff and projects.
