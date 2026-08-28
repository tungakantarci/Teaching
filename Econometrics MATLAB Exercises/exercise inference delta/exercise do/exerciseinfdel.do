* Empirical exercise - Delta method

* 1. Load data
clear all
* use 'M:\exercise.dta';
use "/Users/Tunga/Library/Mobile Documents/com~apple~CloudDocs/Academic/Teaching/Empirical exercise/MATLAB/exercise inference delta/exercise dta file/exercise.dta"

* 2. Keep and label variables
keep testscr avginc
label variable testscr "Average Test Score"
label variable avginc "Average per capita district income"

* 3. Regression with a logarithmic variable
gen lntestscr = ln(testscr) 
reg lntestscr avginc
estat vce
nlcom exp(_b[avginc]*5)-1

* 4. Extra 
display exp(_b[_cons] + _b[avginc]*15.3)*exp(0.00042/2)
nlcom exp(_b[_cons] + _b[avginc]*15.3)*exp(0.00042/2)
sum avginc, detail
hist avginc
test (IQ = 0.0075) // Stata considers a Wald test and therefore produces the F test. What was saught the t test.



