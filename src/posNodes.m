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

% Function that returns the position of the nodes nod1 and nod2 in the 
% matrix NodesSd
% ----------------------------------------------------------------------

function [posNod1, posNod2] = posNodes(Nodes, NodesSd, nod1, nod2)

	nnodesSd = size(NodesSd,1) ;
	
	for j = 1:nnodesSd
		if isequal(Nodes(nod1,:), NodesSd(j,:))
			posNod1 = j ;
		end
		if isequal(Nodes(nod2,:), NodesSd(j,:))
			posNod2 = j ;
		end
	end

end
