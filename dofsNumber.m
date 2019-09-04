% Returns the dofs considering the SD dofs and pinned Nodes
% ----------------------------------------------------------------------

function [dofs] = dofsNumber( nodes, propsNodes )
	n = length(nodes) ;
	degreespernode = 3 ;
	dofs = [] ;
	for i = 1:n
		if ~ismember(nodes(i), propsNodes)
			dofs = [ dofs ; ((degreespernode*(nodes(i)-1))+(1:degreespernode))' ] ;
		else
			dofs = [ dofs ; ((3*(nodes(i)-1)) + (1:2))' ] ;
		end	
	end
end
