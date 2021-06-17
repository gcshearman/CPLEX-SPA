# CPLEX-SPA

This respository was created in order to facilitate student project allocation, utilising the CPLEX optimiser in order to do so.

It contains archive files for student project allocation (SPA) with CPLEX, which can be imported into CPLEX. You will need IBM iLOG CPLEX Optimization Studio (https://www.ibm.com/uk-en/products/ilog-cplex-optimization-studio) to optimize the models given in the code. Thanks to the IBM Academic Initiative (https://www.ibm.com/academic/home), this software is currently free for academic staff & students upon registration.

The two directories are organised as follows:

(1) **SPA (student choice only)** -- this folder includes an archive file - although this is standalone and includes all necessary files, both .mod and and example .dat files have also been included here for clarity. This set enables student project allocation based on student preferences for projects, but taking into account maximum student capacities for staff and projects. 
As an illustration, the .dat file includes a list of student choices, projects (with a maximum quota of students for each), together with  a Y/N representing whether the project is shared across more than one staff member or not) and staff (noting which projects are linked to each staff member and the maxmimum capacity for each staff member as well). The maximum number of projects to be selected by students is also given within the file. 

(2) **SPA (student choice and student mark)** -- this folder again includes an archive file and associated .mod and and example .dat files. Here, this version enables student project allocation based on student preferences for projects togeher with a certain weighting dependent on previous student performance (listed as student_mark), still taking into account maximum student capacities for staff and projects.
