% Stores element lengths and element angle related to XG = [1 0 0]
% ----------------------------------------------------------------------

function [elemLengths, elemAngles] = elemXAngles(ConecSd, NodesSd, xG)
	
	nelemsSd = size(ConecSd,1) ;
	elemAngles  = zeros(nelemsSd,1) ;
	elemLengths = zeros(nelemsSd,1) ;
	
	for i = 1:nelemsSd
		[len,locglomat] = beamParameters( NodesSd( ConecSd(i,1:2),: ) ) ; 
		exL = locglomat(:,1)' ;
		elemAngles(i) 	= exL * xG ; 
		elemLengths(i)	= len ;
	end	

end
