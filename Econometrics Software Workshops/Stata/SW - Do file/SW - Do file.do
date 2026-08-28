* Stata Workshop - Do file

* ------------------------------------------------------------------------------
* 1. Program Window
* ------------------------------------------------------------------------------
use "M:\SW - Dataset One.dta"

* ------------------------------------------------------------------------------
* 2. Interacting with Stata
* ------------------------------------------------------------------------------
sum wage

* ------------------------------------------------------------------------------
* 3. Creating a Do File 
* ------------------------------------------------------------------------------
doedit

* ------------------------------------------------------------------------------
* 4. Program Syntax
* ------------------------------------------------------------------------------
search command syntax
summarize wage if female == 1 in 1/50, detail
sum wage 

* ------------------------------------------------------------------------------
* 5. Commenting and Breaking Syntax in a Do File
* ------------------------------------------------------------------------------
* You can add a line of comment. 
sum wage if female == 1, detail // You can annotate a command line. 
sum wage /* You can annotate within a command. */ if female == 1, detail
* You can split a line of command across multiple lines. E.g.:
#delimit;
sum wage 
if female == 1 
, detail
;#delimit cr

* ------------------------------------------------------------------------------
* 6. Opening Data Files
* ------------------------------------------------------------------------------
clear
global path "M:"
use "$path\SW - Dataset One.dta"

* ------------------------------------------------------------------------------
* 7. Describing the Data
* ------------------------------------------------------------------------------
describe
codebook
inspect
list
codebook wage educ
inspect educ
sort educ wage
inspect educ if educ >= 5
list educ in 1/40
set more off, permanently

* ------------------------------------------------------------------------------
* 8. Browsing the Data
* ------------------------------------------------------------------------------
browse wage educ
edit wage educ
order black white
browse if female == 1
list in 1/15
gsort educ -wage

* ------------------------------------------------------------------------------
* 9. Producing Descriptive Statistics
* ------------------------------------------------------------------------------
sum wage
sum wage, detail
tabulate educ
tabulate educ, missing sort
tabulate educ female
tabulate educ if educ >= 4
sort female educ
by female: sum educ
pwcorr wage educ, sig
count if educ >= 18
count if educ >= 18 & educ < .
count if educ >= 18 & !missing(educ)

* ------------------------------------------------------------------------------
* 10. Creating Variables 
* ------------------------------------------------------------------------------
help operators
generate wage1 = wage+1
gen negwage = -wage
gen wage2 = wage^2
gen wage3 = wage^2 if wage <= 40
gen lwage = log(wage)
help functions
gen higheduc = educ >= 10
drop higheduc
gen higheduc = cond(educ >= 10,1,0)
db generate

* ------------------------------------------------------------------------------
* 11. Manupulating Variables
* ------------------------------------------------------------------------------
drop wage
clear
use "$path\SW - Dataset One.dta"
keep wage
clear 
use "$path\SW - Dataset One.dta"
rename exper experience
drop in 985/1000
by educ: drop if _n == 1
clear 
use "$path\SW - Dataset Two.dta"
sum county
encode county, generate(countytwo)
browse county countytwo
sum countytwo
save "$path\SW - Dataset Two.dta", replace

* ------------------------------------------------------------------------------
* 12. Merging Two Datasets
* ------------------------------------------------------------------------------
clear 
use "$path\SW - Datatobemergedone.dta"
clear 
use "$path\SW - Datatobemergedtwo.dta"
clear
use "$path\SW - Datatobemergedone.dta"
merge 1:1 dist_cod using "$path\SW - Datatobemergedtwo.dta"
save "$path\SW - Datamerged.dta"
help merge

* ------------------------------------------------------------------------------
* 13. Regression Analysis Using Built-in Functions
* ------------------------------------------------------------------------------
clear
use "$path\SW - Dataset Two.dta" 
regress testscr
regress testscr str el_pct
scalar F95 = invFtail(2,417,0.05)
display F95
scalar P155 = Ftail(2,417,155.7)
display P155
scalar tc975 = invttail(417,0.025)
display tc975
scalar p29 = ttail(417,2.9)
display p29
help density functions

* ------------------------------------------------------------------------------
* 14. Prediction
* ------------------------------------------------------------------------------
clear
use "$path\SW - Dataset Two.dta" 
keep testscr str el_pct avginc
order testscr str el_pct avginc
input
. 19.6 35 .
end
reg testscr str el_pct
predict yhat, xb
list yhat testscr str el_pct in 421
predict sdpointprediction, stdp
list yhat sdpointprediction str el_pct in 421

* ------------------------------------------------------------------------------
* 15. Accessing Results
* ------------------------------------------------------------------------------
sum str
return list
display r(N)
ereturn list
display e(rmse)
matrix list e(b)
matrix B = e(b)
scalar b = B[1,3]
display b
gen avginc2 = avginc^2
regress testscr avginc avginc2
lincom _b[avginc] + 2 * _b[avginc2] * 15.3

* ------------------------------------------------------------------------------
* 16. Restoring Estimation Results
* ------------------------------------------------------------------------------
regress testscr str
estimates store modelone
regress testscr str avginc
estimates store modeltwo
estimates table modelone modeltwo
estimates table modelone modeltwo, star stats(N r2 rmse)
help estimates table 
help postestimation commands 

* ------------------------------------------------------------------------------
* 17. Creating Graphs
* ------------------------------------------------------------------------------
clear
use "$path\SW - Dataset Two.dta"
gen avginc2 = avginc*avginc
regress testscr avginc avginc2
predict yhat, xb
twoway (scatter testscr avginc) (connected yhat avginc, sort)
histogram testscr, percent title(Histogram of testscr data)

* ------------------------------------------------------------------------------
* 18. Regression Analysis Using Matrix Algebra 
* ------------------------------------------------------------------------------
clear 
use "$path\SW - Dataset Two.dta"
set matsize 500
gen cons = 1
mkmat cons str el_pct, mat(X)
mkmat testscr, mat(y)
matrix b = inv(X'*X)*(X'*y)
matrix list b 
regress testscr str el_pct

* ------------------------------------------------------------------------------
* 19. Writing a Loop
* ------------------------------------------------------------------------------
*
local variables "testscr str el_pct"
foreach var of local variables {
rename `var' `var'_this_is_it
}
*

* ------------------------------------------------------------------------------
* 20. The Optimisation Problem of an Econometrician 
* ------------------------------------------------------------------------------
clear 
use "$path\SW - Dataset Three.dta"
* Define the program and assign the name "probit_livingonmyown"
program define probit_livingonmyown
args lnf Xb
replace `lnf' = log(normal(`Xb'))*$ML_y1 if $ML_y1 == 1
replace `lnf' = log(1-normal(`Xb'))*(1-$ML_y1) if (1-$ML_y1) == 1
end
* Maximize the likelihood function
ml model lf probit_livingonmyown (deny = piratio), maximize
* Display results
ml display
* Standard probit regression syntax 
probit deny piratio

* ------------------------------------------------------------------------------
* 21. Saving Your Work
* ------------------------------------------------------------------------------
clear
cd "M:\"
log using swlogfile, replace
use "$path\SW - Dataset One.dta"
sum wage, detail
log close
translate swlogfile.smcl swlogfile.txt, replace

* ------------------------------------------------------------------------------
* 22. Help System
* ------------------------------------------------------------------------------
search summary statistics
help summarize
