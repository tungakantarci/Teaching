* Empirical exercise 

log using exercise, replace
use "C:\exercise - data" 

regress testscr str el_pct

* Label variables
label variable testscr "Average Test Score"
label variable str "Student Teacher Ratio"

* Examine data
describe
codebook
inspect
list in 1/40

* Compute summary statistics
summarize testscr, detail
summarize str, detail
corr testscr str
corr testscr str, covariance
pwcorr testscr str, sig

* Create a scatter diagram
scatter testscr str

* Regression
regress  testscr str 
estimates store testscores
estimates restore testscores

* Predicted values and residuals
predict yhat, xb
predict ehat, residuals
histogram ehat

log close
translate exerciseone.smcl exerciseone.txt, replace

* This file is prepared by Tunga Kantarci. Please do not redistribute 
* this file without permission. You can send your possible questions 
* or comments to kantarci@uvt.nl
