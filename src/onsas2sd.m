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

% General script that converts some of the structure properties to ...
% Slope deflection hypthesis
% ----------------------------------------------------------------------

% General parameters
% ----------------------------------------------------------------------
ndofpnode = 6 ;
nelemsTot = size(Conec,1) ;
nnodesTot = size(Nodes,1) ;

xG = [ 1 0 0 ]' ;
elemAngles 					= zeros(nelemsTot,1) ;
elemLengths 				= zeros(nelemsTot,1) ;
internalNodeElems 	= [] ; % matrix with internal nodes with nodal forces and the elements concurrent to that node ... structure  [node elem1 elem2]

% Elements angle
% ----------------------------------------------------------------------
for i = 1:nelemsTot
	[len,locglomat] = beamParameters( Nodes( Conec(i,1:2),: ) ) ; 
	exL = locglomat(:,1)' ;
	elemAngles(i) 	= exL * xG ; 
	elemLengths(i) 	= len ; 
end

% Elements uniform loads
% ----------------------------------------------------------------------

nodalConstantLoadsAux = zeros(nnodesTot,7) ;
if exist('nodalConstantLoads') ~= 0
	nodesConst = nodalConstantLoads(:,1) ;
	nodalConstantLoadsAux(nodesConst,2:end) = nodalConstantLoads(:,2:end) ;
else
	nodesConst = [] ;
end

if exist('unifLoad') == 0
	unifLoad = [] ;
end

if length(unifLoad) > 0
  uniform2nodal
  auxUnif = find(nodalUniformLoads(:,1) == 0) ;
  nodalUniformLoads(auxUnif,:) = [] ;
	nodesUnif 	= nodalUniformLoads(:,1) ;
else
  nodalUniformLoads = zeros(nnodesTot,7) ;
	auxUnif = find(nodalUniformLoads(:,1) == 0) ;
  nodalUniformLoads(auxUnif,:) = [] ;
	nodesUnif = [] ;
end

nodalConstantLoads = zeros(nnodesTot, 7) ;

nodalConstantLoads(nodesConst,1) = nodesConst ;
nodalConstantLoads(nodesConst,2:end) = nodalConstantLoadsAux(nodesConst,2:end) ;

nodalConstantLoads(nodesUnif,1) = nodesUnif ;
nodalConstantLoads(nodesUnif, 2:end) = nodalConstantLoads(nodesUnif,2:end) + nodalUniformLoads(:,2:end) ;

aux = find(nodalConstantLoads(:,1) == 0)                    ;
nodalConstantLoads(aux,:) = []                              ;
nodesF = nodalConstantLoads(:,1)                            ;


% Internal element with forces
% ----------------------------------------------------------------------
for i = 1:nnodesTot
   nCol1_1 = find(Conec(:,1) == i) ; nCol2_1 = find(Conec(:,2) == i) ;
  if (length(nCol1_1) == 1 && length(nCol2_1) == 1 ) && norm( abs(elemAngles(nCol1_1)) - abs(elemAngles(nCol2_1)) ) <= 1e-12 
    internalNodeElems = [ internalNodeElems ; i nCol1_1 nCol2_1] ;
  elseif (length(nCol1_1) == 2 && length(nCol2_1) == 0 ) && norm( abs(elemAngles(nCol1_1)(1)) - abs(elemAngles(nCol1_1)(2)) ) <= 1e-12  
    internalNodeElems = [ internalNodeElems ; i nCol1_1'] ;
  elseif (length(nCol1_1) == 0 && length(nCol2_1) == 2 ) && norm( abs(elemAngles(nCol2_1)(1)) - abs(elemAngles(nCol2_1)(2)) ) <= 1e-12  
    internalNodeElems = [ internalNodeElems ; i nCol2_1'] ;
  end   
end

% Restructure of Conec, Nodes, nodalSprings
% ----------------------------------------------------------------------
nelemsSd      = nelemsTot-size(internalNodeElems,1) ;
ConecSd       = zeros(nelemsSd,7) ;
NodesSd       = []                ;
npos          = 1                 ;
nelemCounter  = 1                 ;
nodesDel      = []                ;
nodesRep      = []                ;

% NodesSd, ConecSd
if size(internalNodeElems,1) > 0
	for i = 1:nelemsTot
		nod1      = Conec(i,1)        ; aux1 = [] ;
		nod2      = Conec(i,2)        ; aux2 = [] ; 
		auxelem   = 0                 ;
		nnodesSd  = size(NodesSd,1)   ;
		if i~=1
			for j = 1:nnodesSd
				if isequal(Nodes(nod1,:),NodesSd(j,:))
					aux1 = [j] ;
				elseif isequal(Nodes(nod2,:),NodesSd(j,:))	
					aux2 = [j] ;
				end	
			end
		end
		%
		if ~ismember(nod1,internalNodeElems(:,1)) && ~ismember(nod2,internalNodeElems(:,1))
      [ConecSd, NodesSd, nelemCounter, npos] = restructureSD(aux1, aux2, npos, nelemCounter, NodesSd, ConecSd, nod1, nod2, Nodes) ;
		elseif ~ismember(nod1,internalNodeElems(:,1)) && ismember(nod2,internalNodeElems(:,1))
			if ismember(nod2, internalNodeElems) && length(aux1) == 0
				[aux2, nodRep2] = findSecondNode(Conec, nod2, i, Nodes, NodesSd, nnodesSd, aux2, internalNodeElems, elemLengths) ;
				nodesRep = [ nodesRep ; nod2 nodRep2 ] ;
				[ConecSd, NodesSd, nelemCounter, npos] = restructureSD(aux1, aux2, npos, nelemCounter, NodesSd, ConecSd, nod1, nodRep2, Nodes) ;
			end
		elseif ismember(nod1,internalNodeElems(:,1)) && ~ismember(nod2,internalNodeElems(:,1))	    
			if ismember(nod1, internalNodeElems) && length(aux2)==0
				[aux1, nodRep1] = findSecondNode(Conec, nod1, i, Nodes, NodesSd, nnodesSd, aux1, internalNodeElems, elemLengths) ;
				nodesRep = [ nodesRep ; nod1 nodRep1 ] ;
				[ConecSd, NodesSd, nelemCounter, npos] = restructureSD(aux1, aux2, npos, nelemCounter, NodesSd, ConecSd, nodRep1, nod2, Nodes) ;
			end
    end % endif node in internalNodeElems
    %
  end % endfor nelemesTot
else
	ConecSd = Conec ;
	NodesSd = Nodes ;
end

% nodalSpringsSd
nnodesSd        = size(NodesSd,1) ;
nodalSpringsSd  = nodalSprings    ;
pinnedNodes     = []              ;
for i = 1:size(nodalSprings,1)
  coordNodes = Nodes(nodalSprings(i,1),:) ;
  for j = 1:nnodesSd
    if isequal(NodesSd(j,:),coordNodes)
      nodalSpringsSd(i,1) = j ;
    end
  end
  if nodalSpringsSd(i,1+4) == 0 
    if ( nodalSpringsSd(i,1+1) ==   0  && nodalSpringsSd(i,1+5) == inf ) || ...
       ( nodalSpringsSd(i,1+1) == inf  && nodalSpringsSd(i,1+5) == inf ) || ...
       ( nodalSpringsSd(i,1+1) == inf  && nodalSpringsSd(i,1+5) ==   0 ) 
      pinnedNodes = [ pinnedNodes, nodalSpringsSd(i,1) ] ;
    end  
  end  
end

% Kernel matrix
% ----------------------------------------------------------------------
gdls       = [] ;
condMatrix = [] ;
fixedgdls  = 0  ;
freeEnds 	 = [] ;
fixeddofs  = [] ;
elemLengthsSd = zeros(nelemsSd,1) ;


for i = 1:nnodesSd
	gdlnode = nodes2dofs(i, ndofpnode)([1 4 5]) ;
	gdls = [ gdls ; gdlnode ] ;
	% Free ends
	ncol1 = find(ConecSd(:,1) == i) ; ncol2 = find(ConecSd(:,2) == i) ;
	if ( ( length(ncol1) == 1 && length(ncol2) == 0 ) || ( length(ncol1) == 0 && length(ncol2) == 1 ) ) && ~ismember(i, nodalSpringsSd(:,1))
		freeEnds = [ freeEnds ; i ] ;
	end
end

propsNodes = [pinnedNodes ; freeEnds] ;

for i = 1:size(nodalSpringsSd,1)
	gdlnode = nodes2dofs(nodalSpringsSd(i,1), ndofpnode)([1 4 5]) ;
	for j = 1:ndofpnode
	vec = zeros(1,3*nnodesSd) ;
		if nodalSprings(i,1+j) == inf 
			if j == 1
				aux = find(gdls(:) == gdlnode(1)) ;
				vec(1,aux) = 1 ;
				condMatrix = [ condMatrix ; vec ] ;
        fixedgdls = fixedgdls + 1 ;
        fixeddofs = [ fixeddofs ; dofsNumber(nodalSpringsSd(i,1),[])(1) ] ;
      elseif j == 4
        if ~ismember(nodalSpringsSd(i,1), pinnedNodes)
          aux = find(gdls(:) == gdlnode(2)) ;
          vec(1,aux) = 1 ;
          condMatrix = [ condMatrix ; vec ] ;
          fixedgdls = fixedgdls + 1 ;
          fixeddofs = [ fixeddofs ; dofsNumber(nodalSpringsSd(i,1),[])(2) ] ;
        end
			elseif j == 5
				aux = find(gdls(:) == gdlnode(3)) ;
				vec(1,aux) = 1 ;
				condMatrix = [ condMatrix ; vec ] ;	
        fixedgdls = fixedgdls + 1 ;
        fixeddofs = [ fixeddofs ; dofsNumber(nodalSpringsSd(i,1),[])(3) ] ;
      end	
		end
	end
end

for i = 1:nelemsSd
	node1 = ConecSd(i,1) ; node2 = ConecSd(i,2) ;
	gdlnodes = nodes2dofs([node1,node2], ndofpnode)([1 4 5 1+6 4+6 5+6]) ;
	[l,locglomat] = beamParameters( NodesSd(ConecSd(i,1:2),: ) ) ;
	elemLengthsSd(i) = l ;
	R = zeros(2*3, 2*3) ;
	R(1:3,1:3) = locglomat ; R(4:6,4:6) = locglomat ;
	constraint = R * [-1 0 0 1 0 0]' ;
	vec = zeros(1,3*nnodesSd) ;
	for j = 1:6
		gdlnodes(j) ;
		aux = find(gdls(:) == gdlnodes(j) ) ; 
		if constraint(j) ~= 0
			vec(1,aux) = constraint(j) ;
		end
	end
	condMatrix = [ condMatrix ; vec ] ;		
end

aux = nodes2dofs(propsNodes, ndofpnode)([4:6:end]) ;
pos = [] ;
for i = 1:size(aux,1) 
  pos = [ pos ; find(aux(i) == gdls(:)) ] ;
end
handles.pos = pos ;
gdls(pos,:) = [] ;

% Unkowns number
% ----------------------------------------------------------------------

onsasIncNumber = nnodesSd*3 - nelemsSd - length(propsNodes) - fixedgdls ; 

% Nodal and Uniform forces to SD
% ----------------------------------------------------------------------

currMom	= [] 	;
a 			= 0 	;
b 			= 0 	;
nnodesSd 	= size(NodesSd,1) ;
nodalConstantLoadsSD 	= zeros(nnodesSd,7) ;
elemNodalLoads 				= zeros(nelemsSd,7) ;

% Element orientation
[elemLenghtsSd, elemAnglesSd] = elemXAngles(ConecSd, NodesSd, xG) ;

for i = 1:nelemsTot
	nod1 = Conec(i,1) ; nod2 = Conec(i,2) ;
	%
	if size(internalNodeElems,1) == 0 || ~ismember(nod1, internalNodeElems(:,1)) && ~ismember(nod2, internalNodeElems(:,1))
		[posNod1, posNod2] = posNodes(Nodes, NodesSd, nod1, nod2) ;
		[elem] = posElem(ConecSd, posNod1, posNod2) ;
		if ismember(nod1, nodesF)
			currMom = [ currMom ; nod1 ] ;
			posO = find(nod1 == nodesF(:)) ;
			nodalConstantLoadsSD(posNod1,1) = posNod1 ;	nodalConstantLoadsSD(posNod1,2:end) = nodalConstantLoads(posO,2:end) + nodalConstantLoadsSD(posNod1, 2:end);
			if ismember(nod1, nodesUnif)
				elemNodalLoads(elem,1) = elem ; elemNodalLoads(elem,2) = posNod1 ; elemNodalLoads(elem,5) = posNod2 ;
				pos = find(nodesUnif(:) == nod1) ;
				if elemAnglesSd(elem) == 1 % horizontal
					elemNodalLoads(elem,3) = elemNodalLoads(elem,3) + nodalUniformLoads(pos,5+1) ;
				elseif elemAnglesSd(elem) == 0 % vertical
					elemNodalLoads(elem,3) = elemNodalLoads(elem,3) + nodalUniformLoads(pos,1+1) ;
				end
				elemNodalLoads(elem,4) = elemNodalLoads(elem,4) + nodalUniformLoads(pos,4+1) ;
			end
		end
		if ismember(nod2, nodesF)
			currMom = [ currMom ; nod2 ] ;
			posO = find(nod2 == nodesF(:)) ;
			nodalConstantLoadsSD(posNod2,1) = posNod2 ; nodalConstantLoadsSD(posNod2,2:end) = nodalConstantLoads(posO,2:end) + nodalConstantLoadsSD(posNod2, 2:end);
			if ismember(nod2, nodesUnif)
				elemNodalLoads(elem,1) = elem ; elemNodalLoads(elem,2) = posNod1 ; elemNodalLoads(elem,5) = posNod2 ;
				posNod2 = find(nodesUnif(:) == nod2) ;
				if elemAnglesSd(elem) == 1 % horizontal
					elemNodalLoads(elem,6) = elemNodalLoads(elem,6) + nodalUniformLoads(posNod2,5+1) ;
				elseif elemAnglesSd(elem) == 0 % vertical
					elemNodalLoads(elem,6) = elemNodalLoads(elem,6) + nodalUniformLoads(posNod2,1+1) ;
				end
				elemNodalLoads(elem,7) = elemNodalLoads(elem,7) + nodalUniformLoads(posNod2,4+1) ;
			end
		end
	elseif ~ismember(nod1, internalNodeElems(:,1)) && ismember(nod2, internalNodeElems(:,1))
		if ismember(nod2, nodesF) && ~ismember(nod2, currMom)
			
			[~, nodRep2, lenSum] = findSecondNode(Conec, nod2, i, Nodes, NodesSd, nnodesSd, aux2, internalNodeElems, elemLengths) ;
			currMom = [currMom ; nod2] ;
			lenSum2 = 0 ;
			% Lengths
			[a, b, ltot, nodA, nodB] = lengthsFun(lenSum, lenSum2, i, elemLengths(i), elemAngles(i), Nodes, nod2, nodRep2, nod1) ;
			[nodA, nodB] = posNodes(Nodes, NodesSd, nodA, nodB) ;
			% Node with nodal force position
			posNode = find( nod2 == nodesF(:) ) ;
			% Nodes with supports
			supA = find(nodalSpringsSd(:,1) == nodA) ; supB = find(nodalSpringsSd(:,1) == nodB) ;
			% Elem and nodes position
			[posNod1, node2] = posNodes(Nodes, NodesSd, nod1, nodRep2) ;
			[elem] = posElem(ConecSd, posNod1, node2) ;
			% Reactions
			[Ma, Mb, Va, Vb] = reaccionesEmpotramientoPerfecto(supA, supB, nodalSpringsSd, nodalConstantLoads, a, b, ltot, posNode, elemAnglesSd(elem)) ;
			% Elem nodal loads matrix: structure -- elem nodA Va Ma nodB Vb Mb
			elemNodalLoads(elem,1) = elem ; elemNodalLoads(elem,2) = nodA ; elemNodalLoads(elem,5) = nodB ;
			elemNodalLoads(elem,4) = elemNodalLoads(elem,4) + Ma ; elemNodalLoads(elem,7) = elemNodalLoads(elem,7) + Mb ;
			elemNodalLoads(elem,3) = elemNodalLoads(elem,3) + Va ; elemNodalLoads(elem,6) = elemNodalLoads(elem,6) + Vb ;
		end
		% Forces on nodes that are not internal
		if ismember(nod1, nodesF) && ~ismember(nod1, currMom) && size(unifLoad,1) > 0
			currMom = [ currMom ; nod1 ] ;
			posNod1 = 0 ;
			[posNod1, ~] = posNodes(Nodes, NodesSd, nod1, []) ;
			auxposNod1 = find( nod1 == nodalConstantLoads(:,1) ) ;
			nodalConstantLoadsSD(posNod1,1) = posNod1 ; nodalConstantLoadsSD(posNod1,2:end) = nodalConstantLoads(auxposNod1,2:end) + nodalConstantLoadsSD(posNod1, 2:end);
			auxPosUnif = find( i == unifLoad(:,1) ) ;
			if ismember(nod1, nodesUnif) && ( nod1 == Conec(auxPosUnif,1) ) && ( nod2 == Conec(auxPosUnif,2) ) 
				pos = find(nod1 == nodesUnif) ;
				elemNodalLoads(elem,4) = elemNodalLoads(elem,4) + nodalUniformLoads(pos,4+1) ;
				if elemAnglesSd(elem) == 1 % horizontal
					elemNodalLoads(elem,3) = elemNodalLoads(elem,3) + nodalUniformLoads(pos,5+1) ;
				elseif elemAnglesSd(elem) == 0
				 elemNodalLoads(elem,3) = elemNodalLoads(elem,3) + nodalUniformLoads(pos,1+1) ;
				end 
			end
		end
	%
	elseif ismember(nod1, internalNodeElems(:,1)) && ~ismember(nod2, internalNodeElems(:,1))		
		if ismember(nod1, nodesF) && ~ismember(nod1, currMom)
			[~, nodRep1, lenSum] = findSecondNode(Conec, nod1, i, Nodes, NodesSd, nnodesSd, aux1, internalNodeElems, elemLengths) ;
			currMom = [currMom ; nod1] ;		
			lenSum2 = 0 ;
			% Lengths
			[a, b, ltot, nodA, nodB] = lengthsFun(lenSum, lenSum2, i, elemLengths(i), elemAngles(i), Nodes, nod1, nodRep1, nod2)
			[nodA, nodB] = posNodes(Nodes, NodesSd, nodA, nodB) ;
			% Node with nodal force position
			posNode = find( nod1 == nodesF(:) ) ;
			% Nodes with supports
			supA = find(nodalSpringsSd(:,1) == nodA) ; supB = find(nodalSpringsSd(:,1) == nodB) ;
			% Elem and nodes position
			[posNod1, node2] = posNodes(Nodes, NodesSd, nodRep1, nod2) ;
			[elem] = posElem(ConecSd, posNod1, node2) ;
			% Reactions
			[Ma, Mb, Va, Vb] = reaccionesEmpotramientoPerfecto(supA, supB, nodalSpringsSd, nodalConstantLoads, a, b, ltot, posNode, elemAnglesSd(elem)) ; 

			% Elem nodal loads matrix: structure -- elem nodA Va Ma nodB Vb Mb
			elemNodalLoads(elem,1) = elem ; elemNodalLoads(elem,2) = nodA ; elemNodalLoads(elem,5) = nodB ;
			elemNodalLoads(elem,4) = elemNodalLoads(elem,4) + Ma ; elemNodalLoads(elem,7) = elemNodalLoads(elem,7) + Mb ;
			elemNodalLoads(elem,3) = elemNodalLoads(elem,3) + Va ; elemNodalLoads(elem,6) = elemNodalLoads(elem,6) + Vb ;
		end
		% Forces on nodes that are no internal
		if ismember(nod2, nodesF) && ~ismember(nod2, currMom) && size(unifLoad,1) > 0 
			currMom = [ currMom ; nod2 ] ;
			posNod2 = 0 ;
			[posNod2, ~] = posNodes(Nodes, NodesSd, nod2, []) ;
			auxposNod2 = find( nod2 == nodalConstantLoads(:,1) ) ;
			nodalConstantLoadsSD(posNod2,1) = posNod2 ;	nodalConstantLoadsSD(posNod2,2:end) = nodalConstantLoads(auxposNod2,2:end) + nodalConstantLoadsSD(posNod2, 2:end) ;
			auxPosUnif = find( i == unifLoad(:,1) ) ;
			if ismember(nod2, nodesUnif) && ( nod1 == Conec(auxPosUnif,1) ) && ( nod2 == Conec(auxPosUnif,2) ) 
				pos = find(nod2 == nodesUnif) ;
				elemNodalLoads(elem,7) = elemNodalLoads(elem,7) + nodalUniformLoads(pos,4+1) ;
				if elemAnglesSd(elem) == 1 
					elemNodalLoads(elem,6) = elemNodalLoads(elem,6) + nodalUniformLoads(pos,5+1) ;
				elseif elemAnglesSd(elem) == 0
				 elemNodalLoads(elem,6) = elemNodalLoads(elem,6) + nodalUniformLoads(pos,1+1) ;
				end 
			end
		end
	%	
	elseif ismember(nod1, internalNodeElems(:,1)) && ismember(nod2, internalNodeElems(:,1))
		if ismember(nod1, nodesF) && ~ismember(nod1, currMom)
			[	~, nodRep1, lenSum	] = findSecondNode(Conec, nod1, i, Nodes, NodesSd, nnodesSd, aux1, internalNodeElems, elemLengths) ;
			[	~, nodRep2, lenSum2	] = findSecondNode(Conec, nod2, i, Nodes, NodesSd, nnodesSd, aux2, internalNodeElems, elemLengths) ;
			currMom = [currMom ; nod1] ;																	
			% Lengths
			[a, b, ltot, nodA, nodB] = lengthsFun(lenSum, lenSum2, i, elemLengths(i), elemAngles(i), Nodes, nod1, nodRep1, nodRep2) ;
			[nodA, nodB] = posNodes(Nodes, NodesSd, nodA, nodB) ;
			% Node with nodal force position
			posNode = find( nod1 == nodesF(:) ) ;
			% Nodes with supports
			supA = find(nodalSpringsSd(:,1) == nodA) ; supB = find(nodalSpringsSd(:,1) == nodB) ;
			% Elem and nodes position
			[posNod1, node2] = posNodes(Nodes, NodesSd, nodRep1, nodRep2) ;
			[elem] = posElem(ConecSd, posNod1, node2) ;
			% Reactions
			[Ma, Mb, Va, Vb] = reaccionesEmpotramientoPerfecto(supA, supB, nodalSpringsSd, nodalConstantLoads, a, b, ltot, posNode, elemAnglesSd(elem)) ; 
			% Elem nodal loads matrix: structure -- elem nodA Va Ma nodB Vb Mb
			elemNodalLoads(elem,1) = elem ; elemNodalLoads(elem,2) = nodA ; elemNodalLoads(elem,5) = nodB ;
			elemNodalLoads(elem,4) = elemNodalLoads(elem,4) + Ma ; elemNodalLoads(elem,7) = elemNodalLoads(elem,7) + Mb ;
			elemNodalLoads(elem,3) = elemNodalLoads(elem,3) + Va ; elemNodalLoads(elem,6) = elemNodalLoads(elem,7) + Vb ;
			%
		elseif ismember(nod2, nodesF) && ~ismember(nod2, currMom)
			[	~, nodRep2, lenSum	] = findSecondNode(Conec, nod2, i, Nodes, NodesSd, nnodesSd, aux2, internalNodeElems, elemLengths) ;
			[	~, nodRep1, lenSum2	] = findSecondNode(Conec, nod1, i, Nodes, NodesSd, nnodesSd, aux1, internalNodeElems, elemLengths) ;
			currMom = [currMom ; nod2] ;
			% Lengths
			[a, b, ltot, nodA, nodB] = lengthsFun(lenSum, lenSum2, i, elemLengths(i), elemAngles(i), Nodes, nod2, nodRep1, nodRep2) ;
			[nodA, nodB] = posNodes(Nodes, NodesSd, nodA, nodB) ;
			% Node with nodal force position
			posNode = find( nod2 == nodesF(:) ) ;
			% Nodes with supports
			supA = find(nodalSpringsSd(:,1) == nodA) ; supB = find(nodalSpringsSd(:,1) == nodB) ;
			% Elem and nodes position
			[posNod1, node2] = posNodes(Nodes, NodesSd, nodRep1, nodRep2) ;
			[elem] = posElem(ConecSd, posNod1, node2) ;
			% Reactions
			[Ma, Mb, Va, Vb] = reaccionesEmpotramientoPerfecto(supA, supB, nodalSpringsSd, nodalConstantLoads, a, b, ltot, posNode, elemAnglesSd(elem)) ; 
			% Elem nodal loads matrix: structure -- elem nodA Va Ma nodB Vb Mb
			elemNodalLoads(elem,1) = elem ; elemNodalLoads(elem,2) = nodA ; elemNodalLoads(elem,5) = nodB ;
			elemNodalLoads(elem,4) = elemNodalLoads(elem,4) + Ma ; elemNodalLoads(elem,7) = elemNodalLoads(elem,7) + Mb ;
			elemNodalLoads(elem,3) = elemNodalLoads(elem,3) + Va ; elemNodalLoads(elem,6) = elemNodalLoads(elem,6) + Vb ;
		end
	%	
	end																						
end

null = find(nodalConstantLoadsSD(:,1) == 0) ;
nodalConstantLoadsSD(null,:) = [] ;

nodalConstantLoadsAux(nodesConst,1) = nodesConst ;
aux = find(nodalConstantLoadsAux(:,1) == 0)      ;
nodalConstantLoadsAux(aux,:) = []                ;
