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

% Function that returns the number of the node that is not internal
% the sum of lengths asociated to each iterationin the search 
% of that node it and the position relative to NodesSd
% ----------------------------------------------------------------------

function [auxparam, node, lenSum] = findSecondNode(Conec, nod, i, Nodes, NodesSd, nnodesSd, aux, internalNodeElems, elemLengths)
  boolStop = 0 ;
	lenSum = 0 ;
		
	while boolStop == 0
		elems = internalNodeElems(find(nod == internalNodeElems(:,1)),2:3) ;

		auxElems = elems ; 
		auxElems(find(elems==i)) = [] ;
		nodeAux = Conec(auxElems,find(Conec(auxElems,1:2) ~= nod)) ;
		lenSum = elemLengths(auxElems) + lenSum ;
		if ~ismember(nodeAux, internalNodeElems(:,1))
			node = nodeAux ;
			boolStop = 1 ;
		else
			nod = nodeAux ;
			i = auxElems ;
		end
	end 
  auxparam = aux ;
  
  if i~=1
    for j=1:nnodesSd
      if isequal(Nodes(node,:),NodesSd(j,:))
        auxparam = [j] ;
      end
    end
  end

end
