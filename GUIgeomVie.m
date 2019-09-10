% R2 GUI geometry parameters

% General panel
  %~ genPanelFromBottom = 0 ;
  %~ genPanelFromLeft = 0 ;
  %~ genPanelWidth = 1 ;
  %~ genPanelHeight = 1 ;
  %~ vecGenPanel = [genPanelFromLeft, genPanelFromBottom, genPanelWidth, genPanelHeight] ;

	anchoPantalla = get(0,'screensize')(3) ;
  altoPantalla  = get(0,'screensize')(4) ;
  
  % Main window size
  anchoMenu = .8 * anchoPantalla ;
  altoMenu  = .8 * altoPantalla ;
  posXMenu = .1 * anchoPantalla ;
  posYMenu = .1 * altoPantalla ;
  vecFig = [posXMenu posYMenu anchoMenu altoMenu] ; % pixels

% ==============================================================================
% ----------------------------    Panel geometry    ----------------------------

% Problem panel

	problemPanelFromBottom = .825 ;
	problemPanelFromLeft = 0 ;
	problemPanelWidth = .5 ;
	problemPanelHeight = 1-problemPanelFromBottom ;
	vecProblemPanel = [problemPanelFromLeft, problemPanelFromBottom, problemPanelWidth, problemPanelHeight] ;

% Hypothesis panel
	
	hypPanelFromBottom = .825 ;
	hypPanelFromLeft = problemPanelWidth ;
	hypPanelWidth = 1-hypPanelFromLeft ;
	hypPanelHeight = 1-hypPanelFromBottom ;
	vecHypPanel = [hypPanelFromLeft, hypPanelFromBottom, hypPanelWidth, hypPanelHeight] ;
	
% Load panel
	sysActionsFromBottom = 0 ;
  sysActionsFromLeft = 0 ;
  sysActionsWidth = 1 ;
  sysActionsHeight = 0.1 ;
  vecSysActions = [sysActionsFromLeft, sysActionsFromBottom, sysActionsWidth, sysActionsHeight] ;

% Plot panel
	plotPanelFromBottom = sysActionsHeight ;
	plotPanelFromLeft = 0 ;
	plotPanelWidth = 0.5 ;
	plotPanelHeight = 1-sysActionsHeight-problemPanelHeight ;
	vecPlotPanel = [plotPanelFromLeft, plotPanelFromBottom, plotPanelWidth, plotPanelHeight] ;

% Label panel
	labelPanelFromBottom = sysActionsHeight ;
	labelPanelFromLeft = plotPanelWidth ;
	labelPanelWidth = 0.15 ;
	labelPanelHeight = plotPanelHeight ;
	vecLabelPanel = [labelPanelFromLeft, labelPanelFromBottom, labelPanelWidth, labelPanelHeight] ;

% Data panel
	dataPanelFromBottom = sysActionsHeight ;
	dataPanelFromLeft = plotPanelWidth+labelPanelWidth ;
	dataPanelWidth = 0.15 ;
	dataPanelHeight = plotPanelHeight ;
	vecDataPanel = [dataPanelFromLeft, dataPanelFromBottom, dataPanelWidth, dataPanelHeight] ;

% Verif panel
	verifPanelFromBottom = sysActionsHeight ;
	verifPanelFromLeft = plotPanelWidth+labelPanelWidth+dataPanelWidth ;
	verifPanelWidth = 0.1 ;
	verifPanelHeight = plotPanelHeight ;
	vecVerifPanel = [verifPanelFromLeft, verifPanelFromBottom, verifPanelWidth, verifPanelHeight] ;
	
% Result panel
	resultPanelFromBottom = sysActionsHeight ;
	resultPanelFromLeft = plotPanelWidth+labelPanelWidth+dataPanelWidth+verifPanelWidth-1e-4 ;
	resultPanelWidth = 1-resultPanelFromLeft ;
	resultPanelHeight = plotPanelHeight ;
	vecResultPanel = [resultPanelFromLeft, resultPanelFromBottom, resultPanelWidth, resultPanelHeight] ;

% ==============================================================================
% -------------------------------    General    --------------------------------

% From bottom - From left	
	ppfl = 0.015 * anchoPantalla ;
  ppfb = 0.01 * altoPantalla ;
	
% Button
	buttonH = 25 ;
	
% Load buttons
	buttonLH = 25 ;
  buttonLW = 100 ;
  incremLH = 0.085 * anchoPantalla ;
  ppfbSys = 0.0225 * altoPantalla ;	

% Editboxes
	editW = 50 ;
  editH = 20 ;
  
% From top, top edge distance
	ref = 0.0257 * altoPantalla + buttonH ;  
  
% ==============================================================================
% ---------------------------------    Rows    ---------------------------------
	
% First row - incNumber
	frfl = 0.015 * anchoPantalla ;
	
% ==============================================================================
% ------------------------------    fontsize    --------------------------------
	
	fontSize = 10 * (anchoPantalla<1500) + 10.5 * (anchoPantalla>=1500)*(anchoPantalla<2500) + 11 * (anchoPantalla>=2500) ;
  %~ fontSizeTitle = 11 * (anchoPantalla<1500) + 11.5 * (anchoPantalla>=1500)*(anchoPantalla<2500) + 12.5 * (anchoPantalla>=2500) ;
  fontSizePanel = 16 * (anchoPantalla<1500) + 17 * (anchoPantalla>=1500)*(anchoPantalla<2500) + 18 * (anchoPantalla>=2500) ;




