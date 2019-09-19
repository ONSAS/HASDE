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


% Script that sets fontsize
% ----------------------------------------------------------------------

% Panel title:

set(handles.problemPanel, 'fontsize', fontSizePanel) ;
set(handles.hypothesisPanel, 'fontsize', fontSizePanel) ;
set(handles.plotPanel, 'fontsize', fontSizePanel) ;
set(handles.labelPanel, 'fontsize', fontSizePanel) ;
set(handles.DataPanel, 'fontsize', fontSizePanel) ;
set(handles.VerifPanel, 'fontsize', fontSizePanel) ;
set(handles.ResultPanel, 'fontsize', fontSizePanel) ;

% UIcontrols

set(handles.loadM, 'fontsize', fontSize ) ;
set(handles.about, 'fontsize', fontSize ) ;
set(handles.quit, 'fontsize', fontSize ) ;
% ---
set(handles.incNumberText, 'fontsize', fontSize ) ;
set(handles.incTagText, 'fontsize', fontSize ) ;
set(handles.eqText, 'fontsize', fontSize ) ;
set(handles.matrixKText, 'fontsize', fontSize ) ;
set(handles.dispsValText, 'fontsize', fontSize ) ;
set(handles.solicValText, 'fontsize', fontSize ) ;
% ---
set(handles.incNumberVerif, 'fontsize', fontSize ) ;
set(handles.incTagVerif, 'fontsize', fontSize ) ;
set(handles.eqVerif, 'fontsize', fontSize ) ;
set(handles.matrixKVerif, 'fontsize', fontSize ) ;
set(handles.dispsValVerif, 'fontsize', fontSize ) ;
set(handles.solicValVerif, 'fontsize', fontSize ) ;
