% ? Rahul Kala, IIIT Allahabad, Creative Commons Attribution-ShareAlike 4.0 International License. 
% The use of this code, its parts and all the materials in the text; creation of derivatives and their publication; and sharing the code publically is permitted without permission. 

% Please cite the work in all materials as: R. Kala (2014) Code for Robot Path Planning using Rapidly-exploring Random Trees, Indian Institute of Information Technology Allahabad, Available at: http://rkala.in/codes.html

% 判断点point是否在地图内和障碍物区域外，是则feasible=true，否则feasible=false
function feasible=feasiblePoint(point,map)
feasible=true;
% check if collission-free spot and inside maps
if point(1)<1 || point(1)>size(map,1) || point(2)<1 || point(2)>size(map,2) || map(point(1),point(2))==0 % 0在二进制图像中表示障碍物区域
    feasible=false;
end