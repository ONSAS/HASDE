% portico R2
% ----------------------------------------------------------------------

inputONSASversion = '0.1.8' ;
problemName = 'R2_validacion1' ;

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
secGeomProps = [ A Iy Iz It ] ;

l = 6 ;

Nodes = [ 0 0 0 ; ...
					0 0 l ; ...
					l 0 l ] ;

Conec = [ 1 2 0 0 1 1 2 ; ...
          2 3 0 0 1 1 2 ] ;
          

nodalSprings = [ 1 inf inf inf inf inf inf ; ...
                 3 0 	 inf inf   0 inf inf ] ;          

nodalConstantLoads = [ 2 2 0 0 0 0 0 ] ;

plotParamsVector = [2] ;
reportBoolean = 1 ;

