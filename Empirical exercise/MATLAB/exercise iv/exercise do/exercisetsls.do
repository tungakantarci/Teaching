* Empirical exercise - The two-stage least squares estimator 

* 2. Load the data 
clear all
* use "M:\exercisetsls.dta"
use "/Users/Tunga/Library/Mobile Documents/com~apple~CloudDocs/Academic/Teaching/Empirical exercise/MATLAB/exercise iv/exercise dta/exercisetsls.dta"

* 3. Produce descriptive statistics
pwcorr cigarcons cigarprice cigartax, sig

* 4. An endogenous variable and an instrumental variable
ivregress 2sls cigarcons (cigarprice = cigartax), robust first

* Aid for the comparison with MATLAB calculations 
ivregress 2sls cigarcons (cigarprice = cigartax), first robust
return list
matrix c = r(table)
matrix list c
scalar scalar_p_cigarprice = c[4,1]
scalar scalar_p_cons = c[4,2]
di scalar_p_cigarprice
di scalar_p_cons

regress cigarprice cigartax, robust
return list
matrix c = r(table)
matrix list c
scalar scalar_p_cigarprice = c[4,1]
scalar scalar_p_cigartax = c[4,2]
di scalar_p_cigarprice
di scalar_p_cigartax

* 5. The forbidden regression
regress cigarprice cigartax, robust
predict pcigarprice, xb
regress cigarcons pcigarprice, robust

* Aid for the comparison with MATLAB calculations 
regress cigarprice cigartax, robust
return list
matrix c = r(table)
matrix list c
scalar scalar_p_cigarprice = c[4,1]
scalar scalar_p_cons = c[4,2]
di scalar_p_cigarprice
di scalar_p_cons

* 6. Testing the relevance of the instrument 
regress cigarprice cigartax, robust

* 7. Testing the exogeneity of the instrument and failing to do so 
ivregress 2sls cigarcons (cigarprice = cigartax), robust
predict residualszero, residuals
regress residualszero cigartax

* 8. Testing the endogeneity of cigarprice 
* Hausman test version one
regress cigarcons cigarprice, robust
ivregress 2sls cigarcons (cigarprice = cigartax), robust
estat endogenous
* Hausman test version two 
ivregress 2sls cigarcons (cigarprice = cigartax) // Compute the always-consistent estimator.
estimates store nameconsistent
regress cigarcons cigarprice // Compute the estimator that is efficient under H0.
hausman nameconsistent
* The other test. 
regress cigarprice cigartax, robust
predict residualse, residuals
regress cigarcons cigarprice residualse, robust

* 9. Augment the instrumental var. regression with an exogenous var. 
gen incomerep = income/1000000
drop income
rename incomerep income
pwcorr cigartax income, sig
ivregress 2sls cigarcons (cigarprice = cigartax) income, robust 

* 10. An endogenous variable and two instrumental variables
ivregress 2sls cigarcons (cigarprice = cigartax cigartaxspecific) income, robust 
ivregress 2sls cigarcons (cigarprice = cigartax) income, robust

* 11. Testing the relevance of the two instruments 
regress cigarprice income cigartax cigartaxspecific, robust
regress cigarprice income, robust 

* 12. Testing the exogneity of the two instruments 
ivregress 2sls cigarcons (cigarprice = cigartax cigartaxspecific) income, robust
predict residuals, residuals
regress residuals cigartax cigartaxspecific income, robust
display "overidentification statistic:" e(N)*e(r2)
display "p-value:" chiprob(1,e(N)*e(r2))
test cigartax cigartaxspecific
