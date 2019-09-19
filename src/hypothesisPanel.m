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

% ----------------------------------------------------------------------
% Hypothesis panel
% ----------------------------------------------------------------------

% Panel
% ----------------------------------------------------------------------
handles.hypothesisPanel = uipanel('parent', fig, 'title', 'Convencion de signos', 'titleposition', 'centertop', 'position', vecHypPanel) ;

% Plot 
% ----------------------------------------------------------------------
lw = 2 ; ms = 22 ;
set(0, 'currentfigure', 1)
ax1 = axes(handles.hypothesisPanel) ;
hold on, axis([-2.25,2.25], [-2.25, 2.25]), axis equal
nodes = [ -2 2 ; ...
					 1 1 ] ;

% Bar and nodes
% ----------------------------------------------------------------------				 
h = plot(ax1, nodes(1,:), nodes(2,:), '-k', 'linewidth', lw*.8) ;
nodesPlot = plot( nodes(1,:), nodes(2,:), 'color', 'k', '.', 'markersize', 1.2*ms) ;

% Moment arrow and plots
% ----------------------------------------------------------------------
angM 			= (-pi+pi/6):0.01:(pi/2+pi/6) ;
bottomAXP = [cos(angM(end)) -0.3] ;
bottomAZP = [sin(angM(end)) 0.796] ;

scaleFac = .2 ;
Mizq1 = plot(scaleFac*[cos(angM) -0.43]+nodes(1,1), scaleFac*[sin(angM) 1.05]+nodes(2,1), 'k', 'linewidth', lw*0.8) ;
Mizq2 = plot(scaleFac*bottomAXP+nodes(1,1), scaleFac*bottomAZP+nodes(2,1), 'k', 'linewidth', lw*0.8) ;

Mder1 = plot(scaleFac*[cos(angM) -.43]+nodes(1,2), scaleFac*[sin(angM) 1.05]+nodes(2,2), 'k', 'linewidth', lw*0.8) ;
Mder2 = plot(scaleFac*bottomAXP+nodes(1,2), scaleFac*bottomAZP+nodes(2,2), 'k', 'linewidth', lw*0.8) ;

% Force arrow and plots
% ----------------------------------------------------------------------
scaleF = 2 ;
xForcesArrow 			= -scaleF*[0 0 0.15] ;
xForcesArrowLeft 	= -scaleF*[0 -0.15] ;
zForcesArrow 			= -scaleF*[1 0 0.15] ;
zForcesArrowLeft 	= -scaleF*[0 0.15] ;

vert = 1.5 ;
Vizq1 = plot(scaleFac*xForcesArrow+nodes(1,1), scaleFac*(zForcesArrow+vert*nodes(2,1))+nodes(2,1), 'k', 'linewidth', lw*0.8) ;
Vizq2 = plot(scaleFac*xForcesArrowLeft+nodes(1,1), scaleFac*(zForcesArrowLeft+vert*nodes(2,1))+nodes(2,1), 'k', 'linewidth', lw*0.8) ;

Vder1 = plot(scaleFac*xForcesArrow+nodes(1,2), scaleFac*(zForcesArrow+vert*nodes(2,2))+nodes(2,2), 'k', 'linewidth', lw*0.8) ;
Vder2 = plot(scaleFac*xForcesArrowLeft+nodes(1,2), scaleFac*(zForcesArrowLeft+vert*nodes(2,2))+nodes(2,2), 'k', 'linewidth', lw*0.8) ;

% clear axes
% ----------------------------------------------------------------------
set(ax1, 'xtick', [], 'ytick', [], 'ycolor', [1 1 1], 'xcolor', [1 1 1])
