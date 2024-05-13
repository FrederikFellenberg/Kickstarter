********************************************************************************
********************************* Start of do-file******************************
********************************************************************************
version 18
clear all 
capture log close
set more off

global path "C:\Users\frede\OneDrive\Dokumente\KickstarterSuccessDeterminants\Stata"

log using "$path\kickstarter.log", replace 

********************************************************************************
*********************************** First Dataset ******************************
********************************************************************************

use "$path\data_final_all_stata.dta", clear

***************************** Renaming of Variables ****************************

gen new_date = mdy(1,1,1960) + start_date - 1
format new_date %td
drop start_date
rename new_date start_date

gen new_date = mdy(1,1,1960) + end_date - 1
format new_date %td
drop end_date
rename new_date end_date

generate Category = category
drop category

generate Continent = continent
drop continent

encode Continent, generate(continent_categorized)
drop Continent
rename continent_categorized Continent

encode Category, generate(category_categorized)
drop Category
rename category_categorized Category

encode subcategory, generate(subcategory_categorized)
drop subcategory
rename subcategory_categorized subcategory

generate open_call_categories = open_call
drop open_call 

generate open_call = 0 
replace open_call = 1 if open_call_categories != "None"

label define open_call 0 "No" 1 "Yes"
label values open_call open_call

generate Success = success
drop success

generate Funded = funded_usd
drop funded_usd

generate Goal = goal_usd
drop goal_usd

generate Backers = backers
drop backers

generate Duration = duration 
drop duration 

generate Blurb = blurb_length
drop blurb_length

generate OpenCall = open_call 
drop open_call

generate VideoHeader = video_header
drop video_header

generate UpdatesAll = updates_all
drop updates_all

generate Comments = comments
drop comments

generate Sentiment = sentiment
drop sentiment

generate State = state
drop state

generate Videos = videos_description
drop videos_description

generate Images = images_description
drop images_description

generate Rewards = reward_stages
drop reward_stages

generate Verified = creator_verified
drop creator_verified

generate Links = websites_linked
drop websites_linked

generate Updates = updates_period
drop updates_period

generate Backed = backed_projects
drop backed_projects

generate Projects = previous_projects
drop previous_projects

generate Supported = previous_success
drop previous_success

generate Favorite = team_favorite
drop team_favorite

**************************** Descriptive Statistics ****************************

table State, ///
    statistic(frequency)  ///
    statistic(percent)
collect style cell result[percent], sformat("%s%%")
collect style cell State[.m], border(top)
collect export $path\Tables\table-state-data-all.tex


drop if State == "Funding Canceled" | State == "Funding Suspended"

local vars Funded Goal Backers Duration Blurb Favorite OpenCall VideoHeader Videos Images Rewards Verified Links Updates UpdatesAll Backed Supported Comments Sentiment 

#delimit ;
	table ,
		statistic(mean `vars')
		statistic(median `vars')
		statistic(sd `vars')
		statistic(min `vars')
		statistic(max `vars')
		statistic(skewness `vars')
		statistic(kurtosis `vars')
		;
#delimit cr
collect layout (var) (result)
collect export $path\Tables\summarize-data-all.tex


estpost correlate Funded Goal Backers Duration Blurb Favorite OpenCall VideoHeader Videos Images Rewards Verified Links Updates UpdatesAll Backed Supported Comments Sentiment, matrix listwise 
est store c1
esttab * using C:\Users\frede\OneDrive\Dokumente\KickstarterSuccessDeterminants\Stata\Tables\Corr1.csv , unstack not noobs compress

*********************************** Skewness ***********************************

kdensity Funded if Funded < 100000, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Funded") legend(on rows(1) size(*0.5) order(1 2)region(lcolor(black))) name(kdensity_funded) xlabel(#3) nodraw

kdensity Goal if Goal < 100000, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Goal") legend(size(*1)) legend(region(lcolor(black))) xlabel(#2) name(kdensity_goal) nodraw

kdensity Backers if Backers < 4500, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Backers") legend(size(*1)) legend(region(lcolor(black))) xlabel(#2) name(kdensity_backers) nodraw

kdensity Duration, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Duration") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_duration) nodraw

kdensity Blurb, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Blurb") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_blurb) nodraw

kdensity Videos if Videos < 20, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Videos") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_videos) nodraw

kdensity Images, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Images") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_images) nodraw

kdensity Rewards, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Rewards") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_rewards) nodraw

kdensity Links, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Links") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_links) nodraw

kdensity Updates, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Updates") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_updates) nodraw

kdensity UpdatesAll, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("UpdatesAll") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_updatesall) nodraw

kdensity Backed if Backed < 100, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Backed") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_backed) nodraw

kdensity Supported, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Supported") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_supported) nodraw

kdensity Comments if Comments < 400, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Comments") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_comments) nodraw

kdensity Sentiment, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Sentiment") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_sentiment) nodraw

grc1leg kdensity_funded kdensity_goal kdensity_backers kdensity_duration kdensity_blurb kdensity_videos kdensity_images kdensity_rewards kdensity_links kdensity_updates kdensity_updatesall kdensity_backed kdensity_supported kdensity_comments kdensity_sentiment, legendfrom(kdensity_funded)


graph drop _all

***************************** Transforming Variables ***************************

gen lnGoal = ln(Goal)
gen IHS_Funded = asinh(Funded)

************************** Skewness Transformed Variables **********************

kdensity IHS_Funded, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("IHS_Funded") legend(on rows(1) size(*0.8) order(1 2)region(lcolor(black))) name(kdensity_ihsfunded) xlabel(#3) nodraw

kdensity lnGoal, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("lnGoal") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_lngoal) nodraw

grc1leg kdensity_ihsfunded kdensity_lngoal, legendfrom(kdensity_ihsfunded)


graph drop _all

***************************** Multiple Linear Regression ***********************

drop if (Goal > 1000000) & (Funded/Goal < 0.001)


regress IHS_Funded lnGoal Duration Blurb VideoHeader Videos Images Rewards Links Updates Backed Supported Comments Sentiment i.Category, robust

outreg2 using regression.tex, replace ctitle(Model 1) drop(i.Category) dec(4)


regress IHS_Funded OpenCall lnGoal Duration Blurb VideoHeader Videos Images Rewards Links Updates Backed Supported Comments Sentiment i.Category, robust

outreg2 using regression.tex, append ctitle(Model 2) drop (i.Category) dec(4)

********************************************************************************
**************************** Test the assumptions ******************************
********************************************************************************

********************************** Linearity ***********************************

acprplot lnGoal, lowess msize(tiny) lsopts(bwidth(1) lpattern(dash) lcolor(orange_red)) msymbol(o) ytitle("Partial residuals") xtitle("lnGoal") name(acprplot_ihsgoal) legend(on rows(1) size(*0.5) order(2 3) region(lcolor(black))) nodraw

acprplot Duration, lowess msize(tiny) lsopts(bwidth(1) lpattern(dash) lcolor(orange_red)) msymbol(o) msize(tiny) ytitle("Partial residuals") xtitle("Duration") name(acprplot_duration) legend(on) nodraw 

acprplot Blurb, lowess msize(tiny) lsopts(bwidth(1) lpattern(dash) lcolor(orange_red)) msymbol(o) msize(tiny) ytitle("Partial residuals") xtitle("Blurb") name(acprplot_blurb) legend(on) nodraw

acprplot Videos, lowess msize(tiny) lsopts(bwidth(1) lpattern(dash) lcolor(orange_red)) msymbol(o) msize(tiny) ytitle("Partial residuals") xtitle("Videos") name(acprplot_ihsvideos) legend(on) nodraw

acprplot Images, lowess msize(tiny) lsopts(bwidth(1) lpattern(dash) lcolor(orange_red)) msymbol(o) msize(tiny) ytitle("Partial residuals") xtitle("Images") name(acprplot_ihsimages) legend(on) nodraw

acprplot Rewards, lowess msize(tiny) lsopts(bwidth(1) lpattern(dash) lcolor(orange_red)) msymbol(o) msize(tiny) ytitle("Partial residuals") xtitle("Rewards") name(acprplot_ihsrewards) legend(on) nodraw

acprplot Links, lowess msize(tiny) lsopts(bwidth(1) lpattern(dash) lcolor(orange_red)) msymbol(o) msize(tiny) ytitle("Partial residuals") xtitle("Links") name(acprplot_links) legend(on) nodraw

acprplot Updates, lowess msize(tiny) lsopts(bwidth(1) lpattern(dash) lcolor(orange_red)) msymbol(o) msize(tiny) ytitle("Partial residuals") xtitle("Updates") name(acprplot_updates) legend(on) nodraw

acprplot Backed, lowess msize(tiny) lsopts(bwidth(1) lpattern(dash) lcolor(orange_red)) msymbol(o) msize(tiny) ytitle("Partial residuals") xtitle("Backed") name(acprplot_backed) legend(on) nodraw

acprplot Supported, lowess msize(tiny) lsopts(bwidth(1) lpattern(dash) lcolor(orange_red)) msymbol(o) msize(tiny) ytitle("Partial residuals") xtitle("Supported") name(acprplot_supported) legend(on) nodraw

acprplot Comments, lowess msize(tiny) lsopts(bwidth(1) lpattern(dash) lcolor(orange_red)) msymbol(o) msize(tiny) ytitle("Partial residuals") xtitle("Comments") name(acprplot_ihscomments) legend(on) nodraw

acprplot Sentiment, lowess msize(tiny) lsopts(bwidth(1) lpattern(dash) lcolor(orange_red)) msymbol(o) msize(tiny) ytitle("Partial residuals") xtitle("Sentiment") name(acprplot_sentiment) legend(on) nodraw

grc1leg acprplot_ihsgoal acprplot_duration acprplot_blurb acprplot_ihsvideos acprplot_ihsimages acprplot_ihsrewards acprplot_links acprplot_updates acprplot_backed acprplot_supported acprplot_ihscomments acprplot_sentiment, legendfrom(acprplot_ihsgoal)

graph drop _all

******************************* Multicollinearity ******************************

vif
* --> no problematic multicollinearity: VIF below 2.5 for every variable


************************************ Residuals *********************************

drop resid
predict resid, residuals

kdensity resid, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Residuals") legend(on rows(2) size(*0.8) order(1 2) region(lcolor(black))) 

qnorm resid

rvfplot, yline(0) msize(tiny) 


********************************************************************************
********************************** Data subset *********************************
********************************************************************************

use "$path\data_final_subset_stata.dta", clear

***************************** Renaming of Variables ****************************

gen new_date = mdy(1,1,1960) + start_date - 1
format new_date %td
drop start_date
rename new_date start_date

gen new_date = mdy(1,1,1960) + end_date - 1
format new_date %td
drop end_date
rename new_date end_date

generate Category = category
drop category

generate Continent = continent
drop continent

encode Continent, generate(continent_categorized)
drop Continent
rename continent_categorized Continent

encode Category, generate(category_categorized)
drop Category
rename category_categorized Category

encode subcategory, generate(subcategory_categorized)
drop subcategory
rename subcategory_categorized subcategory

generate open_call_categories = open_call
drop open_call 

generate open_call = 0 
replace open_call = 1 if open_call_categories != "None"

label define open_call 0 "No" 1 "Yes"
label values open_call open_call

generate Success = success
drop success

generate Funded = funded_usd
drop funded_usd

generate Goal = goal_usd
drop goal_usd

generate Backers = backers
drop backers

generate Duration = duration 
drop duration 

generate Blurb = blurb_length
drop blurb_length

generate OpenCall = open_call 
drop open_call

generate VideoHeader = video_header
drop video_header

generate UpdatesAll = updates_all
drop updates_all

generate Comments = comments
drop comments

generate Sentiment = sentiment
drop sentiment

generate State = state
drop state

generate Videos = videos_description
drop videos_description

generate Images = images_description
drop images_description

generate Rewards = reward_stages
drop reward_stages

generate Verified = creator_verified
drop creator_verified

generate Links = websites_linked
drop websites_linked

generate Updates = updates_period
drop updates_period

generate Backed = backed_projects
drop backed_projects

generate Projects = previous_projects
drop previous_projects

generate Supported = previous_success
drop previous_success

generate Favorite = team_favorite
drop team_favorite

generate NewBackers = new_backers
drop new_backers

generate OldBackers = experienced_backers
drop experienced_backers

**************************** Descriptive Statistics ****************************

table State, ///
    statistic(frequency)  ///
    statistic(percent)
collect style cell result[percent], sformat("%s%%")
collect style cell State[.m], border(top)
collect export $path\Tables\table-state-data-all.tex


drop if State == "Funding Canceled" | State == "Funding Suspended"
 
local vars Funded Goal Backers OldBackers NewBackers Duration Blurb Favorite OpenCall VideoHeader Videos Images Rewards Verified Links Updates UpdatesAll Backed Supported Comments Sentiment 

#delimit ;
	table ,
		statistic(mean `vars')
		statistic(median `vars')
		statistic(sd `vars')
		statistic(min `vars')
		statistic(max `vars')
		statistic(skewness `vars')
		statistic(kurtosis `vars')
		;
#delimit cr
collect layout (var) (result)
collect export $path\Tables\summarize-data-all.tex


correlate Funded Goal Backers OldBackers NewBackers Duration Blurb Favorite OpenCall VideoHeader Videos Images Rewards Verified Links Updates UpdatesAll Backed Supported Comments Sentiment 

*********************************** Skewness ***********************************

kdensity Funded if Funded < 100000, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Funded") legend(on rows(1) size(*0.5) order(1 2)region(lcolor(black))) name(kdensity_funded) xlabel(#3) nodraw

kdensity Goal if Goal < 100000, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Goal") legend(size(*1)) legend(region(lcolor(black))) xlabel(#2) name(kdensity_goal) nodraw

kdensity Backers if Backers < 4500, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Backers") legend(size(*1)) legend(region(lcolor(black))) xlabel(#2) name(kdensity_backers) nodraw

kdensity OldBackers if OldBackers < 4500, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("OldBackers") legend(size(*1)) legend(region(lcolor(black))) xlabel(#2) name(kdensity_oldbackers) nodraw

kdensity NewBackers if NewBackers < 1000, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("NewBackers") legend(size(*1)) legend(region(lcolor(black))) xlabel(#2) name(kdensity_newbackers) nodraw

kdensity Duration, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Duration") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_duration) nodraw

kdensity Blurb, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Blurb") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_blurb) nodraw

kdensity Videos if Videos < 20, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Videos") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_videos) nodraw

kdensity Images, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Images") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_images) nodraw

kdensity Rewards, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Rewards") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_rewards) nodraw

kdensity Links, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Links") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_links) nodraw

kdensity Updates, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Updates") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_updates) nodraw

kdensity UpdatesAll, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("UpdatesAll") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_updatesall) nodraw

kdensity Backed if Backed < 100, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Backed") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_backed) nodraw

kdensity Supported, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Supported") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_supported) nodraw

kdensity Comments if Comments < 400, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Comments") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_comments) nodraw

kdensity Sentiment, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Sentiment") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_sentiment) nodraw

grc1leg kdensity_funded kdensity_goal kdensity_backers kdensity_oldbackers kdensity_newbackers kdensity_duration kdensity_blurb kdensity_videos kdensity_images kdensity_rewards kdensity_links kdensity_updates kdensity_updatesall kdensity_backed kdensity_supported kdensity_comments kdensity_sentiment, legendfrom(kdensity_funded)


graph drop _all

***************************** Transforming Variables ***************************

gen lnOldBackers = ln(OldBackers)
gen IHS_NewBackers = asinh(NewBacker)
gen lnGoal = ln(Goal)

************************** Skewness Transformed Variables **********************

kdensity lnOldBackers, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("lnOldBackers") legend(on rows(1) size(*0.8) order(1 2)region(lcolor(black))) name(kdensity_lnoldbackers) xlabel(#3) nodraw

kdensity IHS_NewBackers, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("IHS_NewBackers") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_ihsnewbackers) nodraw

kdensity lnGoal, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("lnGoal") legend(size(*1)) legend(region(lcolor(black))) name(kdensity_lngoal) nodraw

grc1leg kdensity_lnoldbackers kdensity_ihsnewbackers kdensity_lngoal, legendfrom(kdensity_lnoldbackers)


graph drop _all

*************************** Negative Binomial Regression ***********************

drop if (Goal > 1000000) & (Funded/Goal < 0.001)


regress lnOldBackers OpenCall lnGoal Duration Blurb VideoHeader Videos Images Rewards Links Updates Backed Supported Comments Sentiment i.Category, robust

outreg2 using regression.tex, append ctitle(Model 3) drop (i.Category) dec(4)


regress IHS_NewBackers OpenCall lnGoal Duration Blurb VideoHeader Videos Images Rewards Links Updates Backed Supported Comments Sentiment i.Category, robust

outreg2 using regression.tex, append ctitle(Model 4) drop (i.Category) dec(4)

********************************************************************************
**************************** Test the assumptions ******************************
********************************************************************************

********************************** Linearity ***********************************

acprplot lnGoal, lowess msize(tiny) lsopts(lpattern(dash) lcolor(orange_red)) msymbol(o) ytitle("Partial residuals") xtitle("lnGoal") name(acprplot_lngoal_usd) legend(on rows(1) size(*0.5) order(2 3) region(lcolor(black))) nodraw

acprplot Duration, lowess msize(tiny) lsopts(lpattern(dash) lcolor(orange_red)) msymbol(o) msize(tiny) ytitle("Partial residuals") xtitle("Duration") name(acprplot_duration) legend(on) nodraw 

acprplot Blurb, lowess msize(tiny) lsopts(lpattern(dash) lcolor(orange_red)) msymbol(o) msize(tiny) ytitle("Partial residuals") xtitle("Blurb") name(acprplot_blurb_length) legend(on) nodraw

acprplot Videos, lowess msize(tiny) lsopts(lpattern(dash) lcolor(orange_red)) msymbol(o) msize(tiny) ytitle("Partial residuals") xtitle("Videos") name(acprplot_lnvideos_description) legend(on) nodraw

acprplot Images, lowess msize(tiny) lsopts(lpattern(dash) lcolor(orange_red)) msymbol(o) msize(tiny) ytitle("Partial residuals") xtitle("Images") name(acprplot_lnimages_description) legend(on) nodraw

acprplot Rewards, lowess msize(tiny) lsopts(lpattern(dash) lcolor(orange_red)) msymbol(o) msize(tiny) ytitle("Partial residuals") xtitle("Rewards") name(acprplot_lnreward_stages) legend(on) nodraw

acprplot Links, lowess msize(tiny) lsopts(lpattern(dash) lcolor(orange_red)) msymbol(o) msize(tiny) ytitle("Partial residuals") xtitle("Links") name(acprplot_lnwebsites_linked) legend(on) nodraw

acprplot Updates, lowess msize(tiny) lsopts(lpattern(dash) lcolor(orange_red)) msymbol(o) msize(tiny) ytitle("Partial residuals") xtitle("Updates") name(acprplot_lnupdates_period) legend(on) nodraw

acprplot Backed, lowess msize(tiny) lsopts(lpattern(dash) lcolor(orange_red)) msymbol(o) msize(tiny) ytitle("Partial residuals") xtitle("Backed") name(acprplot_lnbacked_projects) legend(on) nodraw

acprplot Supported, lowess msize(tiny) lsopts(lpattern(dash) lcolor(orange_red)) msymbol(o) msize(tiny) ytitle("Partial residuals") xtitle("Supported") name(acprplot_lnprevious_success) legend(on) nodraw

acprplot Comments, lowess msize(tiny) lsopts(lpattern(dash) lcolor(orange_red)) msymbol(o) msize(tiny) ytitle("Partial residuals") xtitle("Comments") name(acprplot_lncomments) legend(on) nodraw

acprplot Sentiment, lowess msize(tiny) lsopts(lpattern(dash) lcolor(orange_red)) msymbol(o) msize(tiny) ytitle("Partial residuals") xtitle("Sentiment") name(acprplot_sentiment) legend(on) nodraw

grc1leg acprplot_lngoal_usd acprplot_duration acprplot_blurb_length acprplot_lnvideos_description acprplot_lnimages_description acprplot_lnreward_stages acprplot_lnwebsites_linked acprplot_lnupdates_period acprplot_lnbacked_projects acprplot_lnprevious_success acprplot_lncomments acprplot_sentiment, legendfrom(acprplot_lngoal_usd)

graph drop _all

******************************* Multicollinearity ******************************

vif
* --> no problematic multicollinearity: VIF below 2.5 for every variable

************************************ Residuals *********************************

drop resid
predict resid, residuals

kdensity resid, normal title("") normopts(lpattern(dash) lcolor(orange_red)) ytitle("Density") xtitle("Residuals") legend(on rows(2) size(*0.8) order(1 2) region(lcolor(black))) 


qnorm resid

rvfplot, yline(0) msize(tiny)
