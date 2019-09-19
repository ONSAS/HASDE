% ==============================================================================
% --------     HASDE: una Herramienta abierta de Aprendizaje interactivo 
%                                   del Metodo de Slope Deflection      --------
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

% Function that returns the a, b and ltot values to calculate the
% moment and shear reactions and the nodes A and B
% ----------------------------------------------------------------------

function [a, b, ltot, nodA, nodB] = lengthsFun(lenSum, lenSum2, i, currElemLen, currElemAngle, Nodes, nodeLoad, nodRep, otherElemNode)
	
	if currElemAngle == 1 % horizontal
			
		if Nodes(nodeLoad,1) - Nodes(nodRep,1) > 0
			a = lenSum ; b = currElemLen + lenSum2 ;
			nodA = nodRep ; nodB = otherElemNode ;
		else
			a = currElemLen + lenSum2 ; b = lenSum ;
			nodA = otherElemNode ; nodB = nodRep ;
		end 
		
	elseif currElemAngle == 0 % vertical
		
		if Nodes(nodeLoad,3) - Nodes(nodRep,3) > 0
			a = lenSum ; b = currElemLen ;
			nodA = nodRep ; nodB = otherElemNode ;
		else
			a = currElemLen ; b = lenSum ;
			nodA = otherElemNode ; nodB = nodRep ;
		end
		
	end
	
	ltot = a + b ;
	
end


