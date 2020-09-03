* Empirical exercise 5 - Part in Stata 

* 1. Load the data 
clear all 
* use "C:\Users\username\Desktop\exercisefive.dta"
use "/Users/Tunga/Library/Mobile Documents/com~apple~CloudDocs/Academic/Teaching/Material/Exercises Stata/Exercise 5/exercisefive - data definition adjusted for Econometrics 1/exercisefive.dta"
keep testscr str el_pct

* 2. Regression
regress testscr str el_pct

* 3. Hypothesis test on the population coefficient of str
scalar tc975 = invttail(417,0.025)
display tc975
scalar p29 = ttail(417,2.9)
display p29

* 4. CI for the population coefficient of str
regress testscr str el_pct, level(90)

* 5. Hypothesis test on the significance of the model
regress testscr
regress testscr str el_pct
scalar F95 = invFtail(2,417,0.05)
display F95
scalar P155 = Ftail(2,417,155.01)
display P155
help density functions

* 6. Prediction and inference
input
. 19.6 35
end
predict yhat, xb
list yhat str el_pct in 421
predict stdvyhat, stdp
list yhat stdvyhat str el_pct in 421

