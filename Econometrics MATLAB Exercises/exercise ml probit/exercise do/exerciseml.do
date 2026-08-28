* ----------------------------------------------------------------------
* Empirical exercise - Probit model
* ----------------------------------------------------------------------

* ----------------------------------------------------------------------
* 1. Open the data, label and examine the variables 
* ----------------------------------------------------------------------
clear
*use "M:\exercisemlpro"
use "/Users/Tunga/Library/Mobile Documents/com~apple~CloudDocs/Academic/Teaching/Empirical exercise/MATLAB/exercise ml probit/exercise dta/exercisemlpro.dta"
label variable deny "Mortgage Application Decision"
label variable piratio "Payment Income Ratio"
tabulate deny
histogram piratio
tabulate black

* ----------------------------------------------------------------------
* 2. Compute summary statistics
* ----------------------------------------------------------------------
pwcorr deny piratio black, sig
scatter deny piratio

* ----------------------------------------------------------------------
* 3. Linear probability model
* ----------------------------------------------------------------------
regress deny piratio
predict phat, xb
summarize phat, detail
predict ehat, residuals
twoway (scatter ehat piratio)
regress deny piratio, robust
replace phat=0.999 if phat>=1
replace phat=0.001 if phat<=0
generate weight=1/(phat*(1-phat))
regress deny piratio [aweight=weight]
twoway (scatter deny piratio) (connected phat piratio, sort)
lincom _b[_cons]+_b[piratio]*1
count if (deny == 1 & phat > 0.5) | (deny == 0 & phat < 0.5)
display 2343/2708
count if (deny == 1 & phat > 0.8) | (deny == 0 & phat < 0.2)
display 2163/2708

* ----------------------------------------------------------------------
* 4. Probit and logit models
* ----------------------------------------------------------------------
probit deny piratio
scalar thisisit = _b[_cons] + _b[piratio]*0.4
display "Marginal effect of piratio = " normalden(thisisit)*_b[piratio]
mfx, at (piratio=0.4)
scalar one = _b[_cons] + _b[piratio]*0.5
scalar two = _b[_cons] + _b[piratio]*0.4
display "Difference in probabilities = " normal(one)-normal(two)
nlcom normalden(_b[_cons] + _b[piratio]*0.4)*_b[piratio]
probit deny
scalar chi = invchi2tail(1,0.05)
display chi
probit deny piratio
predict pphat
twoway (scatter deny piratio) (connected pphat piratio, sort)
display normal(1)
nlcom normal(_b[_cons] + _b[piratio]*1)

* ----------------------------------------------------------------------
* 5. Programming probit
* ----------------------------------------------------------------------
* Define program and assign the name "probit_livingonmyown"
program define probit_livingonmyown
args lnf index
replace `lnf'=log(normal(`index'))*$ML_y1+log(1-normal(`index'))*(1-$ML_y1)
end
* Maximize likelihood function
ml model lf probit_livingonmyown (index: deny = piratio), maximize
* Display results
ml display
* Standard probit regression syntax 
probit deny piratio
