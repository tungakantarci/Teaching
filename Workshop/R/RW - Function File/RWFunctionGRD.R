# R Workshop - Function File - Gradient

RWFunctionGRD = function(data,par) 
{
with(data,2%*%(t(X)%*%X)%*%par-2%*%t(X)%*%y)
}
