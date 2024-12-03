% Default GPA threshold
:- dynamic default_gpa/1.
default_gpa(2.0).

% Calculate grade points earned for a single module
grade_points_earned(GradePoints, Credits, Earned) :-
    Earned is GradePoints * Credits.

% Calculate total grade points and credits for a list of modules
calculate_totals([], 0, 0).
calculate_totals([(GradePoints, Credits)|Rest], TotalPoints, TotalCredits) :-
    calculate_totals(Rest, RestPoints, RestCredits),
    grade_points_earned(GradePoints, Credits, Earned),
    TotalPoints is RestPoints + Earned,
    TotalCredits is RestCredits + Credits.

% Calculate GPA for a semester
calculate_gpa(TotalGradePoints, TotalCredits, GPA) :-
    TotalCredits > 0,
    GPA is TotalGradePoints / TotalCredits.

% Calculate cumulative GPA based on the available semester data
calculate_cumulative_gpa(Sem1TotalPoints, Sem1TotalCredits, Sem2TotalPoints, Sem2TotalCredits, CumulativeGPA) :-
    Sem2TotalCredits > 0,  % If Semester 2 data exists
    TotalPoints is Sem1TotalPoints + Sem2TotalPoints,
    TotalCredits is Sem1TotalCredits + Sem2TotalCredits,
    calculate_gpa(TotalPoints, TotalCredits, CumulativeGPA).

calculate_cumulative_gpa(Sem1TotalPoints, Sem1TotalCredits, _, _, CumulativeGPA) :-
    Sem1TotalCredits > 0,  % If only Semester 1 data exists
    calculate_gpa(Sem1TotalPoints, Sem1TotalCredits, CumulativeGPA).

% Check academic probation status based on GPA
check_academic_probation(GPA, probation) :-
    default_gpa(DefaultGPA),
    GPA < DefaultGPA, !.

check_academic_probation(GPA, good_standing) :-
    GPA >= 2.0.  % GPA greater than or equal to 2.0 means good standing
