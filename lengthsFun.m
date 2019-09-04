% Function that returns the a, b and ltot values to calculate the
% moment and shear reactions and the nodes A and B
% ----------------------------------------------------------------------

function [a, b, ltot, nodA, nodB] = lengthsFun(lenSum, lenSum2, i, currElemLen, currElemAngle, Nodes, nodeLoad, nodRep, otherElemNode)
	
	if currElemAngle == 1 % horizontal
			
		if Nodes(nodeLoad,1) - Nodes(nodRep,1) > 0
			a = lenSum ; b = currElemLen + lenSum2 ;
			nodA = nodRep ; nodB = otherElemNode ;
		else
			a = currElemLen + lenSum2 ; b = lenSum ;
			nodA = otherElemNode ; nodB = nodRep ;
		end 
		
	elseif currElemAngle == 0 % vertical
		
		if Nodes(nodeLoad,3) - Nodes(nodRep,3) > 0
			a = lenSum ; b = currElemLen ;
			nodA = nodRep ; nodB = otherElemNode ;
		else
			a = currElemLen ; b = lenSum ;
			nodA = otherElemNode ; nodB = nodRep ;
		end
		
	end
	
	ltot = a + b ;
	
end


