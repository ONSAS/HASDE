% Function that returns the ConecSd and NodesSd matrices
% ----------------------------------------------------------------------

function [ConecSd, NodesSd, nelemCounter, npos] = restructureSD(aux1, aux2, posnode, nelemCounter, NodesSd, ConecSd, nod1, nod2, Nodes)
	
	if length(aux1) == 0 && length(aux2) == 0
		ConecSd(nelemCounter,:) = [ posnode posnode+1 0 0 1 1 2 ] ;
		NodesSd = [ NodesSd ; Nodes(nod1,:) ; Nodes(nod2,:) ] ;
		nelemCounter = nelemCounter + 1 ; npos = posnode+2 ;
	elseif length(aux1) == 0 && length(aux2) == 1
		ConecSd(nelemCounter,:) = [ posnode aux2 0 0 1 1 2 ] ;
		NodesSd = [ NodesSd ; Nodes(nod1,:) ] ;
		nelemCounter = nelemCounter + 1 ; npos = posnode+1 ;
	elseif length(aux1) == 1 && length(aux2) == 0
		ConecSd(nelemCounter,:) = [ aux1 posnode 0 0 1 1 2 ] ;
		NodesSd = [ NodesSd ; Nodes(nod2,:) ] ;
		nelemCounter = nelemCounter + 1 ; npos = posnode+1 ; 
	elseif length(aux1) == 1 && length(aux2) == 1
		ConecSd(nelemCounter,:) = [ aux1 aux2 0 0 1 1 2 ] ;
		nelemCounter = nelemCounter + 1 ;
		npos = posnode ;
	end

end
