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

% Function that returns the ConecSd and NodesSd matrices
% ----------------------------------------------------------------------

function [ConecSd, NodesSd, nelemCounter, npos] = restructureSD(aux1, aux2, posnode, nelemCounter, NodesSd, ConecSd, nod1, nod2, Nodes)
	
	if length(aux1) == 0 && length(aux2) == 0
		ConecSd(nelemCounter,:) = [ posnode posnode+1 0 0 1 1 2 ] ;
		NodesSd = [ NodesSd ; Nodes(nod1,:) ; Nodes(nod2,:) ] ;
		nelemCounter = nelemCounter + 1 ; npos = posnode+2 ;
	elseif length(aux1) == 0 && length(aux2) == 1
		ConecSd(nelemCounter,:) = [ posnode aux2 0 0 1 1 2 ] ;
		NodesSd = [ NodesSd ; Nodes(nod1,:) ] ;
		nelemCounter = nelemCounter + 1 ; npos = posnode+1 ;
	elseif length(aux1) == 1 && length(aux2) == 0
		ConecSd(nelemCounter,:) = [ aux1 posnode 0 0 1 1 2 ] ;
		NodesSd = [ NodesSd ; Nodes(nod2,:) ] ;
		nelemCounter = nelemCounter + 1 ; npos = posnode+1 ; 
	elseif length(aux1) == 1 && length(aux2) == 1
		ConecSd(nelemCounter,:) = [ aux1 aux2 0 0 1 1 2 ] ;
		nelemCounter = nelemCounter + 1 ;
		npos = posnode ;
	end

end
