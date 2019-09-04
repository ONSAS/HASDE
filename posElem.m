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
