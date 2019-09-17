% Enables the problem data panel
% ----------------------------------------------------------------------

set(handles.elementos		, 'visible', 'on')
set(handles.nodos				, 'visible', 'on')
set(handles.nodalLoads	, 'visible', 'on')
set(handles.unifoLoads	, 'visible', 'on')

% Stores elemMat
% ----------------------------------------------------------------------

elemMat = zeros(nelemsSd, 5) ;

for i = 1:nelemsSd
	nodeselem = ConecSd(i,1:2) ;
	elemMat(i,1) 	= i ;
	elemMat(i,2)	= nodeselem(1) ;
	elemMat(i,3)	= nodeselem(2) ; 
	elemMat(i,4)	= hyperElasParams{ConecSd(i,5)}(2) ;
	elemMat(i,5) 	= secGeomProps(ConecSd(i,6),2) ;
end

handles3.elemMat 	= elemMat ;

% Stores nodesMat
% ----------------------------------------------------------------------

nodesMat = [(1:nnodesSd)' NodesSd(:,1) NodesSd(:,3)] ;

handles3.nodesMat = nodesMat ;

% Stores nodalMat
% ----------------------------------------------------------------------

if exist('nodalConstantLoads') ~= 0 && norm(nodalConstantLoadsAux(:,2:end)) ~= 0
	nodalMat = cell(size(nodalConstantLoadsAux,1),4) ;

	Hcounter 	= 0 ;
	Pcounter 	= 0 ;
	Mcounter 	= 0 ;
	currRow 	= 1 ;

	for i = 1:size(nodalConstantLoadsAux,1)
		Hx 		= nodalConstantLoadsAux(i,1+1) ;
		Pz 		= nodalConstantLoadsAux(i,5+1) ;
		My 		= nodalConstantLoadsAux(i,4+1) ;
		nodx 	= Nodes(nodalConstantLoadsAux(i,1),1) ;
		nodz 	= Nodes(nodalConstantLoadsAux(i,1),3) ;
		
		if Hx ~= 0
			Hcounter = Hcounter + 1 ;
			nodalMat(currRow,1) = sprintf('H_%i', Hcounter) ;
			nodalMat(currRow,2) = abs(Hx) ;
			nodalMat(currRow,3) = nodx ; nodalMat(currRow,4) = nodz ;
			currRow = currRow + 1 ;
		end
		
		if Pz ~= 0
			Pcounter = Pcounter + 1 ;
			nodalMat(currRow,1) = sprintf('P_%i', Pcounter) ;
			nodalMat(currRow,2) = abs(Pz) ;
			nodalMat(currRow,3) = nodx ; nodalMat(currRow,4) = nodz ;
			currRow = currRow + 1 ;
		end
		
		if My ~= 0
			Mcounter = Mcounter + 1 ;
			nodalMat(currRow,1) = sprintf('M_%i', Mcounter) ;
			nodalMat(currRow,2) = abs(My) ;
			nodalMat(currRow,3) = nodx ; nodalMat(currRow,4) = nodz ;
			currRow = currRow + 1 ;
		end
		
	end 

else
	nodalMat = zeros(1,4) ;
end

handles3.nodalMat = nodalMat ;

% Stores uniformMat
% ----------------------------------------------------------------------

if exist('unifLoad') ~= 0 && size(unifLoad,1) ~= 0

	uniformMat = cell(size(unifLoad,1), 7) ;

	qxCounter = 0 ;
	qzCounter = 0 ;
	currRow		= 1 ;

	for i = 1:size(unifLoad,1)
		gloBool = unifLoad(i,2) ;
		qx = unifLoad(i,3) ;
		qz = unifLoad(i,5) ;
		x1 = Nodes(Conec(unifLoad(i,1),1),1) ; z1 = Nodes(Conec(unifLoad(i,1),1),3) ;
		x2 = Nodes(Conec(unifLoad(i,1),2),1) ; z2 = Nodes(Conec(unifLoad(i,1),2),3) ;

		if qx ~= 0
			qxCounter = qxCounter + 1 ;
			uniformMat(currRow,1) = sprintf('q_{x%i}', qxCounter) ;
			uniformMat(currRow,2) = abs(qx) ;
			uniformMat(currRow,3) = gloBool ;
			uniformMat(currRow,4) = x1 ; uniformMat(currRow,5) = z1 ;
			uniformMat(currRow,6) = x2 ; uniformMat(currRow,7) = z2 ;
			currRow = currRow + 1 ;
		end
		
		if qz ~= 0
			qzCounter = qxCounter + 1 ;
			uniformMat(currRow,1) = sprintf('q_{z%i}', qzCounter) ;
			uniformMat(currRow,2) = abs(qz) ;
			uniformMat(currRow,3) = gloBool ;
			uniformMat(currRow,4) = x1 ; uniformMat(currRow,5) = z1 ;
			uniformMat(currRow,6) = x2 ; uniformMat(currRow,7) = z2 ;
			currRow = currRow + 1 ;
		end
	end
	
else
	uniformMat = zeros(1,7) ;
end

handles3.uniformMat = uniformMat ;
