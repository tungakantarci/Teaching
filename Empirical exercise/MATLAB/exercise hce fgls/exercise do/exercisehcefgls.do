* Empirical exercise - Heteroskedasticity, the HCE, the FGLS estimator

* 2. Load the data
clear
* use "M:\exercisehcefgls.dta"
use "/Users/Tunga/Library/Mobile Documents/com~apple~CloudDocs/Academic/Teaching/Empirical exercise/MATLAB/exercise hce fgls/exercise dta/exercisehcefgls.dta"

* 6. Obtain the standard error estimates of the OLS coefficient estimates 
reg unaid dur ncb rank year

* 7. Obtain the standard error estimates of the OLS coefficient estimates that are robust to heteroskedasticity
* In Stata robust standard errors are obtained using the `robust' option of the 
* `regress' command. However, we do not see what is actually being calculated. 
* Therefore we practice with robust standard errors in MATLAB.
reg unaid dur ncb rank year, robust

* 8. Test for heteroskedasticity of unknown form 
*
foreach X in dur ncb rank year {
        foreach Y in dur ncb rank year {
                cap drop _`Y'`X'
                gen _`X'`Y'= `X'*`Y'
        }
}
*

predict e, resid
gen e2 = e^2
reg e2 dur ncb rank year _*

* Test for heteroskedasticity of unknown form in an augmented model 
gen rk_first = (rank == 1)
gen rk_last = (rank == ncb)
reg unaid dur ncb rk* year 
predict etwo, resid
gen etwo2 = e^2

* 9. Test for heteroskedasticity of known form 
gen le = log(e2)
reg le dur ncb rank year

*
foreach X in dur ncb rk_first rk_last year {
        foreach Y in dur ncb rk_first rk_last year {
                cap drop _`Y'`X'
                gen _`X'`Y'= `X'*`Y'
        }
}
*

reg etwo2 dur ncb rk* year _* 

* 10. Obtain the FGLS coefficient estimates 
reg le dur ncb rank year
predict le_hat
gen w_hat = exp(le_hat)
reg unaid dur ncb rank year [aweight = 1/w_hat]
