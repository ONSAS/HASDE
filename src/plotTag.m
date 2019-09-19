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

% Script that plot the tags of the distributed and nodal loads
% ----------------------------------------------------------------------

if exist('nodalConstantLoads') ~= 0 && norm(nodalConstantLoadsAux(:,2:end)) ~= 0
	for j = 1:size(handles3.nodalMat,1)
		tag = cell2mat( handles3.nodalMat(j,1) ) ;
		x		= cell2mat( handles3.nodalMat(j,3) ) ;
		z		= cell2mat( handles3.nodalMat(j,4) ) ;
		text(x,z, tag, 'fontsize', plotfontsize*.6, 'position',  [x-.1*strucsize, z+.1*strucsize] ) ;
	end
end

if exist('unifLoad') ~= 0 && size(unifLoad,1) ~= 0
	for j = 1:size(handles3.uniformMat,1)
		tag = cell2mat( handles3.uniformMat(j,1) ) ;
		x1	= cell2mat( handles3.uniformMat(j,4) ) ;
		z1	= cell2mat( handles3.uniformMat(j,5) ) ;
		x2	= cell2mat( handles3.uniformMat(j,6) ) ;
		z2	= cell2mat( handles3.uniformMat(j,7) ) ;
		if norm(z1-z2) < 1e-5
			text((x1+x2)/2,(z1+z2)/2, tag, 'fontsize', plotfontsize*.6, 'position',  [(x1+x2)/2, (z1+z2)/2+.175*strucsize] ) ;
		elseif norm(x1-x2) < 1e-5
			text((x1+x2)/2,(z1+z2)/2, tag, 'fontsize', plotfontsize*.6, 'position',  [(x1+x2)/2-.175*strucsize, (z1+z2)/2] ) ;
		end
	end
end

