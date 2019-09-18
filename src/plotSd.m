% ==============================================================================
% --------     HASDE: una Herramienta abierta de Aprendizaje interactivo 
%                                   del Metodo de Slope DEflection      --------
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

% General script that contains the functions to plot the loads and ...
% Supports
% ----------------------------------------------------------------------

if handles.strucGeomPlot ~= 0
	cla(handles.ax)
	handles.axBool = 1 ;
	ax = handles.ax ;
else
	handles.strucGeomPlot = 1 ;
end	
	
set(0, 'currentfigure', 1)
%
coordsElemsMat = zeros(nelemsSd,2*ndofpnode) ;
for i=1:nelemsSd
	nodeselem = ConecSd(i,1:2)' ;
	dofselem  = nodes2dofs( nodeselem , ndofpnode ) ;
	coordsElemsMat( i, (1:2:11) ) = [ NodesSd( nodeselem(1),:)  NodesSd( nodeselem(2),:) ] ;
end
% Plot options
lw  = 2   ; ms  = 5.5 ;
lw2 = 3.2 ; ms2 = 23 ;
plotfontsize = 22 ;
% Axis
strucsize = strucSize(Nodes) ;
xs = Nodes(:,1) ;
zs = Nodes(:,3) ;
marginAxis = 0.4*strucsize ;
minx = min(xs)' - marginAxis ; maxx = max(xs)' + marginAxis ;
minz = min(zs)' - marginAxis ; maxz = max(zs)' + marginAxis ;
%
if handles.axBool == 0 
	ax = axes(handles.plotPanel) ;
end
hold on, grid on
% Elements
for i = 1:nelemsSd
	barras = plot(coordsElemsMat(i,[1 7]), coordsElemsMat(i,[5 11]),'b-','linewidth',lw*0.8,'markersize',ms*0.8) ;
end
%
axis([minx maxx minz maxz]) ;
axis equal
% Nodal Springs
dofs = [1 4 5] ; 
for i = 1:size(nodalSprings,1)
	for l = 1:length(dofs)
		springs2plot(dofs(l), nodalSprings(i,dofs(l)+1), strucsize, Nodes(nodalSprings(i,1),:), ax) ;
	end
end
% Nodes text
for j = 1:nnodesSd
	nodos = plot(NodesSd(j,1), NodesSd(j,3), 'color', 'r', '.', 'markersize', ms2*.85 ) ;
	text(NodesSd(j,1), NodesSd(j,3), sprintf( '%i', j ), 'fontsize', plotfontsize*0.75, 'position', [NodesSd(j,1)+.05*strucsize, NodesSd(j,3)+.05*strucsize]  ) ;
end

% Nodal Loads
variableFext = zeros( ndofpnode*nnodesTot , 1 );
constantFext = zeros( ndofpnode*nnodesTot , 1 );

if exist( 'nodalConstantLoads' ) ~= 0
  for i=1:size(nodalConstantLoadsAux,1)
    aux = nodes2dofs ( nodalConstantLoadsAux(i,1), ndofpnode ) ;
    constantFext( aux ) = constantFext( aux ) + nodalConstantLoadsAux(i,2:7)' ;
  end
end

[~, loadfac] = visualLoadFac(strucsize, variableFext, constantFext, nnodesTot) ;

if exist( 'nodalConstantLoads' ) ~= 0
	str = 'nodalConstantLoads' ;
	for i = 1:size(nodalConstantLoadsAux,1)
		for dof = 2:7
			sig = sign(nodalConstantLoadsAux(i,dof)) ;
			val = abs(nodalConstantLoadsAux(i,dof)) ;
			loads2plot(Nodes, Conec, nodalConstantLoadsAux(i,1), dof, sig, str, loadfac, val, [] ) ;
		end
	end
end

% Uniform Loads
%if exist( 'unifLoad' ) ~= 0
if length(unifLoad) > 0
	maxNorm = max(sqrt(max( (unifLoad(:,3:5).^2 )') ) ) ;
	loadfac = 0.075* strucsize / maxNorm ;
	str = 'unifLoad' ;
	for i = 1:size(unifLoad,1)
		axi = unifLoad(i,2) ;
		for dof = 3:5
			val = abs(unifLoad(i,dof)) ;
			sig = sign(unifLoad(i,dof)) ;
			loads2plot(Nodes, Conec, unifLoad(i,1), dof, sig, str, loadfac, val, axi ) ;
		end
	end
end

% Plot forces tags
plotTag
handles.ax = ax ;

