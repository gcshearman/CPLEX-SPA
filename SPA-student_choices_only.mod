
/*********************************************
 * OPL 12.8.0.0 Model
 * Author: Gemma Shearman
 * Creation Date: 23 February 2020
 *********************************************/

  
//**************************** Data **************************************
         
using CPLEX;         
                
// Data Structure

// set of projects and the max student quota for each project

tuple project {
  key string project_no;
  int quota;
  string joint;
}

// set of students, their project choices and their mark

tuple student {
  key string student_no;
  {string} project_choice;
}

// Set of lecturers, the list of projects they lead and their max capacity

tuple lecturer {
  key string lecturer_no;
  {string} project_des;
  float capacity;
}

{student} Students = ...; //  List of students and choices 
{project} Projects = ...; // list of projects & quota
{lecturer} Lecturers = ...; // Lecturer-student capacity
int nProjectSelect = ...;  // number of projects the students are asked to choose

// inferred data

//Project allocation preference score
float Pref[Students][Projects];   // score for student project allocation choice 
float JointWeight[Projects];

// score initalisation where 1st choice eq. 4 points, 2nd choice eq. 3 points etc.
execute INITIALIZE {
   for(var s in Students) {
     for(var p in Projects) {
          if(s.project_choice.contains(p.project_no)) {          
          Pref[s][p] = ((nProjectSelect - Opl.ord(s.project_choice, p.project_no)));
            } else {          
          	Pref[s][p] = 0;   // reduce this value to drive fewer 'unhappy' students
        	}
    	  }
   	 }

for(var p in Projects) {
  		if(p.joint == "Y") {
   		JointWeight[p] = 0.5;
   		} else {
   		JointWeight[p] = 1;
   		}
 	}    

   }                      		         		   		

// Variables
dvar int Assign[Students][Projects] in 0..1;   // Indicates a project allocation... 1 is assigned, 0 unassigned
dexpr float LecturerAlloc[l in Lecturers] = sum(s in Students, p in Projects:  p.project_no in l.project_des) Assign[s][p]*JointWeight[p];

// Optimisation model
// sum of scores for project allocation for students
dexpr float objective1 = sum(s in Students, p in Projects) (Pref[s][p])*(Assign[s][p]);
dexpr float objective2 = sum(l in Lecturers) LecturerAlloc[l];
// total penalty cost
dexpr float objective_tot = objective1 + objective2;

maximize objective_tot;

// Constraints
subject to {
    forall (s in Students)
    OneProjAlloc: sum(p in Projects) Assign[s][p] == 1; //each student is allocated to one project only
    
  forall (p in Projects)
    ProjQuotaMax: sum(s in Students) Assign[s][p] <= p.quota; // each project quote is not exceeded
    
  forall (l in Lecturers)  
  // LectCap: sum(s in Students, p in Projects:  p.project_no in l.project_des) Assign[s][p] <= l.capacity; // each lecturer does not exceed their capacity - only relevant if lecturer capacity does not match project quota totals
  		LectCap: LecturerAlloc[l] <= l.capacity;
 }    
 
 // export output data to a .dat file - location and name of file are alterable
 
 execute {
 var allocfile = new IloOplOutputFile("SPA-allocation.dat");
 for (var s in Students)
 for (var p in Projects) {
   if(Assign[s][p] == 1 && s.project_choice.contains(p.project_no) == 1) 
            allocfile.writeln(s.student_no, "  ", p.project_no, "  ", Opl.ord(s.project_choice, p.project_no)+1);
		 if(Assign[s][p] == 1 && s.project_choice.contains(p.project_no) == 0)
            allocfile.writeln(s.student_no, "  ", p.project_no, "  ", "unhappy");
 };
  allocfile.close();
}

execute { 
 var loadfile = new IloOplOutputFile("SPA-lecturer_load.dat");
 for (var l in Lecturers) {
     loadfile.writeln(l.lecturer_no, "  ", LecturerAlloc[l]);
};
 loadfile.close();
}
 

// output to display
 execute DISPLAY {
  for(var s in Students)
      for(var p in Projects) {
         if(Assign[s][p] == 1 && s.project_choice.contains(p.project_no) == 1) 
            writeln(s.student_no, " ", p.project_no, "  ", Opl.ord(s.project_choice, p.project_no)+1);
		 if(Assign[s][p] == 1 && s.project_choice.contains(p.project_no) == 0)
            writeln(s.student_no, " ", p.project_no, "  ", "unhappy");
 			} 		
  writeln("Lecturer allocations:");
  for (var l in Lecturers)
     writeln(l.lecturer_no, "  ", LecturerAlloc[l]);
     
       }
