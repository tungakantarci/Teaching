# R Workshop - Function File - Sum of Squared Errors

RWFunctionSSE = function(data,par) 
{
with(data,t((y-X%*%par))%*%(y-X%*%par))
}
