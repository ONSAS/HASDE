% Script that impose student unkowns to the ...
% condition matrix condMatrix and calculates the kernel associated
% ---------------------------------------------------------------------- 

condMatrix = handles.condMatrix ;
unkStudent = handles.unkStudent ;
propsNodes = handles.propsNodes ; 
nnodesSd = handles.nnodesSd ;
pos = handles.pos ;

for i = 1:size(unkStudent,1)
	for j = 1:3
		vec = zeros(1,3*nnodesSd) ;
		if unkStudent(i,j+1) == 1
			dof = dofsNumber( unkStudent(i,1), propsNodes)(j) ;
			vec(dof) = 1 ;
			condMatrix = [ condMatrix ; vec ] ; 
		end
	end
end

condMatrix(:,pos) = [] ;

handles.kernel = null(condMatrix) ; 
