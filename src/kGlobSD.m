% ==============================================================================
% --------     HASDE: una Herramienta abierta de Aprendizaje interactivo 
%                                   del Metodo de Slope Deflection      --------
%~ Copyright (C) 2019, Joaquin Viera, Jorge M. Perez Zerpa

%~ This file is part of HASDE.

%~ HASDE is free software: you can redistribute it and/or modify
%~ it under the terms of the GNU General Public License as published by
%~ the Free Software Foundation, either version 3 of the License, or
%~ (at your option) any later version.

%~ HASDE is distributed in the hope that it will be useful,
%~ but WITHOUT ANY WARRANTY; without even the implied warranty of
%~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%~ GNU General Public License for more details.

%~ You should have received a copy of the GNU General Public License
%~ along with HASDE.  If not, see <https://www.gnu.org/licenses/>.

% ==============================================================================

% Kglob. verif. and dofs storage
% ----------------------------------------------------------------------

% Run ONSAS - variables from SD input
Nodes = handles.NodesSd ;
Conec = handles.ConecSd ;
nodalSprings = handles.nodalSpringsSd ;
nnodes = handles.nnodesSd ;
nelems = handles.nelemsSd ;
constantFext = zeros(nnodes*6,1) ;

environInputVars = 1 ;
secGeomProps = handles.secGeomProps ;
hyperElasParams =	handles.hyperElasParams ;
inputONSASversion =	handles.inputONSASversion ;
problemName =	handles.problemName ;
nonLinearAnalysisBoolean = handles.nonLinBool ;
dynamicAnalysisBoolean = handles.dynBool ;
plotParamsVector  = [0] ;
printflag         = 0   ;
analyticSolFlag   = 0   ;

cd (handles.onsasPath)
ONSAS
cd (handles.currDir)

% SD variables
nnodesSd = nnodes ;
NodesSd = Nodes ;
ndofpnode = 6 ;


indLevel 		= 1 	;
nodesLevel 	= cell ;
zCoordVec 	= [] 	;

for j = 1:nnodesSd
	znod = NodesSd(j,3) ;
	if j == 1
		zCoordVec 	= [ zCoordVec ; znod ] ;
		nodesLevel{indLevel}= [j] ;
	else
		if ismember(znod, zCoordVec)
			nodesLevel{indLevel}= [ nodesLevel{indLevel} j ] ;
		else
			zCoordVec 	= [ zCoordVec ; znod ] ;
			indLevel = indLevel + 1 ;
			nodesLevel{indLevel}= [j] ;
		end
	end
end

nodesDelta = unkStudent(find( unkStudent(:,2) == 1 ), 1) ;

nodesDeltaSd = [] ;

for i = 1:size(nodesLevel,2)
	nodesVec = nodesLevel{i} ;
	nodeBool = 0 ;
	for j = 1:length(nodesDelta)
		if ismember(nodesDelta(j), nodesVec) && ~ismember(nodesDelta(j), nodesDeltaSd) && nodeBool == 0
			nodeBool = 1 ;
			nodesDeltaSd = [ nodesDeltaSd ; nodesDelta(j) nodesVec(find(nodesDelta(j)~=nodesVec(:))) ] ; 
		end
	end
end

deltaDofs 		= nodes2dofs(nodesDeltaSd(:,1), ndofpnode)( 1:6:end ) ;

deltaAuxDofs = zeros(length(nodesDelta), size(nodesDeltaSd(1,2:end),2)) ;
for i = 1:length(deltaDofs)
	deltaAuxDofs(i,:) = nodes2dofs(nodesDeltaSd(i,2:end), ndofpnode)( 1:6:end ) ;
end

nodesThetaSd = unkStudent(find( unkStudent(:,3) == 1 ),1) ;

thetaDofs = nodes2dofs(nodesThetaSd, ndofpnode)( 4:6:end ) ;

dofsVec = [ thetaDofs' deltaDofs' ] ;


c = full(KG) ;

for i = 1:length(deltaDofs)
	c(deltaDofs(i),:) = c(deltaDofs(i),:) ;
	c(:,deltaDofs(i)) = c(:,deltaDofs(i)) ;
	for j = 1:length(deltaAuxDofs(i,:))
		c(deltaDofs(i),:) = c(deltaDofs(i),:) + c(deltaAuxDofs(i,j),:) ;
		c(:,deltaDofs(i)) = c(:,deltaDofs(i)) + c(:,deltaAuxDofs(i,j)) ;
	end
	
	aux = find(deltaDofs(i) == deltaDofs) ;
	auxDofsVec = deltaDofs ;
	auxDofsVec(aux:end) = [] ;
	sumDeltas = 0 ;
	
	
	for j = 1:length(auxDofsVec)
		sumDeltas = sumDeltas + c(:,auxDofsVec(j)) ;
	end
	
	c(:, deltaDofs(i)) = c(:,deltaDofs(i)) + sumDeltas ;

end 

auxNodesThetaSd = [] ;

for j = 1:length(nodesThetaSd)
	auxCol1 = find(ConecSd(:,1) == nodesThetaSd(j)) ;
	auxCol2 = find(ConecSd(:,2) == nodesThetaSd(j)) ;
	dofTheta = nodes2dofs(nodesThetaSd(j), ndofpnode)(4) ;
	for i = 1: length(auxCol1)
		nod2 = ConecSd(auxCol1(i), 2) ;
		if ismember( nod2, pinnedNodes )
			elem = posElem(ConecSd, auxCol1, nod2) ;
			auxNodesThetaSd = [ auxNodesThetaSd ; nodesThetaSd(j) nod2 dofTheta elem ] ;
		end
	end
	for i = 1: length(auxCol2)
		nod1 = ConecSd(auxCol2(i), 1) ;
		if ismember( nod1, pinnedNodes )
			elem = posElem(ConecSd, nod1, auxCol2) ;
			auxNodesThetaSd = [ auxNodesThetaSd ; nodesThetaSd(j) nod1 dofTheta elem ] ;
		end
	end
end

for j = 1:size(auxNodesThetaSd,1)
	nod 	= auxNodesThetaSd(j,2) ;
	dof 	= auxNodesThetaSd(j,3) ;
	elem 	= auxNodesThetaSd(j,4) ;
	E 		= hyperElasParams{ConecSd(elem,5)}(2) ;
	Iy 		= secGeomProps(ConecSd(elem,6), 2) ;
	l 		= elemLengthsSd(elem) ;
	c(dof,dof) = c(dof,dof) - E*Iy/l ;
end

handles.dofsVec = dofsVec ;

% dofsVec for ONSAS

aux = [nodesThetaSd ; nodesDelta] ;
nodesONSASunk = [] ;

nnodesTot = handles.nnodesTot ;
NodesO 		= handles.NodesO ;

auxDelta 	= [] ;
auxdofs 	= [] ;

for i = 1:size(aux,1)
	nod = aux(i) ;
	for j = 1:nnodesTot
		if isequal(Nodes(nod,:), NodesO(j,:))
			nodesONSASunk = [ nodesONSASunk ; j ] ; 
			if ismember(nod, nodesThetaSd) && ismember(nod, nodesDelta)
				if ~ismember(nodes2dofs(j,ndofpnode)(4), auxdofs)
					auxdofs = [auxdofs ; nodes2dofs(j,ndofpnode)(4)] ;
				end
				if ~ismember(nodes2dofs(j,ndofpnode)(1), auxDelta)
					auxDelta = [auxDelta ; nodes2dofs(j,ndofpnode)(1) ] ;
				end
			elseif ismember(nod, nodesThetaSd)
				if ~ismember(nodes2dofs(j,ndofpnode)(4), auxdofs)
					auxdofs = [auxdofs ; nodes2dofs(j,ndofpnode)(4)] ;
				end
			elseif ismember(nod, nodesDelta)
				if ~ismember(nodes2dofs(j,ndofpnode)(1), auxDelta)
					auxDelta = [auxDelta ; nodes2dofs(j,ndofpnode)(1)] ;
				end
			end
		end
	end
end

dofsONSAS = [auxdofs ; auxDelta] ;

handles.deltaUnks = length(nodesDelta) ;


