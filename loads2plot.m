% Function that plot the loads applied to the structure
% ----------------------------------------------------------------------

function loads2plot(Nodes, Conec, i, dof, sig, str, loadfac, val, axi )

	hold on
	
	nnodes = size(Nodes,1) ;
	nelems = size(Conec,1) ;
	
	% Plot options
	lw = 2 ;
	
	% ====================================================================
	% 													Nodal loads
	% ====================================================================
	
	% Forces Arrow
	xForcesArrow 			= -loadfac*[0 0 0.15] ;
	xForcesArrowLeft 	= -loadfac*[0 -0.15] ;
	zForcesArrow 			= -loadfac*[1 0 0.15] ;
	zForcesArrowLeft 	= -loadfac*[0 0.15] ;
	ang 							= 0:0.01:2*pi ;
	
	% Rotated arrow
	pointForcesArrow = [0 0] ;
	xForcesArrowR 			= ( (xForcesArrow([1 3])		-pointForcesArrow(1))*cos(-pi/2) - (zForcesArrow([1 3])			-pointForcesArrow(2))*sin(-pi/2) + pointForcesArrow(1) ) ;
	zForcesArrowR 			= ( (xForcesArrow([1 3])		-pointForcesArrow(1))*sin(-pi/2) + (zForcesArrow([1 3])			-pointForcesArrow(2))*cos(-pi/2) + pointForcesArrow(2) ) ; 
	xForcesArrowLeftR 	= ( (xForcesArrowLeft(1:end)-pointForcesArrow(1))*cos(-pi/2) - (zForcesArrowLeft(1:end)	-pointForcesArrow(2))*sin(-pi/2) + pointForcesArrow(1) ) ;
	zForcesArrowLeftR 	= ( (xForcesArrowLeft(1:end)-pointForcesArrow(1))*sin(-pi/2) + (zForcesArrowLeft(1:end)	-pointForcesArrow(2))*cos(-pi/2) + pointForcesArrow(2) ) ;
	
	% Moment Arc Arrow
	angM 			= (-pi+pi/6):0.01:(pi/2+pi/6) ;
	bottomAXP = [cos(angM(end)) -0.3] ;
	bottomAZP = [sin(angM(end)) 0.796] ;
	bottomAXN = [cos(angM(1)) -0.92] ;
	bottomAZN = [sin(angM(1)) -0.71] ;
	
	% ====================================================================
	% 												Distributed loads
	% ====================================================================
  if strcmp(str, 'unifLoad')
    elemnodes = Conec(i,1:2) ;
    [len, Local2GlobalMats] = beamParameters(Nodes(elemnodes,:)) ;
    exL = Local2GlobalMats(:,1);  ezL = Local2GlobalMats(:,3) ;
    
    % qZ
    % zL = zG
    xUnifArrow_z 			= loadfac*[0 0 0.15] ;
    xUnifArrowLeft_z 	= loadfac*[0 -0.15] ;
    
    relativePos 							= 0.2 ;
    coordXIntArrow_z 					= linspace(0,len,1/relativePos) ;
    coordXIntArrow_z([1,end]) = [] ;
    cantArrow 								= size(coordXIntArrow_z,2) ;
    
    zUnifArrow_z 			= loadfac*[0.2 1.2 1.05] ;
    zUnifArrowLeft_z 	= loadfac*[1.2 1.05] ;
    % Positive
    linX_P_z = [ 0 1*len ] ;
    linZ_P_z = loadfac*[ 0.2 0.2 ] ; 
    
    % Negative
    linX_N_z = [0 1*len] ;
    linZ_N_z = loadfac*[1.2 1.2] ;
    
    % xL = zG
    rel2 = loadfac * 0.2 ;
    coordZIntArrow_Z = linspace(0,len,1/rel2) ;
    xVec = -0.2*ones(1,size(coordZIntArrow_Z,2)) ;
    
    % qX
    % xL = xG
    rel = loadfac * 0.2 ;
    coordXIntArrow_X = linspace(0,len,1/rel) ;
    zVec = 0.2*ones(1,size(coordXIntArrow_X,2)) ; 
    
    % zL = xG
    xUnifArrow_x 			= loadfac*[-0.35 -0.2 -1.2] ;
    xUnifArrowLeft_x 	= loadfac*[-0.35 -0.2] ;
    
    rel3 											= 0.2 ;
    coordXIntArrow_x 					= linspace(0,len,1/rel3) ;
    coordXIntArrow_x([1,end]) = [] ;
    cantArrow 								= size(coordXIntArrow_x,2) ;
    
    zUnifArrow_x 			= loadfac*[0.15 0 0] ;
    zUnifArrowLeft_x 	= loadfac*[-0.15 0] ;
    % Positive
    linX_P_x = loadfac*[ -1.2 -1.2 ] ;
    linZ_P_x = [ 0 1*len ] ; 
    
    % Negative
    linX_N_x = loadfac*[-0.2 -0.2] ;
    linZ_N_x = [0 1*len] ;	
	end
	
	% ---------
	if strcmp(str, 'nodalConstantLoads')
		% Dofs
		forcesDofs = [ 2 6 ] ;
		momentDofs = [ 5 ] ;
		if ismember(dof,forcesDofs)
			if val > 0
				if dof == 6
					plot(sig*val*xForcesArrow+Nodes(i,1), sig*val*zForcesArrow+Nodes(i,3), 'k', 'linewidth', lw*0.8) ;
					plot(sig*val*xForcesArrowLeft+Nodes(i,1), sig*val*zForcesArrowLeft+Nodes(i,3), 'k', 'linewidth', lw*0.8) ;
				elseif dof == 2 
					plot(sig*val*[xForcesArrowR(1) 0 xForcesArrowR(2)]+Nodes(i,1), sig*val*[zForcesArrowR(1) 0 zForcesArrowR(2)]+Nodes(i,3), 'k', 'linewidth', lw*0.8) ;
					plot(sig*val*xForcesArrowLeftR+Nodes(i,1), sig*val*zForcesArrowLeftR+Nodes(i,3), 'k', 'linewidth', lw*.8) ;
				end
			end
		elseif ismember(dof, momentDofs)
			if sig < 0
				plot(val*loadfac*[cos(angM) -0.43]+Nodes(i,1),val*loadfac*[sin(angM) 1.05]+Nodes(i,3), 'k', 'linewidth', lw*0.8) ;
				plot(val*loadfac*bottomAXP+Nodes(i,1), val*loadfac*bottomAZP+Nodes(i,3), 'k', 'linewidth', lw*0.8) ;
			else
				plot(val*loadfac*[-0.66 cos(angM)]+Nodes(i,1),val*loadfac*[-0.55 sin(angM)]+Nodes(i,3), 'k', 'linewidth', lw*0.8) ;
				plot(val*loadfac*bottomAXN+Nodes(i,1), val*loadfac*bottomAZN+Nodes(i,3), 'k', 'linewidth', lw*0.8) ;
			end
		end	
	elseif strcmp(str, 'unifLoad')
		
		
		if axi == 1 % GLOBAL
			if val > 0
				if dof == 5 % Z axis
					if isequal(ezL,[0 0 1]')
						if sig > 0
							plot(linX_P_z+Nodes(elemnodes(1),1), linZ_P_z+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
							plot(sig*xUnifArrow_z+Nodes(elemnodes(1),1), sig*zUnifArrow_z+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
							plot(sig*xUnifArrowLeft_z+Nodes(elemnodes(1),1), sig*zUnifArrowLeft_z+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
							plot(sig*xUnifArrow_z+len*[1 1 1]+Nodes(elemnodes(1),1), sig*zUnifArrow_z+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
							plot(sig*xUnifArrowLeft_z+len*[1 1]+Nodes(elemnodes(1),1), sig*zUnifArrowLeft_z+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
						elseif sig < 0
							plot(linX_N_z+Nodes(elemnodes(1),1), linZ_N_z+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
							plot(sig*xUnifArrow_z+Nodes(elemnodes(1),1), sig*zUnifArrow_z+loadfac*[1.4 1.4 1.4]+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
							plot(sig*xUnifArrowLeft_z+Nodes(elemnodes(1),1), sig*zUnifArrowLeft_z+loadfac*[1.4 1.4]+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
							plot(sig*xUnifArrow_z+len*[1 1 1]+Nodes(elemnodes(1),1), sig*zUnifArrow_z+loadfac*[1.4 1.4 1.4]+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
							plot(sig*xUnifArrowLeft_z+len*[1 1]+Nodes(elemnodes(1),1), sig*zUnifArrowLeft_z+loadfac*[1.4 1.4]+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
						end
						for ar = 1:cantArrow
							coordXaux = xUnifArrow_z ;
							coordXLaux = xUnifArrowLeft_z ;
							coordXaux = xUnifArrow_z + coordXIntArrow_z(ar) ;
							coordXLaux = xUnifArrowLeft_z + coordXIntArrow_z(ar) ;
							if sig > 0
								plot(sig*coordXaux+Nodes(elemnodes(1),1), sig*zUnifArrow_z+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
								plot(sig*coordXLaux+Nodes(elemnodes(1),1), sig*zUnifArrowLeft_z+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
							elseif sig < 0
								plot(coordXaux+Nodes(elemnodes(1),1), sig*zUnifArrow_z+loadfac*[1.4 1.4 1.4]+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
								plot(coordXLaux+Nodes(elemnodes(1),1), sig*zUnifArrowLeft_z+loadfac*[1.4 1.4]+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
							end	
						end
					elseif isequal(exL,[0 0 1]')

						for ar = 1:2:size(coordZIntArrow_Z,2)-1
							plot(xVec(ar:ar+1)+Nodes(elemnodes(1),1), coordZIntArrow_Z(ar:ar+1)+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
							if sig > 0
								plot([-0.2 -0.2+0.15*loadfac]+Nodes(elemnodes(1),1), [coordZIntArrow_Z(ar+1) coordZIntArrow_Z(ar+1)-0.15*loadfac]+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8 ) ; 
								plot([-0.2 -0.2-0.15*loadfac]+Nodes(elemnodes(1),1), [coordZIntArrow_Z(ar+1) coordZIntArrow_Z(ar+1)-0.15*loadfac]+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8 ) ; 
							elseif sig < 0
								plot([-0.2 -0.2+0.15*loadfac]+Nodes(elemnodes(1),1), [coordZIntArrow_Z(ar) coordZIntArrow_Z(ar)-sig*0.15*loadfac]+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8 ) ; 
								plot([-0.2 -0.2-0.15*loadfac]+Nodes(elemnodes(1),1), [coordZIntArrow_Z(ar) coordZIntArrow_Z(ar)-sig*0.15*loadfac]+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8 ) ; 
							end
						end
					end	
				elseif dof == 3 % X axis
					if isequal(exL,[1 0 0]')
						for ar = 1:2:size(coordXIntArrow_X,2)-1
							plot(coordXIntArrow_X(ar:ar+1)+Nodes(elemnodes(1),1), zVec(ar:ar+1)+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
							if sig > 0
								plot([coordXIntArrow_X(ar+1) coordXIntArrow_X(ar+1)-0.15*loadfac]+Nodes(elemnodes(1),1), [0.2 0.2+0.15*loadfac]+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8 ) ; 
								plot([coordXIntArrow_X(ar+1) coordXIntArrow_X(ar+1)-0.15*loadfac]+Nodes(elemnodes(1),1), [0.2 0.2-0.15*loadfac]+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8 ) ; 
							elseif sig < 0
								plot([coordXIntArrow_X(ar) coordXIntArrow_X(ar)-sig*0.15*loadfac]+Nodes(elemnodes(1),1), [0.2 0.2+0.15*loadfac]+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8 ) ; 
								plot([coordXIntArrow_X(ar) coordXIntArrow_X(ar)-sig*0.15*loadfac]+Nodes(elemnodes(1),1), [0.2 0.2-0.15*loadfac]+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8 ) ; 
							end
						end
					elseif isequal(exL,[0 0 1]')
						if sig > 0
							plot(linX_P_x+Nodes(elemnodes(1),1), linZ_P_x+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
							plot(sig*xUnifArrow_x+Nodes(elemnodes(1),1), sig*zUnifArrow_x+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
							plot(sig*xUnifArrowLeft_x+Nodes(elemnodes(1),1), sig*zUnifArrowLeft_x+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
							plot(sig*xUnifArrow_x+Nodes(elemnodes(1),1), sig*zUnifArrow_x+len*[1 1 1]+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
							plot(sig*xUnifArrowLeft_x+Nodes(elemnodes(1),1), sig*zUnifArrowLeft_x+len*[1 1]+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
						elseif sig < 0
							plot(linX_N_x+Nodes(elemnodes(1),1), linZ_N_x+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
							plot(sig*xUnifArrow_x-loadfac*[1.4 1.4 1.4]+Nodes(elemnodes(1),1), sig*zUnifArrow_x+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
							plot(sig*xUnifArrowLeft_x-loadfac*[1.4 1.4]+Nodes(elemnodes(1),1), sig*zUnifArrowLeft_x+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
							plot(sig*xUnifArrow_x-loadfac*[1.4 1.4 1.4]+Nodes(elemnodes(1),1), sig*zUnifArrow_x+len*[1 1 1]+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
							plot(sig*xUnifArrowLeft_x-loadfac*[1.4 1.4]+Nodes(elemnodes(1),1), sig*zUnifArrowLeft_x+len*[1 1]+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
						end
						for ar = 1:cantArrow
							coordXaux = zUnifArrow_x ;
							coordXLaux = zUnifArrowLeft_x ;
							coordXaux = zUnifArrow_x + coordXIntArrow_x(ar) ;
							coordXLaux = zUnifArrowLeft_x + coordXIntArrow_x(ar) ;
							if sig > 0
								plot(sig*xUnifArrow_x+Nodes(elemnodes(1),1), sig*coordXaux+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
								plot(sig*xUnifArrowLeft_x+Nodes(elemnodes(1),1), sig*coordXLaux+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
							elseif sig < 0
								plot(sig*xUnifArrow_x-loadfac*[1.4 1.4 1.4]+Nodes(elemnodes(1),1), coordXaux+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
								plot(sig*xUnifArrowLeft_x-loadfac*[1.4 1.4]+Nodes(elemnodes(1),1), coordXLaux+Nodes(elemnodes(1),3), 'k', 'linewidth', lw*0.8) ;
							end	
						end
					end
				end % endif dof
			end % endif val >0
			
			
		elseif axi == 0 % LOCAL
	
	end	%endif strcmp

	

end % endfunction

	% Moment 2 arrows plot
	%~ coordXMA = loadfac*[0 0 0.15] ;
	%~ XMALeft1 = loadfac*[0 -0.15] ;
	%~ coordZMA = loadfac*[1 0 0.15] ;
	%~ ZMALeft1 = loadfac*[0 0.15] ;
	%~ ZMALeft2 = loadfac*[0.15 0.3] ;
	%~ plot(sig*coordXMA+Nodes(i,1), sig*coordZMA+Nodes(i,3)) ;
	%~ plot(sig*XMALeft1+Nodes(i,1), sig*ZMALeft1+Nodes(i,3)) ;
	%~ plot(sig*coordXMA(2:end)+Nodes(i,1), sig*ZMALeft2+Nodes(i,3)) ;
	%~ plot(sig*XMALeft1+Nodes(i,1), sig*ZMALeft2+Nodes(i,3)) ;		
