% portico R2 
% ----------------------------------------------------------------------

inputONSASversion = '0.1.8' ;
problemName = 'R2_validacion3' ;

nonLinearAnalysisBoolean 	= 0 ;
dynamicAnalysisBoolean 		= 0 ;

E 	= 210e6 ;
nu 	= .3 ; 
hyperElasParams = cell(1,1) ;
hyperElasParams{1} = [ 1 E nu ] ;


Iy = 4.25e-5 ;
A  = sqrt(Iy)*10^6 ;
Iz = 1 ; 
It = 1 ;
A=1e6 ;
secGeomProps = [ A Iy Iz It ] ;

l = 6 ;

Nodes = [ 0 0 0 ; ...
					0 0 l/2 ; ...
					0 0 l ; ...
					l 0 l ] ;

Conec = [ 1 2 0 0 1 1 2 ; ...
          2 3 0 0 1 1 2 ; ...
          3 4 0 0 1 1 2 ] ;
          

nodalSprings = [ 1 inf inf inf inf inf inf ; ...
                 4 0 	 inf inf   0 inf inf ] ;          

P = 2 ; 
R = 5 ;
q	= -10 ; 

nodalConstantLoads = [ 3 P 0 0 0 0 0 ; ...
											 2 R 0 0 0 0 0 ] ;

unifLoad = [ 3 1 0 0 q ] ;

plotParamsVector = [2] ;
reportBoolean = 1 ;
linearDeformedScaleFactor = 75 ;
