# R Workshop - Script File

# -------------------------------------------------------------------------
# 2. Program Window
# -------------------------------------------------------------------------
a = 1
file.edit('untitled.R')

# -------------------------------------------------------------------------
# 3. Interacting with R
# -------------------------------------------------------------------------
a = 2

# -------------------------------------------------------------------------
# 4. Creating a Script File
# -------------------------------------------------------------------------
setwd("M:/")
getwd()
file.edit('scriptfile.R')

# -------------------------------------------------------------------------
# 5. Program Syntax
# -------------------------------------------------------------------------
rm(list = ls(all = TRUE))
5+5
a = 5+5
a
b = a+1
b
a = as.matrix(a)
round(pi,3)
invisible(round(pi,3))

# -------------------------------------------------------------------------
# 6. Creating, Indexing, and Searching Arrays   
# -------------------------------------------------------------------------
d = 5
class(d)
d = c(2,7,5,1,8,9,0,1,1)
d
d = t(d)
d
length(d)
d[1,2]
d[1,1:3]
d = seq(0,10,2) 
d
d = c(2,7,5,1,8,9,0,1,1)
d
which(d == 1)

# -------------------------------------------------------------------------
# 7. Commenting, Breaking, and Masking Syntax in a Script File
# -------------------------------------------------------------------------
# You can add a line of comment.
a = 5+5 # You can annotate code.
# You can split a line of code across multiple lines. E.g.:
a = 
5+5
# You can mask multiple lines of code. E.g.:
# a = 5+5 
# b = a+1
# You can mask a single line of code. E.g.:
# a = 5+5

# -------------------------------------------------------------------------
# 8. Importing Raw Data Files
# -------------------------------------------------------------------------
rm(list = ls())
filename = "M:/RW - csv file.csv"
rwrdatafile = read.csv(filename,header = TRUE,sep = ",",dec = ".")
save(rwrdatafile,file = "M:/RW - rdata file.RData")

# -------------------------------------------------------------------------
# 9. Opening Data Files
# -------------------------------------------------------------------------
rm(list = ls())
load("M:/RW - rdata file.RData")

# -------------------------------------------------------------------------
# 10. Browsing the Data
# -------------------------------------------------------------------------
rwrdatafile[1:20,]
rwrdatafile[,1,drop = FALSE]
unique(rwrdatafile[,4])
rwrdatafile[rwrdatafile[,4] == 1,c(1,2,4)]
rwrdatafile[which(rwrdatafile[1:20,4] == 1),c(1,2,4)]
rwrdatafile[order(rwrdatafile[,2],-rwrdatafile[,1]),]
rwrdatafile = rwrdatafile[order(rwrdatafile[,2],-rwrdatafile[,1]),]
N = nrow(rwrdatafile)
k = ncol(rwrdatafile)

# -------------------------------------------------------------------------
# 11. Producing Descriptive Statistics
# -------------------------------------------------------------------------
colMeans(rwrdatafile)
mean(rwrdatafile[rwrdatafile[,4] == 1,1])
cbind(table(rwrdatafile[,2]),prop.table(table(rwrdatafile[,2])))
cor.test(rwrdatafile[,1],rwrdatafile[,3])
colMeans(rwrdatafile,na.rm = TRUE)
summary(rwrdatafile[,2])
which(is.nan(rwrdatafile[,2]))

# -------------------------------------------------------------------------
# 12. Creating Variables 
# -------------------------------------------------------------------------
wage = rwrdatafile[,1]
wage+1
-wage
wage^2
wage >= 20 & wage <= 40
as.numeric(wage >= 20 & wage <= 40)
as.matrix(.Last.value)
log(wage)
exp(wage)

# -------------------------------------------------------------------------
# 13. Manipulating Variables 
# -------------------------------------------------------------------------
rm(wage)
rwrdatafile[,-5]
rwrdatafile = rwrdatafile[!is.nan(rwrdatafile[,2]),]
rwrdatafile[rwrdatafile[,1] > 30,1] = NaN
sapply(rwrdatafile,class)

# -------------------------------------------------------------------------
# 14. Scalar vs Vector Oriented Coding 
# -------------------------------------------------------------------------
# Scalar-oriented coding
uniq = unique(rwrdatafile[,2])
length = length(uniq)
for (i in 1:length){
  rwrdatafile = rwrdatafile[-(which(rwrdatafile[,2] == uniq[i])[1]),]
}
# Vector-oriented coding 
uniq = unique(rwrdatafile[,2]) # uniq = as.matrix(unique(rwrdatafile[,2]))
tag = match(uniq,rwrdatafile[,2]) # tag = as.matrix(match(uniq,rwrdatafile[,2]))
rwrdatafile = rwrdatafile[-tag,]

# -------------------------------------------------------------------------
# 15. Prepare Data for Regression Analaysis
# -------------------------------------------------------------------------
rm(list = ls())
load("M:/RW - rdata file.RData")
rwrdatafile = rwrdatafile[!is.nan(rwrdatafile[,2]),]
N = nrow(rwrdatafile)
k = ncol(rwrdatafile)
for (i in 1:k){
  assign(names(rwrdatafile)[i],rwrdatafile[,i])
}

# -------------------------------------------------------------------------
# 16. Regression Analysis Using Matrix Algebra
# -------------------------------------------------------------------------
c = rep(1,N)
y = as.matrix(wage)
X = as.matrix(cbind(c,educ,exper))
B_hat = solve(t(X)%*%X)%*%t(X)%*%y

# -------------------------------------------------------------------------
# 17. Creating Graphs 
# -------------------------------------------------------------------------
install.packages("rgl")
library(rgl)
y_hat = X%*%B_hat
open3d(windowRect = c(100,100,900,900),family = "serif")
color = rainbow(length(y_hat))[rank(y_hat)]
plot3d(educ,exper,wage,col = color,type = "s",size = 0.5,xlim = c(0,20),ylim = c(0,60),zlim = c(-10,70),box = FALSE,axes = TRUE)
planes3d(B_hat[2],B_hat[3],-1,B_hat[1],alpha = 0.5,col = "azure")

# -------------------------------------------------------------------------
# 18. Working with a Custom-built Function
# -------------------------------------------------------------------------
source("M:/RWFunctionLSS.R")
RWFunctionLSS.Output = RWFunctionLSS(y,X)
RWFunctionLSS.Output[3]
lrm = lm(y ~ educ + exper)
summary(lrm)

# -------------------------------------------------------------------------
# 19. The Optimisation Problem of an Econometrician
# -------------------------------------------------------------------------
source("M:/RWFunctionSSE.R")
source("M:/RWFunctionGRD.R")
data = data.frame(y,X)
result = optim(par = c(1,1,1),fn = RWFunctionSSE,gr = RWFunctionGRD,data = data)
result[1]

# -------------------------------------------------------------------------
# 20. The Optimisation Problem of an Agent
# -------------------------------------------------------------------------
source("M:/RWFunctionCDU.R")
X_ig = c(15,5)
P = rbind(c(-4,-7),c(1,0),c(0,1))
I = c(-100,0,0)
result = constrOptim(X_ig,f = RWFunctionCDU,grad = NULL,P,I)
result[1]

# -------------------------------------------------------------------------
# 21. Debugging Program Code
# -------------------------------------------------------------------------
rm(list = ls())
load ("M:/RW - rdata file.RData")
uniq = unique(rwrdatafile[,2])
length = length(uniq)
for (i in 1:length){
  rwrdatafile = rwrdatafile[-(which(rwrdatafile[,7] == uniq[i])[1]),]
}

# -------------------------------------------------------------------------
# 22. Help System
# -------------------------------------------------------------------------
help.search("mean")
help(mean)
?mean
