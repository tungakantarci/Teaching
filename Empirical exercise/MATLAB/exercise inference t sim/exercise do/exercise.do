* Empirical exercise - Understanding hypothesis testing using simulated distribtuion - Auxiliary file

* Load data
clear all
* use 'C:\Users\username\Desktop\exercise.mat';
use "/Users/Tunga/Library/Mobile Documents/com~apple~CloudDocs/Academic/Teaching/Empirical exercise/MATLAB/exercise sim inference/exercise dta file/exercise.dta"

* t test 
reg lwage IQ educ exper
test (IQ = 0.0075) // Stata considers a Wald test and therefore produces the F test. What was saught the t test.

* F test
gen agesquared = age*age
reg lwage IQ educ exper age agesquared
test age agesquared
