% Script that plot the tags of the distributed and nodal loads
% ----------------------------------------------------------------------

if exist('nodalConstantLoads') ~= 0 && norm(nodalConstantLoadsAux(:,2:end)) ~= 0
	for j = 1:size(handles3.nodalMat,1)
		tag = cell2mat( handles3.nodalMat(j,1) ) ;
		x		= cell2mat( handles3.nodalMat(j,3) ) ;
		z		= cell2mat( handles3.nodalMat(j,4) ) ;
		text(x,z, tag, 'fontsize', plotfontsize*.6, 'position',  [x-.1*strucsize, z+.1*strucsize] ) ;
	end
end

if exist('unifLoad') ~= 0 && size(unifLoad,1) ~= 0
	for j = 1:size(handles3.uniformMat,1)
		tag = cell2mat( handles3.uniformMat(j,1) ) ;
		x1	= cell2mat( handles3.uniformMat(j,4) ) ;
		z1	= cell2mat( handles3.uniformMat(j,5) ) ;
		x2	= cell2mat( handles3.uniformMat(j,6) ) ;
		z2	= cell2mat( handles3.uniformMat(j,7) ) ;
		if norm(z1-z2) < 1e-5
			text((x1+x2)/2,(z1+z2)/2, tag, 'fontsize', plotfontsize*.6, 'position',  [(x1+x2)/2, (z1+z2)/2+.175*strucsize] ) ;
		elseif norm(x1-x2) < 1e-5
			text((x1+x2)/2,(z1+z2)/2, tag, 'fontsize', plotfontsize*.6, 'position',  [(x1+x2)/2-.175*strucsize, (z1+z2)/2] ) ;
		end
	end
end

