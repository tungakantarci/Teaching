* Empirical exercise 2

* 1. Open the data file
clear all 
* use "C:\Users\username\Desktop\exercisethree.dta"
use "/Users/Tunga/Library/Mobile Documents/com~apple~CloudDocs/Academic/Teaching/Empirical Exercise/Stata/exercise two E1/exercisetwo - data E1/exercisethree.dta"

* 2. Rename variables 
rename q quarter
rename YD income 
rename CE consumption

* 3. Drop observations 
tab year
drop if year < 1953

* 4. Generate a time indicator 
sort year quarter
gen t = _n
order year quarter t

* 5. Carry out regression and analyse the residuals against time 
reg consumption income
predict e_hat, residuals
scatter e_hat t, name(scatter_ehat_t,replace) 
histogram e_hat, name(hist_e_hat,replace)

* 6. An attempt to curb heteroskedasticity 
gen income_ln = ln(income)	
gen consumption_ln = ln(consumption)	
reg consumption_ln income_ln
predict e_hat_ln, resid
scatter e_hat_ln t, name(scatter_e_hat_ln_t,replace)
hist e_hat_ln, name(hist_e_hat_ln,replace)

* 7. Regression with simulated consumption data  
reg consumption income
ereturn list, all 							
local rmse = e(rmse)						
display `rmse'							
gen e_new = rnormal(0,`rmse')		
gen consumption_sim = _b[_cons] + _b[income] * income + e_new
reg consumption_sim income
predict e_hat_sim, resid
scatter e_hat_sim t, name(scatter_e_hat_sim,replace)
hist e_hat_sim, name(hist_e_hat_sim,replace)

* 8. Exploiting the time series structure of the data 
twoway (line consumption t), name(line_consumption_t,replace)
twoway (line income t), name(line_income_t,replace)
tsset t
gen consumption_dif = d.consumption
gen income_dif = d.income
reg consumption_dif income_dif
predict e_hat_dif, resid
scatter e_hat_dif year, name(scatter_e_hat_dif_t,replace)
hist e_hat_dif, name(hist_e_hat_dif,replace)
