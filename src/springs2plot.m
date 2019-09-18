% ==============================================================================
% --------     HASDE: una Herramienta abierta de Aprendizaje interactivo 
%                                   del Metodo de Slope DEflection      --------
%~ Copyright (C) 2019, Joaquin Viera, Jorge M. Perez Zerpa

%~ This file is part of HASDE.

%~ HASDE is free software: you can redistribute it and/or modify
%~ it under the terms of the GNU General Public License as published by
%~ the Free Software Foundation, either version 3 of the License, or
%~ (at your option) any later version.

%~ HASDE is distributed in the hope that it will be useful,
%~ but WITHOUT ANY WARRANTY; without even the implied warranty of
%~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%~ GNU General Public License for more details.

%~ You should have received a copy of the GNU General Public License
%~ along with HASDE.  If not, see <https://www.gnu.org/licenses/>.

% ==============================================================================

% Function that plot the supports of the structure
% ----------------------------------------------------------------------

function springs2plot(j, val, strucsize, coordNodes, ax)

	hold on

% i: node number
% j: dof
% val: node dof value
% val==inf: support
% val>0: spring


	%~ Triangles
	coordTX = 0.05*strucsize*[0,-0.5,0.5] ;
	coordTZ = 0.05*strucsize*[0,-sin(deg2rad(60)),-sin(deg2rad(60))] ;
	% rotation about point 1(0,0)			
	coordTXR = ( (coordTX(2:3)-coordTX(1))*cos(pi/2) - (coordTZ(2:3)-coordTZ(1))*sin(pi/2) + coordTX(1) ) ;		
	coordTZR = ( (coordTX(2:3)-coordTX(1))*sin(pi/2) + (coordTZ(2:3)-coordTZ(1))*cos(pi/2) + coordTZ(1) ) ;

	%~ Square
	coordSX = 0.05*strucsize*[-0.5,-0.5,0.5,0.5] ;
	coordSZ = 0.05*strucsize*[0.5,-0.5,-0.5,0.5] ;

	%~ Springs
	coordSpX = 0.05*strucsize*[0 		0 sqrt(3)/2*0.2 -sqrt(3)/2*0.2 sqrt(3)/2*0.2 -sqrt(3)/2*0.2 0 0 ] ;
	coordSpZ = 0.05*strucsize*[0 -0.1 		-0.20 		 -0.40 		 -0.60 			-0.80 		-0.90 		 -1  ] ;
	% rotation about point 1(0,0)			
	coordSpXR = ( (coordSpX(2:end)-coordSpX(1))*cos(pi/2) - (coordSpZ(2:end)-coordSpZ(1))*sin(pi/2) + coordSpX(1) ) ;		
	coordSpZR = ( (coordSpX(2:end)-coordSpX(1))*sin(pi/2) + (coordSpZ(2:end)-coordSpZ(1))*cos(pi/2) + coordSpZ(1) ) ;
	
	% Lines
	coordLX = 0.05*strucsize*[-0.5 0.5] ;
	coordLZ = 0.05*strucsize*[-1 -1] ;
	% rotation about point (0,0)
	pointLR = 0.05*strucsize*[0 0] ; 
	coordLXR = ( (coordLX(1:end)-pointLR(1))*cos(pi/2) - (coordLZ(1:end)-pointLR(2))*sin(pi/2) + pointLR(1) ) ;
	coordLZR = ( (coordLX(1:end)-pointLR(1))*sin(pi/2) + (coordLZ(1:end)-pointLR(2))*cos(pi/2) + pointLR(2) ) ; 
	
	% Moment springs
	ang = [0:0.1:4.5*pi] ;
	fac = linspace(0,0.75,length(ang)) ;
	coordMX = 0.05*strucsize*diag(fac'*cos(ang)) ;
	coordMZ = 0.05*strucsize*diag(fac'*sin(ang)) ;
	
	if j==1
		if val == inf
			patch([coordTX(1) coordTXR]+coordNodes(1), [coordTZ(1) coordTZR]+coordNodes(3), 'w', 'edgecolor', [1 0 0]) ;	
		elseif val > 0
			plot([coordSpX(1) coordSpXR]+coordNodes(1), [coordSpZ(1) coordSpZR]+coordNodes(3), 'r')	;
			plot(coordLXR+coordNodes(1), coordLZR+coordNodes(3), 'r' ) ;
		end
	elseif j==4
		if val == inf
			patch(coordSX+coordNodes(1),coordSZ+coordNodes(3), 'w', 'edgecolor', [1 0 0]) ;	
		elseif val > 0
			plot(coordMX,coordMZ, 'r') ;
			plot([coordMX(end) coordMX(end)], [coordMZ(end)-0.375*0.05*strucsize coordMZ(end)+0.375*0.05*strucsize], 'r') ;
		end
	elseif j==5
		if val == inf
			patch(coordTX+coordNodes(1), coordTZ+coordNodes(3), 'w', 'edgecolor', [1 0 0]) ;	
		elseif val > 0
			plot(coordSpX+coordNodes(1), coordSpZ+coordNodes(2), 'r');
			plot(coordLX+coordNodes(1), coordLZ+coordNodes(3), 'r') ;
		end
	end

end
