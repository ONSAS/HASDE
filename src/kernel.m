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

% Script that impose student unkowns to the ...
% condition matrix condMatrix and calculates the kernel associated
% ---------------------------------------------------------------------- 

condMatrix = handles.condMatrix ;
unkStudent = handles.unkStudent ;
propsNodes = handles.propsNodes ; 
nnodesSd = handles.nnodesSd ;
pos = handles.pos ;

for i = 1:size(unkStudent,1)
	for j = 1:3
		vec = zeros(1,3*nnodesSd) ;
		if unkStudent(i,j+1) == 1
			dof = dofsNumber( unkStudent(i,1), propsNodes)(j) ;
			vec(dof) = 1 ;
			condMatrix = [ condMatrix ; vec ] ; 
		end
	end
end

condMatrix(:,pos) = [] ;

handles.kernel = null(condMatrix) ; 
