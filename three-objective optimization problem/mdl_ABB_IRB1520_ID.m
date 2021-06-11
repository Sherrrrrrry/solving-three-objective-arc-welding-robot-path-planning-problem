%MDL_PUMA560 Create model of Puma 560 manipulator
%
% MDL_PUMA560 is a script that creates the workspace variable p560 which
% describes the kinematic and dynamic characteristics of a Unimation Puma
% 560 manipulator using standard DH conventions. 
%
% Also define the workspace vectors:
%   qz         zero joint angle configuration
%   qr         vertical 'READY' configuration
%   qstretch   arm is stretched out in the X direction
%   qn         arm is at a nominal non-singular configuration
%
% Notes::
% - SI units are used.
% - The model includes armature inertia and gear ratios.
%
% Reference::
% - "A search for consensus among model parameters reported for the PUMA 560 robot",
%   P. Corke and B. Armstrong-Helouvry, 
%   Proc. IEEE Int. Conf. Robotics and Automation, (San Diego), 
%   pp. 1608-1613, May 1994.
%
% See also SerialRevolute, mdl_puma560akb, mdl_stanford.

% MODEL: Unimation, Puma560, dynamics, 6DOF, standard_DH

%
% Notes:
%    - the value of m1 is given as 0 here.  Armstrong found no value for it
% and it does not appear in the equation for tau1 after the substituion
% is made to inertia about link frame rather than COG frame.
% updated:
% 2/8/95  changed D3 to 150.05mm which is closer to data from Lee, AKB86 and Tarn
%  fixed errors in COG for links 2 and 3
% 29/1/91 to agree with data from Armstrong etal.  Due to their use
%  of modified D&H params, some of the offsets Ai, Di are
%  offset, and for links 3-5 swap Y and Z axes.
% 14/2/91 to use Paul's value of link twist (alpha) to be consistant
%  with ARCL.  This is the -ve of Lee's values, which means the
%  zero angle position is a righty for Paul, and lefty for Lee.
%  Note that gravity load torque is the motor torque necessary
%  to keep the joint static, and is thus -ve of the gravity
%  caused torque.
%
% 8/95 fix bugs in COG data for Puma 560. This led to signficant errors in
%  inertia of joint 1. 
% $Log: not supported by cvs2svn $
% Revision 1.4  2008/04/27 11:36:54  cor134
% Add nominal (non singular) pose qn

% Copyright (C) 1993-2015, by Peter I. Corke
%
% This file is part of The Robotics Toolbox for MATLAB (RTB).
% 
% RTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% RTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with RTB.  If not, see <http://www.gnu.org/licenses/>.
%
% http://www.petercorke.com

clear L
deg = pi/180;
xishu=10;
%a 连杆长度
%d 连杆距离

L(1) = Revolute('d', 45.3*xishu, 'a', 16.0*xishu, 'alpha', pi/2,'qlim', [-170 170]*deg );

L(2) = Revolute('d', 0, 'a', 59.0*xishu, 'alpha', 0,  'qlim', [-90 150]*deg );

L(3) = Revolute('d', 0, 'a', 20.0*xishu, 'alpha', pi/2,  'qlim', [-100 80]*deg );

L(4) = Revolute('d', 72.3*xishu, 'a', 0, 'alpha', -pi/2,  'qlim', [-155 155]*deg);

L(5) = Revolute('d', 0, 'a', 0, 'alpha', pi/2,  'qlim', [-90 135]*deg );


L(6) = Revolute('d', 20.0*xishu, 'a', 0, 'alpha', 0, 'qlim', [-200 200]*deg );

p560 = SerialLink(L, 'name', 'ABBIRB1520ID');



%
% some useful poses
%
% qz = [0 0 0 0 0 0]; % zero angles, L shaped pose
% qr = [0 pi/2 -pi/2 0 0 0]; % ready pose, arm up
% qs = [0 0 -pi/2 0 0 0];
% qn=[0 pi/4 pi 0 pi/4  0];


clear L
