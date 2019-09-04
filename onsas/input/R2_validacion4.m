% portico R2 - UT
% ----------------------------------------------------------------------

inputONSASversion = '0.1.8' ;
problemName = 'R2_validacion4' ;

nonLinearAnalysisBoolean 	= 0 ;
dynamicAnalysisBoolean 		= 0 ;

E 	= 1 ;
nu 	= .3 ; 
hyperElasParams = cell(1,1) ;
hyperElasParams{1} = [ 1 E nu ] ;


Iy = 1 ;
A  = sqrt(Iy)*10^6 ;
Iz = 1 ; 
It = 1 ;

secGeomProps = [ A Iy Iz It ] ;

Nodes = [ 0 0 0 ; ...
					0 0 6 ; ...
					3 0 6 ; ...
					9 0 6 ; ...
					9 0 -3 ] ;

Conec = [ 1 2 0 0 1 1 2 ; ...
          2 3 0 0 1 1 2 ; ...
          3 4 0 0 1 1 2 ; ...
          5 4 0 0 1 1 2 ] ;
          

nodalSprings = [ 1 inf inf inf inf inf inf ; ...
                 5 inf inf inf inf inf inf ] ;          

P = -1 ; 

nodalConstantLoads = [ 3 0 0 0 0 P 0 ] ;

plotParamsVector = [2] ;
reportBoolean = 1 ;
linearDeformedScaleFactor = 75 ;
