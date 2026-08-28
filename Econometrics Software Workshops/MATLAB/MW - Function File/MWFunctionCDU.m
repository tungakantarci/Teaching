% MATLAB Workshop - Function File - Cobb Douglas Utility

function CDU = MWFunctionCDU(X)
x1 = X(1);
x2 = X(2);
CDU = -(x1^0.5)*(x2^0.5);
end