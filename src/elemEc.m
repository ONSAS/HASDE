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

% Element SD equations verification
% ----------------------------------------------------------------------

resVec = zeros(size(data,1),1) ;
eqM1 = 0 ;
eqM2 = 0 ;

elemsEcData = cell2mat(data(:,2:end)) ;
resVec = zeros(size(data,1),1) ;
for i = 1:size(data,1)
	tag = data(i,1) ;

	[elem] = posElem(ConecSd, elemsEcData(i,1), elemsEcData(i,2)) ;

	% Checks if horizontal elem
	if elemAnglesSd(elem) == 1
		horizontalBool = 1 ;
	else
		horizontalBool = 0 ;
	end	
	% Stiffness parameters
	Iy = secGeomProps(ConecSd(elem,6), 2) ; E	 = hyperElasParams{ConecSd(elem,5)}(2) ; l = elemLengthsSd(elem) ;
	% Student
	Kthetai = elemsEcData(i,3) ; Kthetaj = elemsEcData(i,4) ;	Kdelta = elemsEcData(i,5) ;
	carga			= elemsEcData(i,6) ;
	studentEc = [ Kthetai Kthetaj Kdelta carga ] ;
	% Equations
	nodeselem = ConecSd(elem, 1:2) ;
	supNodi = find(nodalSpringsSd(:,1) == elemsEcData(i,1)) ; supNodj = find(nodalSpringsSd(:,1) == elemsEcData(i,2)) ; 
	
	if ~ismember(elem, elemNodalLoads(:,1))  
		Mempi = 0 ; Mempj = 0 ; Vi = 0 ; Vj = 0 ;
	elseif elemsEcData(i,1) == elemNodalLoads(elem,2) ; 
		Mempi = elemNodalLoads(elem,4) ;
		Mempj = elemNodalLoads(elem,7) ;
		Vi		= elemNodalLoads(elem,3) ;
		Vj		= elemNodalLoads(elem,6) ;
	elseif elemsEcData(i,1) == elemNodalLoads(elem,5)
		Mempi = elemNodalLoads(elem,7) ;
		Mempj = elemNodalLoads(elem,4) ;
		Vi		= elemNodalLoads(elem,6) ;
		Vj		= elemNodalLoads(elem,3) ;
	end	
		
	if length(supNodi) > 0 && length(supNodj) > 0
		if nodalSpringsSd(supNodi,1+4) == inf && nodalSpringsSd(supNodj,1+4) == inf
			eqM1 = [ 2*E*Iy/l * [ 0 0 -3/l ] Mempi ] ;
			eqM2 = [ 2*E*Iy/l * [ 0 0 -3/l ] Mempj ] ;
		elseif nodalSpringsSd(supNodi, 5) == inf && nodalSpringsSd(supNodj, 5) == 0
			eqM1 = [ 2*E*Iy/l * [ 0 1 -3/l ] Mempi ] ;
			eqM2 = [ 2*E*Iy/l * [ 0 2 -3/l ] Mempj ] ;
		elseif nodalSpringsSd(supNodi, 5) == 0 && nodalSpringsSd(supNodj, 5) == inf	
			eqM1 = [ 2*E*Iy/l * [ 2 0 -3/l ] Mempi ] ; 
			eqM2 = [ 2*E*Iy/l * [ 1 0 -3/l ] Mempj ] ; 
		end
	elseif length(supNodi) > 0 && length(supNodj) == 0
		if nodalSpringsSd(supNodi, 5) == inf
			eqM1 = [ 2*E*Iy/l * [ 0 1 -3/l ] Mempi ] ; 
			eqM2 = [ 2*E*Iy/l * [ 0 2 -3/l ] Mempj ] ;
		elseif nodalSpringsSd(supNodi, 5) == 0
			eqM1 = [ 2*E*Iy/l * [ 2 1 -3/l ] Mempi ] ; 
			eqM2 = [ 2*E*Iy/l * [ 1 2 -3/l ] Mempj ] ;
		end
	elseif length(supNodi) == 0 && length(supNodj) > 0	 
		if nodalSpringsSd(supNodj, 5) == inf
			eqM1 = [ 2*E*Iy/l * [ 2 0 -3/l ] Mempi ] ; 
			eqM2 = [ 2*E*Iy/l * [ 1 0 -3/l ] Mempj ] ;
		elseif nodalSpringsSd(supNodj, 5) == 0
			eqM1 = [ 2*E*Iy/l * [ 2 1 -3/l ] Mempi ] ; 
			eqM2 = [ 2*E*Iy/l * [ 1 2 -3/l ] Mempj ] ;
		end
	elseif length(supNodi) == 0 && length(supNodj) == 0
		eqM1 = [ 2*E*Iy/l * [ 2 1 -3/l ] Mempi ] ; 
		eqM2 = [ 2*E*Iy/l * [ 1 2 -3/l ] Mempj ] ;
	end		
	
	if horizontalBool == 1
		eqM1(3) = 0 ;
		eqM2(3) = 0 ;
	end
	% Shear equations
	
	if elemsEcData(i,1) == nodeselem(1) ; 
		eqV1 = 	(eqM1 + eqM2) / l + [ 0 0 0 Vi ] ;
		eqV2 = -(eqM1 + eqM2) / l + [ 0 0 0 Vj ] ;
	elseif elemsEcData(i,1) == nodeselem(2)
		eqV1 =  -(eqM1 + eqM2) / l + [ 0 0 0 Vj ] ;
		eqV2 =   (eqM1 + eqM2) / l + [ 0 0 0 Vi ] ;
	end	
	
	if strcmp(tag, 'V')
		eqV = eqV1 ;
		if sum( abs( studentEc - eqV ) > handles.tolCheck * abs( eqV ) ) == 0 
			resVec(i,1) = 1 ;
		end
	elseif strcmp(tag, 'M')
		eqM = eqM1 ;
		if sum( abs( studentEc - eqM ) > handles.tolCheck * abs( eqM ) ) == 0
			resVec(i,1) = 1 ;
		end
	end
end



aux = find(resVec(:,1) == 0) ;
