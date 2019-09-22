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


function HASDE

	close all, clear all, clc
  
  addpath( [ pwd '/src' ] ) ;

	GUIgeom
  
	
  fig 	= figure('menubar', 'none', 'numbertitle', 'off', 'resize', 'off', 'position', vecFig, 'name', ['HASDE: Herramienta Abierta de Aprendizaje interactiva del metodo de Slope Deflection']) ;
  fig2 	= figure('menubar', 'none', 'numbertitle', 'off', 'resize', 'off', 'visible' , 'off' , 'name', 'Entrada de datos', 'position', [posxFigUiTable posyFigUiTable anchoFigUiTable altoFigUiTable]) ;
  fig3 	= figure('menubar', 'none', 'numbertitle', 'off', 'resize', 'off', 'visible' , 'off' , 'name', '', 'position', [posxFigUiTable posyFigUiTable anchoFigUiTable altoFigUiTable]) 	 ;
  
  posFig2 = get(fig2,'position') ;
  
  handles 	= guidata(fig) ;
	handles2 	= guidata(fig2);
	handles3 	= guidata(fig3);
  
  % handles
  
  % structural
  handles.pVUnknown = '0' ;
  
  % Tables names
  handles.colUnkNames 		= { 'Nodo', 'ux', 'theta_y', 'uz' } ;
  handles.elemEcNames 		= { 'V/M', 'Sub. i', 'Sub. j', 'Giro sub. i', 'Giro sub. j', 'Delta', 'Carga_tramo' } ;
  handles.forcesColNames 	= { 'V/M' } ;
  handles.forcesNames			=	{ 'Nodo izq', 'Nodo der', 'Mizq', 'Mder', 'Vizq', 'Vder'} ;
  
  handles3.elemsName				= { 'Elem.'	, 'Nodo 1', 'Nodo 2', 'E', 'Iy' } 		;
  handles3.nodesName				= { 'Nodo'	, 'x', 'z'} ;
  handles3.nodalName				= { 'Etiqueta', 'Valor', 'x', 'z' } ;
  handles3.unifoName				= { 'Etiqueta', 'Valor', 'Glo/Loc', 'x1', 'z1', 'x2', 'z2' } ;
	
  
  % Tables data
  data1 = [ 0 0 0 0 ] ;
  handles2.data1 = data1 ;
  dataSolic = [ 0 0 0 0 0 0 ] ;
  handles2.dataSolic = dataSolic ;
  dataEc = [ {'-'} 0 0 0 0 0 0 ] ;
  handles2.dataEc = dataEc ;
  
  % internal
  handles.fname 					= '' 		;
  handles.struc 					= '0' 	;
  handles.kGlobCounter 		= 0 		;
  handles.strucGeomPlot 	= 0 		;
  handles.axBool		 			= 0 		;
  handles.kGlobBool 			= 0 		;
  handles.tolCheck				= 1e-2 	;
  handles.forcesVectorCounter = 0 ;
  
	
% ==== > Load panel
	handles.loadPanel = uipanel		('parent', fig, 'position', vecSysActions) ;

	handles.loadM 		= uicontrol ('parent', handles.loadPanel, 'string', 'Cargar .m'	, ...
																 'position', [frfl ppfbSys buttonLW buttonLH ]	 , 'callback', {@actionButton, fig, fig3} ) 	;
	handles.about 		= uicontrol ('parent', handles.loadPanel, 'string', 'Licencia'	, ...
																 'position', [frfl+incremLH ppfbSys buttonLW buttonLH ], 'callback', {@actionButton, fig, fig3} ) 	;
	handles.quit 			= uicontrol ('parent', handles.loadPanel, 'string', 'Salir'			, ...
																 'position', [frfl+2*incremLH ppfbSys buttonLW buttonLH ], 'callback', 'close (gcf)' ) 				;
  
% ==== > Problem data panel
	handles.problemPanel = uipanel('parent', fig, 'title', 'Datos del problema', 'titleposition', 'centertop', 'position', vecProblemPanel) ;
	set(handles.problemPanel, 'units', 'pixels')
	vecGeomData = get(handles.problemPanel, 'position');
	panelW  		= vecGeomData(3) ;
	frfb 				= vecGeomData(4) ;
	
	handles.elementos 	 	= uicontrol('parent', handles.problemPanel, 'string', 'Elementos' 			, 'visible', 'off', ...
																		'position', [frfl frfb-ref-2*ppfb buttonLW buttonLH], ...
																		'callback', {@dataTablesProblemData, fig, fig3} ) ;
	handles.nodos 			 	= uicontrol('parent', handles.problemPanel, 'string', 'Nodos'						, 'visible', 'off', ...
																		'position', [frfl+incremLH frfb-ref-2*ppfb buttonLW buttonLH], ...
																		'callback', {@dataTablesProblemData, fig, fig3} ) ;
	handles.nodalLoads 		= uicontrol('parent', handles.problemPanel, 'string', 'Cargas nodales'	, 'visible', 'off', ...
																		'position', [frfl frfb-ref-buttonLH-3*ppfb buttonLW buttonLH], ...
																		'callback', {@dataTablesProblemData, fig, fig3} ) ;
	handles.unifoLoads 		= uicontrol('parent', handles.problemPanel, 'string', 'Cargas unif.'		, 'visible', 'off', ...
																		'position', [frfl+incremLH frfb-ref-buttonLH-3*ppfb buttonLW buttonLH], ...
																		'callback', {@dataTablesProblemData, fig, fig3} ) ;
	
% ==== > SD hypothesis panel
	hypothesisPanel

% ==== > Plot panel
	handles.plotPanel = uipanel ('parent', fig, "title", "Geometria", 'titleposition', 'centertop', "position", vecPlotPanel) ; 
	
% ==== > Label panel
	handles.labelPanel = uipanel ('parent', fig, "title", "Pasos", 'titleposition', 'centertop', "position", vecLabelPanel) ; 
	
	set(handles.labelPanel, 'units', 'pixels')
	vecGeomData = get(handles.labelPanel, 'position');
	panelW  		= vecGeomData(3) ;
	frfb 				= vecGeomData(4) ;

	handles.incNumberText = uicontrol('parent', handles.labelPanel, 'style', 'text', 'string', '# inc.:'			, ...
																		'position', [frfl frfb-ref-buttonH panelW-2*frfl-2 buttonH]) 					;
	handles.incTagText 		= uicontrol('parent', handles.labelPanel, 'style', 'text', 'string', 'Incognitas:'	, ...
																		'position', [frfl frfb-ref-2*buttonH-ppfb panelW-2*frfl-2 buttonH]) 	;
	handles.eqText 				= uicontrol('parent', handles.labelPanel, 'style', 'text', 'string', 'Elem ec.:'		, ...
																		'position', [frfl frfb-ref-3*buttonH-2*ppfb panelW-2*frfl-2 buttonH]) ;
	handles.matrixKText 	= uicontrol('parent', handles.labelPanel, 'style', 'text', 'string', 'K glob.:'			, ...
																		'position', [frfl frfb-ref-4*buttonH-3*ppfb panelW-2*frfl-2 buttonH]) ;
	handles.forcesText		= uicontrol('parent', handles.labelPanel, 'style', 'text', 'string', 'F vector:'		, ...
																		'position', [frfl frfb-ref-5*buttonH-4*ppfb panelW-2*frfl-2 buttonH]) ;
	handles.dispsValText 	= uicontrol('parent', handles.labelPanel, 'style', 'text', 'string', 'Desps. vals.:', ...
																		'position', [frfl frfb-ref-6*buttonH-5*ppfb panelW-2*frfl-2 buttonH]) ;
	handles.solicValText 	= uicontrol('parent', handles.labelPanel, 'style', 'text', 'string', 'Solic. vals.:', ...
																		'position', [frfl frfb-ref-7*buttonH-6*ppfb panelW-2*frfl-2 buttonH], ...
																		'visible', 'off') ;
	
% ==== > Data panel
	handles.DataPanel = uipanel ('parent', fig, "title", "Insertar", 'titleposition', 'centertop', "position", vecDataPanel) ;
	
	set(handles.DataPanel, 'units', 'pixels')
	vecGeomData = get(handles.DataPanel, 'position');
	panelW  		= vecGeomData(3) ;
	
	% Data Handles
	
  anchoTabUiTable = posFig2(3)*.8 ;
  altoTabUiTable = posFig2(4)*.8 ;
  posxTabUiTable = .1*posFig2(3) ;
  posyTabUiTable = .1*posFig2(4) ;
  
  posVecTabUiTable = [ posxTabUiTable posyTabUiTable anchoTabUiTable altoTabUiTable ] ;
  
	handles2.incTable 				= uitable('parent', fig2, 'visible', 'off', 'columnname', handles.colUnkNames, 							...
																	'columneditable', [true true true true], 					 'data', handles2.data1, 						...
																	'position', posVecTabUiTable ) ;
	handles2.elemEcTable 			= uitable('parent', fig2, 'visible', 'off', 'columnname', handles.elemEcNames, 							...
																	'columneditable', [true true true true true true true true], 'data', handles2.dataEc, ...
																	'position', posVecTabUiTable ) ;
	handles2.kGlobTable 			= uitable('parent', fig2, 'visible', 'off',																		 							...
																	'columneditable', [true true true true true true], 												 						...
																	'position', posVecTabUiTable ) ;
	handles2.forcesTable			= uitable('parent', fig2, 'visible', 'off',	'columnname', handles.forcesColNames,						...
																	'columneditable', [true true true true true true], 												 						...
																	'position', posVecTabUiTable ) ;																
	handles2.dispsValsTable 	= uitable('parent', fig2, 'visible', 'off', 'columnname', handles.colUnkNames, 							...
																	'columneditable', [true true true true], 					 'data', handles2.data1, 						...
																	'position', posVecTabUiTable ) ;
	handles2.solicValsTable 	= uitable('parent', fig2, 'visible', 'off', 'columnname', handles.forcesNames, 							...
																	'columneditable', [true true true true], 					 'data', handles2.dataSolic, 				...
																	'position', posVecTabUiTable ) ;
																	
	% Problem Data Handles
	
	handles3.elemsTable				= uitable('parent', fig3, 'visible', 'off', 'columnname', handles3.elemsName, ...
																	'columneditable', [false false], ...
																	'position', posVecTabUiTable) ;																																																
	handles3.nodesTable				= uitable('parent', fig3, 'visible', 'off', 'columnname', handles3.nodesName, ...
																	'columneditable', [false false false], ...
																	'position', posVecTabUiTable) ;
	handles3.nodalTable				= uitable('parent', fig3, 'visible', 'off', 'columnname', handles3.nodalName, ...
																	'columneditable', [false false false false], ...
																	'position', posVecTabUiTable) ;	
	handles3.uniformTable			= uitable('parent', fig3, 'visible', 'off', 'columnname', handles3.unifoName, ...
																	'columneditable', [false false false false false false false], ...
																	'position', posVecTabUiTable) ;
  
	% Rows button
	handles2.addRow 		= uicontrol('parent', fig2, 'String', 'Agregar fila'	, 'visible', 'off', 'position', [anchoBotUiTable*.4 altoBotUiTable*.5 anchoBotUiTable altoBotUiTable], ...
														'callback', {@Rows, fig2}) ; 
	handles2.deleteRow 	= uicontrol('parent', fig2, 'String', 'Borrar fila'		, 'visible', 'off', 'position', [anchoBotUiTable*1.8 altoBotUiTable*.5 anchoBotUiTable altoBotUiTable], ...
														'callback', {@Rows, fig2}) ; 
	% Close data buttons
	handles2.closeFig		= uicontrol('parent', fig2, 'String', 'Cerrar'				, 'visible', 'off', 'position', [anchoBotUiTable*3.2 altoBotUiTable*.5 anchoBotUiTable altoBotUiTable], ...
														'callback'	, {@closeTable, fig2, fig3}) ; 

	handles3.closeFig		= uicontrol('parent', fig3, 'String', 'Cerrar'				, 'visible', 'off', 'position', [anchoBotUiTable*1.4 altoBotUiTable*.5 anchoBotUiTable altoBotUiTable], ...
														'callback'	, {@closeTable, fig2, fig3}) ; 
	
	
	% Buttons
	handles.incNumber = uicontrol('parent', handles.DataPanel, 'style'	, 'edit', 'string', '# inc.', 'tag', 'unk', ...
																'position', [frfl frfb-ref-buttonH panelW-2*frfl-2 buttonH], 					'callback', {@editBoxes, fig}) ;
	handles.incTag 		= uicontrol('parent', handles.DataPanel, 										'string'	, 'Incognitas', ...
																'position', [frfl frfb-ref-2*buttonH-ppfb panelW-2*frfl-2 buttonH], 	'callback', {@dataTables, fig, fig2}) ;
	handles.eq 				= uicontrol('parent', handles.DataPanel, 										'string'	, 'Elem ec.', ...
																'position', [frfl frfb-ref-3*buttonH-2*ppfb panelW-2*frfl-2 buttonH], 'callback', {@dataTables, fig, fig2}) ;
	handles.matrixK 	= uicontrol('parent', handles.DataPanel, 										'string'	, 'K glob.', ...
																'position', [frfl frfb-ref-4*buttonH-3*ppfb panelW-2*frfl-2 buttonH], 'callback', {@dataTables, fig, fig2}) ;
	handles.forces		= uicontrol('parent', handles.DataPanel, 										'string'	, 'F vector', ...
																'position', [frfl frfb-ref-5*buttonH-4*ppfb panelW-2*frfl-2 buttonH], 'callback', {@dataTables, fig, fig2}) ;															
	handles.dispsVal 	= uicontrol('parent', handles.DataPanel, 										'string'	, 'Desps. vals.', ...
																'position', [frfl frfb-ref-6*buttonH-5*ppfb panelW-2*frfl-2 buttonH], 'callback', {@dataTables, fig, fig2}) ;
	handles.solicVal 	= uicontrol('parent', handles.DataPanel, 										'string'	, 'Solic. vals.', ...
																'position', [frfl frfb-ref-7*buttonH-6*ppfb panelW-2*frfl-2 buttonH], 'callback', {@dataTables, fig, fig2}, ...
																'visible', 'off') ; 
% ==== > Verif button panel
	handles.VerifPanel = uipanel ('parent', fig, "title", "Verificar", 'titleposition', 'centertop', "position", vecVerifPanel) ;
	
	set(handles.VerifPanel, 'units', 'pixels')
	vecGeomData = get(handles.VerifPanel, 'position');
	panelW  = vecGeomData(3) ;
	set(handles.VerifPanel, 'units', 'normalized')
	
	handles.incNumberVerif 	= uicontrol('parent', handles.VerifPanel, 'string', 'Verif.', 'tag', '1', ...
																			'position', [frfl frfb-ref-buttonH panelW-2*frfl-2 buttonH], 					'callback', {@verif, fig, fig2}) ;
	handles.incTagVerif 		= uicontrol('parent', handles.VerifPanel, 'string', 'Verif.', 'tag', '2', ...
																			'position', [frfl frfb-ref-2*buttonH-ppfb panelW-2*frfl-2 buttonH], 	'callback', {@verif, fig, fig2}) ;
	handles.eqVerif 				= uicontrol('parent', handles.VerifPanel, 'string', 'Verif.', 'tag', '3', ...
																			'position', [frfl frfb-ref-3*buttonH-2*ppfb panelW-2*frfl-2 buttonH], 'callback', {@verif, fig, fig2}) ;
	handles.matrixKVerif 		= uicontrol('parent', handles.VerifPanel, 'string', 'Verif.', 'tag', '4', ...
																			'position', [frfl frfb-ref-4*buttonH-3*ppfb panelW-2*frfl-2 buttonH], 'callback', {@verif, fig, fig2}) ;
	handles.forcesVerif 		= uicontrol('parent', handles.VerifPanel, 'string', 'Verif.', 'tag', '5', ...
																			'position', [frfl frfb-ref-5*buttonH-4*ppfb panelW-2*frfl-2 buttonH], 'callback', {@verif, fig, fig2}) ;																		
	handles.dispsValVerif 	= uicontrol('parent', handles.VerifPanel, 'string', 'Verif.', 'tag', '6', ...
																			'position', [frfl frfb-ref-6*buttonH-5*ppfb panelW-2*frfl-2 buttonH], 'callback', {@verif, fig, fig2}) ;
	handles.solicValVerif 	= uicontrol('parent', handles.VerifPanel, 'string', 'Verif.', 'tag', '7', ...
																			'position', [frfl frfb-ref-7*buttonH-6*ppfb panelW-2*frfl-2 buttonH], 'callback', {@verif, fig, fig2}, ...
																			'visible', 'off') ; 

% ==== > Result panel
	handles.ResultPanel = uipanel ('parent', fig, "title", "Resultado", 'titleposition', 'centertop', "position", vecResultPanel) ; 
	
	handles.resultIncNumber = uicontrol('parent', handles.ResultPanel, 'style', 'text', 'string', '-', 'tag', '1', ...
																			'position', [frfl frfb-ref-buttonH panelW-2*frfl-2 buttonH]) ;
	handles.resultIncTag 		= uicontrol('parent', handles.ResultPanel, 'style', 'text', 'string', '-', 'tag', '2', ...
																			'position', [frfl frfb-ref-2*buttonH-ppfb panelW-2*frfl-2 buttonH]) ;																		
	handles.resultEqVerif 	= uicontrol('parent', handles.ResultPanel, 'style', 'text', 'string', '-', 'tag', '3', ...
																			'position', [frfl frfb-ref-3*buttonH-2*ppfb panelW-2*frfl-2 buttonH]) ;
	handles.resultMatriK 		= uicontrol('parent', handles.ResultPanel, 'style', 'text', 'string', '-', 'tag', '4', ...
																			'position', [frfl frfb-ref-4*buttonH-3*ppfb panelW-2*frfl-2 buttonH]) ;
	handles.resultForces 		= uicontrol('parent', handles.ResultPanel, 'style', 'text', 'string', '-', 'tag', '5', ...
																			'position', [frfl frfb-ref-5*buttonH-4*ppfb panelW-2*frfl-2 buttonH]) ;
	handles.resultDispsVals = uicontrol('parent', handles.ResultPanel, 'style', 'text', 'string', '-', 'tag', '6', ...
																			'position', [frfl frfb-ref-6*buttonH-5*ppfb panelW-2*frfl-2 buttonH]) ;
	handles.resultSolicVals = uicontrol('parent', handles.ResultPanel, 'style', 'text', 'string', '-', 'tag', '7', ...
																			'position', [frfl frfb-ref-7*buttonH-6*ppfb panelW-2*frfl-2 buttonH], 		 ...
																			'visible', 'off') ;
	
	setFont
  guidata(fig	, handles	) ;
	guidata(fig2, handles2) ;
	guidata(fig3, handles3) ;
	
end


% ==============================================================================
% -------------------------------    Callbacks    ------------------------------

% Edit boxes
function editBoxes(src, eventdata, fig)

	handles = guidata(fig) ;
	a = get(src, 'tag') ;
  inp = get(src, 'string') ;
  
  if strcmp(a, 'unk')
    handles.pVUnknown = num2str(inp) ;
	end
	guidata(fig, handles) ;

end


function Rows(src, eventdata, fig2)

	handles2 = guidata(fig2) ;
	
	string = get(src, 'string') ;
	
	visIncTable 		= get(handles2.incTable					, 'visible') ;
	visElemEc 			= get(handles2.elemEcTable			, 'visible') ;
	visKglob				=	get(handles2.kGlobTable				, 'visible') ;
	visDispsVals		=	get(handles2.dispsValsTable		, 'visible') ;
	visSolicVals		=	get(handles2.solicValsTable		, 'visible') ;
	
	if strcmp(string, 'Agregar fila')
		
		if strcmp(visIncTable, 'on')
			auxData = get(handles2.incTable, 'data') ;
			newData = [ auxData ; 0 0 0 0 ] ;
			set(handles2.incTable, 'data', newData)
		elseif strcmp(visElemEc, 'on')
			auxData = get(handles2.elemEcTable, 'data') ;
			newData = [ auxData ; {'-'} 0 0 0 0 0 0 ] ;
			set(handles2.elemEcTable, 'data', newData)
		elseif strcmp(visKglob, 'on')
			auxData = get(handles2.kGlobTable, 'data') ;
			newData = [ auxData ; zeros(1,size(auxData,2)) ] ;
			set(handles2.kGlobTable, 'data', newData)
		elseif strcmp(visDispsVals, 'on')	
			auxData = get(handles2.dispsValsTable, 'data') ;
			newData = [ auxData ; 0 0 0 0 ] ;
			set(handles2.dispsValsTable, 'data', newData)
		elseif strcmp(visSolicVals, 'on')
			auxData = get(handles2.solicValsTable, 'data') ;
			newData = [ auxData ; 0 0 0 ] ;
			set(handles2.solicValsTable, 'data', newData)
		end
			
	elseif strcmp(string, 'Borrar fila')
		
		if strcmp(visIncTable, 'on')
			auxData = get(handles2.incTable, 'data') ;
			auxData(end,:) = [] ;
			newData = auxData ;
			set(handles2.incTable, 'data', newData)
		elseif strcmp(visElemEc, 'on')
			auxData = get(handles2.elemEcTable, 'data') ;
			auxData(end,:) = [] ;
			newData = auxData ;
			set(handles2.elemEcTable, 'data', newData)
		elseif strcmp(visKglob, 'on')
			auxData = get(handles2.kGlobTable, 'data') ;
			auxData(end,:) = [] ;
			newData = auxData ;
			set(handles2.kGlobTable, 'data', newData)	
		elseif strcmp(visDispsVals, 'on')	
			auxData = get(handles2.dispsValsTable, 'data') ;
			auxData(end,:) = [] ;
			newData = auxData ;
			set(handles2.dispsValsTable, 'data', newData)
		elseif strcmp(visSolicVals, 'on')
			auxData = get(handles2.solicValsTable, 'data') ;
			auxData(end,:) = [] ;
			newData = auxData ;
			set(handles2.solicValsTable, 'data', newData)	
		end
		
	end 
	
	guidata(fig2, handles2) ;
 
end

% Data problem
function dataTablesProblemData(src, eventdata, fig, fig3)

	handles = guidata(fig) ;
	handles3 = guidata(fig3) ;
	set(fig3, 'visible', 'on')
	set(handles3.closeFig, 'visible', 'on')
	
	a = get(src, 'string') ;
	
	if strcmp(a, 'Elementos')
		set(fig3, 'name', 'Propiedades geometricas y constitutivas de los elementos')
		set(handles3.elemsTable, 'visible', 'on')
		set(handles3.elemsTable, 'data', handles3.elemMat)
		% visible off
		set(handles3.nodesTable, 'visible', 'off')
		set(handles3.nodalTable, 'visible', 'off')
		set(handles3.uniformTable, 'visible', 'off')
	elseif strcmp(a, 'Nodos')
		set(fig3, 'name', 'Coordenadas de los nodos')
		set(handles3.nodesTable, 'visible', 'on')
		set(handles3.nodesTable, 'data', handles3.nodesMat)
		% visible off
		set(handles3.elemsTable, 'visible', 'off')
		set(handles3.nodalTable, 'visible', 'off')
		set(handles3.uniformTable, 'visible', 'off')
	elseif strcmp(a, 'Cargas nodales')
		set(fig3, 'name', 'Cargas y momentos nodales')
		set(handles3.nodalTable, 'visible', 'on')
		set(handles3.nodalTable, 'data', handles3.nodalMat)
		% visible off
		set(handles3.elemsTable, 'visible', 'off')
		set(handles3.nodesTable, 'visible', 'off')
		set(handles3.uniformTable, 'visible', 'off')
	elseif strcmp(a, 'Cargas unif.')
		set(fig3, 'name', 'Cargas distribuidas uniformes')
		set(handles3.uniformTable, 'visible', 'on')
		set(handles3.uniformTable, 'data', handles3.uniformMat)
		% visible off
		set(handles3.elemsTable, 'visible', 'off')
		set(handles3.nodesTable, 'visible', 'off')
		set(handles3.nodalTable, 'visible', 'off')
	end
	
	guidata(fig, handles) 
	guidata(fig3, handles3) 
	
end

% Data button
function dataTables(src, eventdata, fig, fig2)
	
	handles = guidata(fig) ;
	handles2 = guidata(fig2) ;
	set(fig2, 'visible', 'on')
	set(handles2.closeFig	, 'visible', 'on')
	
	set(handles2.addRow		, 'visible', 'on')
	set(handles2.deleteRow, 'visible', 'on')
	a = get(src, 'string') ;
	
	fig2Pos = get(fig2,'position') ;
	
	% Kglob table
	%--------------------
	if handles.kGlobCounter == 0 && handles.kGlobBool == 1
		thetaNames = cell(1, length(handles.nodesThetaSd)) ;
		for i = 1:length(handles.nodesThetaSd)
			thetaNamesAux = sprintf('theta_%i', i) ;
			thetaNames(1,i) =  thetaNamesAux ;
		end
		deltaNames = cell(1, length(handles.nodesDeltaSd(:,1))) ;
		for i = 1:length(handles.nodesDeltaSd(:,1))
			deltaNamesAux = sprintf('Delta_%i', handles.nodesDeltaSd(i,1)) ;
			deltaNames(1,i) =  deltaNamesAux ;
		end
		handles.kGlobNames = [thetaNames deltaNames] ;
		handles2.data2 = zeros(1,handles.onsasIncNumber) ;
		set(handles2.kGlobTable, 'columnname', handles.kGlobNames) ;
		set(handles2.kGlobTable, 'data', handles2.data2) ;
	end
	
	if strcmp(a, 'Incognitas')
		% Visible on
		set(handles2.incTable				, 'visible', 'on')
		% Visible off
		set(handles2.elemEcTable		, 'visible', 'off')
		set(handles2.kGlobTable			, 'visible', 'off')
		set(handles2.forcesTable		, 'visible', 'off')
		set(handles2.dispsValsTable	, 'visible', 'off')
		set(handles2.solicValsTable	, 'visible', 'off')
	elseif strcmp(a, 'Elem ec.')
		% Visible on
		set(handles2.elemEcTable		, 'visible', 'on')
		% Visible off
		set(handles2.incTable				, 'visible', 'off')
		set(handles2.kGlobTable			, 'visible', 'off')
		set(handles2.forcesTable		, 'visible', 'off')
		set(handles2.dispsValsTable	, 'visible', 'off')
		set(handles2.solicValsTable	, 'visible', 'off')
	elseif strcmp(a, 'K glob.')
		handles.kGlobCounter = 1 ;
		% Visible on
		set(handles2.kGlobTable			, 'visible', 'on')
		% Visible off
		set(handles2.incTable				, 'visible', 'off')
		set(handles2.elemEcTable		, 'visible', 'off')
		set(handles2.forcesTable		, 'visible', 'off')
		set(handles2.dispsValsTable	, 'visible', 'off')
		set(handles2.solicValsTable	, 'visible', 'off')
	elseif strcmp(a, 'F vector')
		handles.forcesNames = handles.kGlobNames' ;
		set(handles2.forcesTable, 'rowname', handles.forcesNames) ;
		if handles.forcesVectorCounter == 0
			set(handles2.forcesTable, 'data', zeros(length(handles.dofsVec),1)) ;
			handles.forcesVectorCounter = 1 ;
		end
		% Visible on
		set(handles2.forcesTable		, 'visible', 'on')
		% Visible off
		set(handles2.incTable				, 'visible', 'off')
		set(handles2.elemEcTable		, 'visible', 'off')
		set(handles2.kGlobTable			, 'visible', 'off')
		set(handles2.dispsValsTable	, 'visible', 'off')
		set(handles2.solicValsTable	, 'visible', 'off')
	elseif strcmp(a, 'Desps. vals.')
		% Visible on
		set(handles2.dispsValsTable, 'visible', 'on')
		% Visible off
		set(handles2.incTable				, 'visible', 'off')
		set(handles2.elemEcTable		, 'visible', 'off')
		set(handles2.kGlobTable			, 'visible', 'off')
		set(handles2.forcesTable		, 'visible', 'off')
		set(handles2.solicValsTable	, 'visible', 'off')
	elseif strcmp(a, 'Solic. vals.')
		% Visible on
		set(handles2.solicValsTable, 'visible', 'on')
		% Visible off
		set(handles2.incTable				, 'visible', 'off')
		set(handles2.elemEcTable		, 'visible', 'off')
		set(handles2.kGlobTable			, 'visible', 'off')
		set(handles2.forcesTable		, 'visible', 'off')
		set(handles2.dispsValsTable	, 'visible', 'off')
	end

	guidata(fig	, handles	) ;
	guidata(fig2, handles2) ;

end

function closeTable(src, eventdata, fig2, fig3)
	handles2 = guidata(fig2) ;
	handles3 = guidata(fig3) ;
	set(fig2, 'visible', 'off')
	set(fig3, 'visible', 'off')
	set(fig3, 'name', '')
	guidata(fig2, handles2) ;
	guidata(fig3, handles3) ;
end

% Verify button
function verif(src, eventdata, fig, fig2)
	
	handles = guidata(fig) ;
	handles2 = guidata(fig2) ;
	
	tagNumber = get(src, 'tag') ;

	if strcmp(tagNumber, '1')
		%
		incNumber = str2num(get(handles.incNumber, 'string')) ;
		if incNumber == handles.onsasIncNumber ;
			set(handles.resultIncNumber, 'string', 'Bien') 
		else
			set(handles.resultIncNumber, 'string', 'Error')
		end
	elseif strcmp(tagNumber, '2')
		%
		handles.unkStudent = get(handles2.incTable, 'data') ;
		handles.numberVerif = sum(sum(handles.unkStudent(:,2:end),2)) ;
		% script
		kernel
		
		if handles.numberVerif ~= handles.onsasIncNumber
			set(handles.resultIncTag, 'string', 'Error') ;
		else
			if size(handles.kernel,2) == 0
				set(handles.resultIncTag, 'string', 'Bien') 
			else
				set(handles.resultIncTag, 'string','Error')
			end
		end
		pinnedNodes = handles.pinnedNodes ;
		elemLengthsSd = handles.elemLengthsSd ;
		ConecSd = handles.ConecSd ;
		% script
		kGlobSD
		handles.Kglob = c(dofsVec,dofsVec) ;
		handles.nodesThetaSd = nodesThetaSd ;
		handles.nodesDeltaSd = nodesDeltaSd ; 
		handles.kGlobBool = 1 ;
		handles.nodesLevel = nodesLevel ;
		handles.dofsONSAS = dofsONSAS ;
	elseif strcmp(tagNumber, '3')
		%
		data = get(handles2.elemEcTable, 'data') ;
		
		nodalConstantLoadsSD = handles.nodalConstantLoadsSD ;
		ConecSd = handles.ConecSd ;
		secGeomProps = handles.secGeomProps ;
		hyperElasParams = handles.hyperElasParams ;
		elemLengthsSd = handles.elemLengthsSd ;
		nodalSpringsSd = handles.nodalSpringsSd ;
		NodesSd = handles.NodesSd ;
		elemAnglesSd = handles.elemAnglesSd ;
		elemNodalLoads = handles.elemNodalLoads ;
		% script
		elemEc
		
		if length(aux) == 0
			set(handles.resultEqVerif, 'string', 'Bien')
		else
			set(handles.resultEqVerif, 'string', 'Error')
		end
		
	elseif strcmp(tagNumber, '4')
		%
		
		KStudent = get(handles2.kGlobTable, 'data') ;
		
		if norm (handles.Kglob - KStudent ) < handles.tolCheck * norm ( handles.Kglob )
			set(handles.resultMatriK, 'string', 'Bien')
		else
			set(handles.resultMatriK, 'string', 'Error')
		end
	elseif strcmp(tagNumber, '5')
		%
		forcesVectorStudent = get(handles2.forcesTable, 'data') ;
		handles.ONSASforcesVector = handles.Kglob * handles.matDespsONSAS(handles.dofsONSAS) ;
		nDeltas = handles.deltaUnks ;
		handles.ONSASforcesVector((length(handles.ONSASforcesVector)-(nDeltas-1)):length(handles.ONSASforcesVector)) = handles.ONSASforcesVector((length(handles.ONSASforcesVector)-(nDeltas-1)):length(handles.ONSASforcesVector)) * -1 ;
		aux 	= find(handles.ONSASforcesVector(1:( length( handles.ONSASforcesVector )-(nDeltas-1)-1 )) < 0) ;
		aux2 	= find(handles.ONSASforcesVector(1:( length( handles.ONSASforcesVector )-(nDeltas-1)-1 )) > 0) ;
		handles.ONSASforcesVector(aux) = handles.ONSASforcesVector(aux) * -1 ;
		handles.ONSASforcesVector(aux2) = handles.ONSASforcesVector(aux2) * -1 ;
    if norm(handles.ONSASforcesVector - forcesVectorStudent) < handles.tolCheck * norm ( handles.ONSASforcesVector )
			set(handles.resultForces, 'string', 'Bien')
		else
			set(handles.resultForces, 'string', 'Error')
    end
	elseif strcmp(tagNumber, '6')
		%
		ndofpnode = 6 ;
		despsVals = get(handles2.dispsValsTable, 'data') ;
		nodedofs = [] ;
		for i = 1:size(despsVals,1)
			nod = despsVals(i,1) ;
			for j=1:handles.nnodesTot
				if isequal(handles.NodesSd(nod,:), handles.NodesO(j,:))
					newNod = j ;
				end
			end		
			nodedofs = [ nodedofs ; nodes2dofs(newNod, ndofpnode)([1 4 5]) ] ;	
		end
		aux = reshape(handles.matDespsONSAS(nodedofs),3,size(despsVals,1))' ;
		
		auxDeltas = find(despsVals(:,2)<0) ;
		auxThetas	= find(despsVals(:,3)<0) ;
		auxThetas2	= find(despsVals(:,3)>0) ;
		despsVals(auxDeltas,2) = despsVals(auxDeltas,2)*-1 ;
		despsVals(auxThetas,3) = despsVals(auxThetas,3)*-1 ;
		despsVals(auxThetas2,3) = despsVals(auxThetas2,3)*-1 ; 
		
		if norm( aux - despsVals(:,2:end) ) < handles.tolCheck * norm ( aux )  
			set(handles.resultDispsVals, 'string', 'Bien')
		else
			set(handles.resultDispsVals, 'string', 'Error')
		end
	elseif strcmp(tagNumber, '7')
		%
	end
	
	
	
	guidata(fig, handles) ;
	guidata(fig2,handles2) ;
end




% Action buttons
function actionButton(src, eventdata, fig, fig3)
	
	handles 	= guidata(fig) ;
	handles3 	= guidata(fig3) ;
	
	buttonString = get(src, 'string') ;
  
  handles.currDir = pwd ;
  
  handles.onsasPath = [ pwd '/onsas'] ;
  addpath( [ handles.onsasPath '/sources'] );
	addpath( [ handles.onsasPath '/input'  ] );
  
	if strcmp(buttonString, 'Cargar .m')
		[fname, fpath] = uigetfile([handles.onsasPath '/input/*.m']);
		if fname == 0
			return
		else	
			handles.fname = fname ;
			handles.fpath = fpath ;
		end
		% Run file
		run(handles.fname) ;
		% Run ONSAS
		%~ run([ handles.fpath handles.fname]);
		
		environInputVars = 1 ;
		
		% Auxiliar ONSAS parameters
		plotParamsVector = [0] ;
		printflag = 2 ;
		analyticSolFlag = 0 ;
		
		cd (handles.onsasPath)
		
		ONSAS
		
		cd (handles.currDir)
		
		% Original parameters
		handles.NodesO 								= Nodes 												;
		handles.ConecO 								= Conec 												;
		handles.nodalSpringsO 				= nodalSprings 									;
		handles.nnodesO 							= nnodes 												;
		handles.nelemsO 							= nelems 												;
		handles.constantFextO 				= constantFext 									;
		handles.matDespsONSAS 				= matUG 												;
		handles.nnodesTot 						= nnodes 												;
		handles.secGeomProps 					= secGeomProps 									;
		handles.hyperElasParams 			= hyperElasParams 							;
		handles.inputONSASversion 		= inputONSASversion 						;
		handles.problemName 					= problemName 									;
		handles.nonLinBool 						= nonLinearAnalysisBoolean = 0 	;
		handles.dynBool 							= dynamicAnalysisBoolean = 0 		;
		
		onsas2sd
		
		setProblemDataPanel
		
		% SD parameters
		handles.nnodesSd 							= nnodesSd 											;
		handles.nelemsSd 							= nelemsSd 											; 
		handles.nodalSpringsSd 				= nodalSpringsSd 								;	 
		handles.NodesSd 							= NodesSd 											; 
		handles.ConecSd 							= ConecSd 											; 
		handles.nodesRep 							= nodesRep 											;
		handles.propsNodes				 		= propsNodes 										;
		handles.condMatrix 						= condMatrix 										;
		handles.elemLengthsSd 				= elemLengthsSd 								;
		handles.nodalConstantLoadsSD 	= nodalConstantLoadsSD 					;
		handles.fixeddofs 						= fixeddofs 										;
		handles.constantFext 					= constantFext 									;
		handles.onsasIncNumber 				= onsasIncNumber 								;
		handles.elemAnglesSd					= elemAnglesSd									;
		handles.elemNodalLoads				= elemNodalLoads								;
		handles.pinnedNodes						= pinnedNodes 									; 
		
		% Plot geommetry and loads
		plotSd
		
	elseif strcmp(buttonString, 'Licencia')
		h = msgbox('Read LICENSE file for more details.', 'License directory.') ;
	end
	
	guidata(fig, handles) ;	
	guidata(fig3, handles3) ;	
	
end

