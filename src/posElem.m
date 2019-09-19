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

% Function that returns the number of the element in ConecSd considering
% ----------------------------------------------------------------------

function [elem] = posElem(ConecSd, posNod1, posNod2)
	
	nelemsSd = size(ConecSd, 1) ;

	for m = 1:nelemsSd
		nodelem1 = ConecSd(m,1) ; nodelem2 = ConecSd(m,2) ;
		if nodelem1 == posNod1 && nodelem2 == posNod2 || nodelem2 == posNod1 && nodelem1 == posNod2 
			elem = m ;
		end
	end

end
