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
