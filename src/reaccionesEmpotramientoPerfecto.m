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
