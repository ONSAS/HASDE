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


% Returns the dofs considering the SD dofs and pinned Nodes
% ----------------------------------------------------------------------

function [dofs] = dofsNumber( nodes, propsNodes )
	n = length(nodes) ;
	degreespernode = 3 ;
	dofs = [] ;
	for i = 1:n
		if ~ismember(nodes(i), propsNodes)
			dofs = [ dofs ; ((degreespernode*(nodes(i)-1))+(1:degreespernode))' ] ;
		else
			dofs = [ dofs ; ((3*(nodes(i)-1)) + (1:2))' ] ;
		end	
	end
end
