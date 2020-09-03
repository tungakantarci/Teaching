* Empirical exercise - The MM estimator and the two-step GMM estimator

* Load data
clear 
* use "M:\exercisegmm.dta"
use "/Users/Tunga/Library/Mobile Documents/com~apple~CloudDocs/Academic/Teaching/Empirical exercise/MATLAB/exercise gmm two step/exercise dta/exercisegmm.dta"

* Rescale the dependent
gen y = hhninc/10000

* MM estimation
gmm (y - exp({b0} - {b1}*age - {b2}*educ - {b3}*female)), instruments(age educ female) two

* GMM estimation
gmm (y - exp({b0} - {b1}*age - {b2}*educ - {b3}*female)), instruments(age educ female married hsat) two // wmatrix(robust) can be added as an option.

* Hansen-Sargan test
estat overid
