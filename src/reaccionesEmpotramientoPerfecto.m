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


% Function that returns the element moment and shear reactions due to ...
% nodal loads (distributed loads are first converted to nodal loads)
% ----------------------------------------------------------------------

function [Ma, Mb, Va, Vb] = reaccionesEmpotramientoPerfecto(supA, supB, nodalSpringsSd, nodalConstantLoads, a, b, ltot, posNode, elemAngleSd) 

	Px = nodalConstantLoads(posNode, 2) ;
	Pz = nodalConstantLoads(posNode, 6) ;
	My = nodalConstantLoads(posNode, 5) ;
	
	if elemAngleSd == 1 % Horizontal
		Va = -Pz * b / ltot ;
		Vb = -Pz * a / ltot ;
		if length(supA) > 0 && length(supB) > 0
			if nodalSpringsSd(supA, 5) == inf && nodalSpringsSd(supB, 5) == inf
				Ma = -Pz * a * b * b / ltot^2 - My * b * (2 - 3*b/ltot) / ltot ;
				Mb =  Pz * a * b * a / ltot^2 - My * a * (2 - 3*a/ltot) / ltot ;
			elseif nodalSpringsSd(supA, 5) == inf && nodalSpringsSd(supB, 5) == 0
				Ma = -Pz * a * b * ( ltot + b ) / (2 * ltot^2) - My * (1 - 3*(b/ltot)^2) / 2 ;
				Mb =  0 ;
			elseif nodalSpringsSd(supA, 5) == 0 && nodalSpringsSd(supB, 5) == inf
				Ma =  0 ;
				Mb =  Pz * a * b * ( ltot + a ) / (2 * ltot^2) - My * (1 - 3*(a/ltot)^2) / 2 ;
			end
		elseif length(supA) > 0 && length(supB) == 0
			if nodalSpringsSd(supA, 5) == inf 
				Ma = -Pz * a * b * b / ltot^2 - My * b * (2 - 3*b/ltot) / ltot ;
				Mb =  Pz * a * b * a / ltot^2 - My * a * (2 - 3*a/ltot) / ltot ;
			elseif nodalSpringsSd(supA, 5) == 0 
				Ma =  0 ;
				Mb =  Pz * a * b * a / ltot^2 - My * a * (2 - 3*a/ltot) / ltot ;
			end
		elseif length(supA) == 0 && length(supB) > 0
			if nodalSpringsSd(supB, 5) == inf 
				Ma = -Pz * a * b * b / ltot^2 - My * b * (2 - 3*b/ltot) / ltot ;
				Mb =  Pz * a * b * a / ltot^2 - My * a * (2 - 3*a/ltot) / ltot ;
			elseif nodalSpringsSd(supB, 5) == 0 
				Ma = -Pz * a * b * b / ltot^2 - My * b * (2 - 3*b/ltot) / ltot ; ;
				Mb =  0 ;
			end
		elseif length(supA) == 0 && length(supB) == 0
			Ma = -Pz * a * b * b / ltot^2 - My * b * (2 - 3*b/ltot) / ltot ;
			Mb =  Pz * a * b * a / ltot^2 - My * a * (2 - 3*a/ltot) / ltot ;
		end
	elseif elemAngleSd == 0 % Vertical
		Va = Px * b / ltot ;
		Vb = Px * a / ltot ;
		if length(supA) > 0 && length(supB) > 0
			if nodalSpringsSd(supA, 5) == inf && nodalSpringsSd(supB, 5) == inf
				Ma =  Px * a * b * b / ltot^2 - My * b * (2 - 3*b/ltot) / ltot ;
				Mb = -Px * a * b * a / ltot^2 - My * a * (2 - 3*a/ltot) / ltot ;
			elseif nodalSpringsSd(supA, 5) == inf && nodalSpringsSd(supB, 5) == 0
				Ma =  Px * a * b * ( ltot + b ) / (2 * ltot^2) - My * (1 - 3*(b/ltot)^2) / 2 ;
				Mb =  0 ;
			elseif nodalSpringsSd(supA, 5) == 0 && nodalSpringsSd(supB, 5) == inf
				Ma =  0 ;
				Mb = -Px * a * b * ( ltot + a ) / (2 * ltot^2) - My * (1 - 3*(a/ltot)^2) / 2 ;
			end
		elseif length(supA) > 0 && length(supB) == 0
			if nodalSpringsSd(supA, 5) == inf 
				Ma =  Px * a * b * b / ltot^2 - My * b * (2 - 3*b/ltot) / ltot ;
				Mb = -Px * a * b * a / ltot^2 - My * a * (2 - 3*a/ltot) / ltot ;
			elseif nodalSpringsSd(supA, 5) == 0 
				Ma =  0 ;
				Mb = -Px * a * b * a / ltot^2 - My * a * (2 - 3*a/ltot) / ltot ;
			end
		elseif length(supA) == 0 && length(supB) > 0
			if nodalSpringsSd(supB, 5) == inf 
				Ma =  Px * a * b * b / ltot^2 - My * b * (2 - 3*b/ltot) / ltot ;
				Mb = -Px * a * b * a / ltot^2 - My * a * (2 - 3*a/ltot) / ltot ;
			elseif nodalSpringsSd(supB, 5) == 0 
				Ma =  Px * a * b * b / ltot^2 - My * b * (2 - 3*b/ltot) / ltot ; ;
				Mb =  0 ;
			end
		elseif length(supA) == 0 && length(supB) == 0
			Ma =  Px * a * b * b / ltot^2 - My * b * (2 - 3*b/ltot) / ltot ;
			Mb = -Px * a * b * a / ltot^2 - My * a * (2 - 3*a/ltot) / ltot ;
		end
	end


end	
