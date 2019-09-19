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

% Stores element lengths and element angle related to XG = [1 0 0]
% ----------------------------------------------------------------------

function [elemLengths, elemAngles] = elemXAngles(ConecSd, NodesSd, xG)
	
	nelemsSd = size(ConecSd,1) ;
	elemAngles  = zeros(nelemsSd,1) ;
	elemLengths = zeros(nelemsSd,1) ;
	
	for i = 1:nelemsSd
		[len,locglomat] = beamParameters( NodesSd( ConecSd(i,1:2),: ) ) ; 
		exL = locglomat(:,1)' ;
		elemAngles(i) 	= exL * xG ; 
		elemLengths(i)	= len ;
	end	

end
