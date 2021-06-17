/*********************************************
 * OPL 12.8.0.0 Model
 * Author: Gemma Shearman
 * Creation Date: 26 June 2019
 *********************************************/

  
//**************************** Data **************************************
         
using CPLEX;         
                
// Data Structure

// set of projects and the max student quota for each project

tuple project {
  key string project_no;
  int quota;
}

// set of students, their project choices and their mark

tuple student {
  key float student_mark;
  key string student_no;
  {string} project_choice;
}

// Set of lecturers, the list of projects they lead and their max capacity

tuple lecturer {
  key string lecturer_no;
  {string} project_des;
  int capacity;
}

{student} Students = ...; //  List of students and choices 
{project} Projects = ...; // list of projects & quota
{lecturer} Lecturers = ...; // Lecturer-student capacity
int nProjectSelect = ...;  // number of projects the students are asked to choose

reversed {student} sortedStudent = Students;

// inferred data

//Project allocation preference score
float Pref[Students][Projects];   // score for student project allocation choice 

// score initalisation where 1st choice eq. 6 points, 2nd choice eq. 5 points etc.
execute INITIALIZE {
   for(var s in Students) {
     for(var p in Projects) {
          if(s.project_choice.contains(p.project_no)) {          
          Pref[s][p] = ((nProjectSelect - Opl.ord(s.project_choice, p.project_no)));
            } else {          
          	Pref[s][p] = 0;    // reduce this value to drive fewer 'unhappy' students
        	}
    	  }
   	 }

   }                      		         		   		

// Variables
dvar int Assign[Students][Projects] in 0..1;   // Indicates a project allocation... 1 is assigned, 0 unassigned
dexpr int LecturerAlloc[l1 in Lecturers] = sum(s in Students, p in Projects:  p.project_no in l1.project_des) Assign[s][p];

// Optimisation model
// sum of scores for project allocation for students
dexpr float objective1 = sum(s in Students, p in Projects) (Pref[s][p])*(Assign[s][p])*s.student_mark;

maximize objective1;

// Constraints
subject to {
    forall (s in Students)
    OneProjAlloc: sum(p in Projects) Assign[s][p] == 1; //each student is allocated to one project only
    
  forall (p in Projects)
    ProjQuotaMax: sum(s in Students) Assign[s][p] <= p.quota; // each project quote is not exceeded
    
  forall (l in Lecturers)  
   LectCap: sum(s in Students, p in Projects:  p.project_no in l.project_des) Assign[s][p] <= l.capacity; // each lecturer does not exceed their capacity - only relevant if lecturer capacity does not match project quota totals
  		
 }    
 
 // export output data to a .dat file - location and name of file are alterable
 
 execute {
 var allocfile = new IloOplOutputFile("SPA.dat");
 for (var s in sortedStudent)
 for (var p in Projects) {
   if(Assign[s][p] == 1 && s.project_choice.contains(p.project_no) == 1) 
            allocfile.writeln(s.student_mark, " ", s.student_no, "  ", p.project_no, "  ", Opl.ord(s.project_choice, p.project_no)+1);
		 if(Assign[s][p] == 1 && s.project_choice.contains(p.project_no) == 0)
            allocfile.writeln(s.student_mark, " ", s.student_no, "  ", p.project_no, "  ", "unhappy");
 }
 allocfile.close();
} 
 

// output to display
 execute DISPLAY {
  for(var s in Students)
      for(var p in Projects) {
         if(Assign[s][p] == 1 && s.project_choice.contains(p.project_no) == 1) 
            writeln(s.student_no, " ", p.project_no, "  ", Opl.ord(s.project_choice, p.project_no)+1);
		 if(Assign[s][p] == 1 && s.project_choice.contains(p.project_no) == 0)
            writeln(s.student_no, " ", s.student_mark, "  ", p.project_no, "  ", "unhappy");
 			} 		
  writeln("Lecturer allocations:");
  for (var l in Lecturers)
     writeln(l.lecturer_no, "  ", LecturerAlloc[l]);
     
 for (var s in sortedStudent)
 for (var p in Projects) {
   if(Assign[s][p] == 1 && s.project_choice.contains(p.project_no) == 1) 
            writeln(s.student_mark, " ", p.project_no, "  ", Opl.ord(s.project_choice, p.project_no)+1);
		 if(Assign[s][p] == 1 && s.project_choice.contains(p.project_no) == 0)
            writeln(s.student_mark, " ", s.student_no, "  ", p.project_no, "  ", "unhappy");
 }

       }

