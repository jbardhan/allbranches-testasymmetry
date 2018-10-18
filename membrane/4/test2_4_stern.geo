﻿lc = 2;
lc_fine = 0.4;
stern_t = 54;//50 + 4
stern_z = -2;//0 - 2
R = 6;//stern R_diel + 2
Point(1) = {R, R, stern_z, lc};
Point(2) = {R, -R, stern_z, lc};
Point(3) = {-R, -R, stern_z, lc};
Point(4) = {-R, R, stern_z, lc};
Point(5) = {0, 0, stern_z, lc_fine};
Point(6) = {0, 0, stern_t - 2, lc_fine};
Circle(1) = {4, 5, 1};
Circle(2) = {1, 5, 2};
Circle(3) = {2, 5, 3};
Circle(4) = {3, 5, 4};
Extrude {0, 0, stern_t} {
  Line{4, 3, 2, 1};
}
//Line Loop(21) = {5, 17, 13, 9};
//Plane Surface(22) = {21};
//Line Loop(23) = {3, 4, 1, 2};
//Plane Surface(24) = {23};
//Point{5} In Surface{22};
//Point{6} In Surface{24};

Line(21) = {7, 6};
Line(22) = {9, 6};
Line(23) = {11, 6};
Line(24) = {10, 6};
Line(25) = {4, 5};
Line(26) = {3, 5};
Line(27) = {2, 5};
Line(28) = {1, 5};
Line Loop(29) = {5, 22, -21};
Plane Surface(30) = {29};
Line Loop(31) = {22, -23, -17};
Plane Surface(32) = {31};
Line Loop(33) = {23, -24, -13};
Plane Surface(34) = {33};
Line Loop(35) = {24, -21, -9};
Plane Surface(36) = {35};
Line Loop(37) = {26, -25, -4};
Plane Surface(38) = {37};
Line Loop(39) = {25, -28, -1};
Plane Surface(40) = {39};
Line Loop(41) = {28, -27, -2};
Plane Surface(42) = {41};
Line Loop(43) = {27, -26, -3};
Plane Surface(44) = {43};
