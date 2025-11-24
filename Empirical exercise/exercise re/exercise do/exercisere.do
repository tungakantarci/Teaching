* Empirical exercise - The RE estimator as the FGLS estimator

* 2. Load data
clear
* use "M:\exercisere.dta"
use "/Users/Tunga/Library/Mobile Documents/com~apple~CloudDocs/Academic/Teaching/Empirical exercise/MATLAB/exercise re/exercise dta/exercisere.dta"
keep nr year wage union exper school black hisp mar hlth rur  
xtset nr year // Declare data as panel. 

* 10. Obtain the RE coefficient estimates as the FGLS coefficient estimates
xtreg wage union exper c.exper#c.exper school black hisp mar hlth rur, re
