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
