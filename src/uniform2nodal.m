% Uniform loads to nodal loads
% ----------------------------------------------------------------------

ndofpnode = 6 ;
if exist( 'unifLoad' ) ~= 0
  elemUnif = unifLoad(:,1) ;
end

nodalUniformLoads = zeros(nnodesTot,7) ; 

elemReleases = zeros(nelemsTot,2) ;

for i = 1:nelemsTot
	nod1 = Conec(i,1) ; nod2 = Conec(i,2) ;
	if ismember(nod1, nodalSprings)
		auxNod = find(nod1 == nodalSprings(:,1)) ;
		if nodalSprings(auxNod,4+1) == 0
			elemReleases(i,1) = 1 ;
		end
	end
	if ismember(nod2, nodalSprings)
		auxNod = find(nod2 == nodalSprings(:,1)) ;
		if nodalSprings(auxNod,4+1) == 0
			elemReleases(i,2) = 1 ;
		end
	end
end

if exist('unifLoad') ~= 0
  for i = 1:length(elemUnif)
    % Length and local2globalMat
    [l, locglomat] = beamParameters(Nodes(Conec(elemUnif(i),1:2),:)) ;
    R = RotationMatrix ( ndofpnode, locglomat ) ; exL = locglomat(:,1) ; eyL = locglomat(:,2) ; ezL = locglomat(:,3) ;
    %
    nodeselem = Conec(elemUnif(i),1:2)' ;
    
    % uniform load vals
    qx = unifLoad(i,3) ; qy = unifLoad(i,4) ; qz = unifLoad(i,5) ;
    % Local nodal forces
    qlloc =  l * [ 1/2  0 0   0    0  0 1/2 0 0   0   0  0 ]' ;
    
    if exist( 'elemReleases' ) ~= 0
      if elemReleases(elemUnif(i),1) == 1 && elemReleases(elemUnif(i),2) == 0
        qploc =  l * [ 0 0 		0 			0 	3/8 		0  	0 	0 		0 	 l/8 	5/8 		0 ; ...
                       0 0 	3/8 			0 		0 		0  	0 	0 	5/8 		 0 		0  -l/8 ; ...
                       0 0 		0 			0 	3/8 		0  	0 	0 		0 	 l/8 	5/8 		0 ]' ;					   
      elseif elemReleases(elemUnif(i),1) == 0 && elemReleases(elemUnif(i),2) == 1
        qploc =  l * [ 0 0 		0  	 -l/8 	5/8 		0  	0 	0 		0 		 0 	3/8 		0 ; ...
                       0 0 	5/8 			0 		0 	l/8  	0 	0 	3/8 		 0 		0 		0 ; ...
                       0 0 		0  	 -l/8 	5/8 		0  	0 	0 		0 		 0 	3/8 		0 ]' ;
      else
				qploc =  l * [ 0 0 		0 	-l/12 	1/2 		0 	0 	0 		0 	l/12 	1/2 		0 ; ...
                     0 0 	1/2 			0 		0	 l/12 	0 	0 	1/2 	 	 0 		0 -l/12 ; ...
                     0 0 		0 	-l/12 	1/2 		0 	0 	0 		0 	l/12 	1/2 		0 ]' ;
      end
    else 
      qploc =  l * [ 0 0 		0 	-l/12 	1/2 		0 	0 	0 		0 	l/12 	1/2 		0 ; ...
                     0 0 	1/2 			0 		0	 l/12 	0 	0 	1/2 	 	 0 		0 -l/12 ; ...
                     0 0 		0 	-l/12 	1/2 		0 	0 	0 		0 	l/12 	1/2 		0 ]' ; 
    end
    % local to global
    if unifLoad(i,2) == 1 % GLOBAL AXES
      % X global
      cosZX = ezL' * [1 0 0]'; senXZ = exL'*[0 0 1]' ;
      % Y global
      cosYY = eyL' * [0 1 0]'; senXY = exL'*[0 1 0]' ;
      % Z global
      cosZZ = ezL' * [0 0 1]'; senXZ = exL'*[0 0 1]' ;
      
      ql = qlloc * diag([qx qy qz]' * [senXZ senXY senXZ])' ;
      qp = qploc * diag([qx qy qz]' * [cosZX cosYY cosZZ]) ;
    elseif unifLoad(i,2) == 0 % LOCAL AXES
      ql = qx * qlloc ;
      qp = qploc * [0 qy qz]' ;
    end % endif GLOBAL/LOCAL
    
    gdlnodes  = nodes2dofs(nodeselem,ndofpnode)([1 4 5 1+6 4+6 5+6])  ;
    glo       = R*( sum(ql,2)+sum(qp,2) )                             ;
    aux       = [reshape(glo,6,2)']                                   ;

    nodalUniformLoads(nodeselem,2:7)  = nodalUniformLoads(nodeselem,2:7) + aux  ;
    nodalUniformLoads(nodeselem,1)    = nodeselem                               ;
    
  end
end

clear elemReleases
