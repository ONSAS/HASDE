% portico R2 
% ----------------------------------------------------------------------

inputONSASversion = '0.1.8' ;
problemName = 'R2_validacion7' ;

nonLinearAnalysisBoolean 	= 0 ;
dynamicAnalysisBoolean 		= 0 ;

E 	= 30e6 ;
nu 	= .2 ; 
hyperElasParams = cell(1,1) ;
hyperElasParams{1} = [ 1 E nu ] ;


Iy = 0.9^4/12 ;
A  = sqrt(Iy)*10^6 ;
Iz = 1 ; 
It = 1 ;
A=1e6 ;
secGeomProps = [ A Iy Iz It ] ;

l = 8 ;

Nodes = [ 0 0 0 ; ...
					0 0 l ; ...
					l 0 l ; ...
					l 0 0 ] ;

Conec = [ 1 2 0 0 1 1 2 ; ...
          2 3 0 0 1 1 2 ; ...
          4 3 0 0 1 1 2 ] ;
          

nodalSprings = [ 1 inf inf inf inf inf inf ; ...
                 4 inf inf inf inf inf inf ] ;          

q	= 2.5 ; 
P = q*l/2 ;
M = q*l^2/2 ;

nodalConstantLoads = [ 2 P 0 0 M 0 0 ; ...
											 3 P 0 0 M 0 0 ] ;

unifLoad = [ 1 1 q 0 0 ; ...
						 3 1 q 0 0 ] ;

plotParamsVector = [2] ;
reportBoolean = 1 ;
linearDeformedScaleFactor = 75 ;



