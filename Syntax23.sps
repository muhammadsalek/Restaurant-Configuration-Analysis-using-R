* Encoding: UTF-8.
* Filter data for specific respondents (Talal, Ahmeed, Omar).
COMPUTE filter_$ = (Respondent = "Talal" OR Respondent = "Ahmeed" OR Respondent = "Omar").
FILTER BY filter_$.
EXECUTE.

* Create dummy variables for Cuisine (Pizza and Thai).
DO IF (Cuisine = "Pizza").
   COMPUTE Pizza = 1.
   COMPUTE Thai = 0.
ELSE IF (Cuisine = "Thai").
   COMPUTE Pizza = 0.
   COMPUTE Thai = 1.
ELSE.
   COMPUTE Pizza = 0.
   COMPUTE Thai = 0.
END IF.

* Create dummy variables for Service (FlatFee and TipOption).
DO IF (Service = "Flat fee").
   COMPUTE FlatFee = 1.
   COMPUTE TipOption = 0.
ELSE IF (Service = "Tip option").
   COMPUTE FlatFee = 0.
   COMPUTE TipOption = 1.
END IF.

* Perform regression again with the new dummy variables.
REGRESSION 
  /DEPENDENT Rating 
  /METHOD=ENTER Price Distance Pizza Thai FlatFee TipOption.

* Filter data for specific respondents again.
COMPUTE filter_$ = (Respondent = "Talal" OR Respondent = "Ahmeed" OR Respondent = "Omar").
FILTER BY filter_$.
EXECUTE.

* Create dummy variables again for Cuisine.
DO IF (Cuisine = "Pizza").
   COMPUTE Pizza = 1.
   COMPUTE Thai = 0.
ELSE IF (Cuisine = "Thai").
   COMPUTE Pizza = 0.
   COMPUTE Thai = 1.
ELSE.
   COMPUTE Pizza = 0.
   COMPUTE Thai = 0.
END IF.

* Create dummy variable for Service (TipOption).
DO IF (Service = "Tip option").
   COMPUTE TipOption = 1.
ELSE.
   COMPUTE TipOption = 0.
END IF.
EXECUTE.

* Calculate Predicted Ratings for Pizza + TipOption and Thai + FlatFee.
COMPUTE Predicted_Rating_Pizza_TipOption = 6.249 + (-0.111 * Price) + (0.003 * Distance) + (0.556 * Pizza) + (-0.389 * Thai) + (0.918 * TipOption).
EXECUTE.

COMPUTE Predicted_Rating_Thai_FlatFee = 6.249 + (-0.111 * Price) + (0.003 * Distance) + (0.556 * Pizza) + (-0.389 * Thai) + (0.918 * 0).
EXECUTE.

* Filter data for specific respondents again.
COMPUTE filter_$ = (Respondent = "Talal" OR Respondent = "Ahmeed" OR Respondent = "Omar").
FILTER BY filter_$.
EXECUTE.

* Create dummy variables again for Cuisine.
DO IF (Cuisine = "Pizza").
   COMPUTE Pizza = 1.
   COMPUTE Thai = 0.
ELSE IF (Cuisine = "Thai").
   COMPUTE Pizza = 0.
   COMPUTE Thai = 1.
ELSE.
   COMPUTE Pizza = 0.
   COMPUTE Thai = 0.
END IF.

* Create dummy variable for Service (TipOption).
DO IF (Service = "Tip option").
   COMPUTE TipOption = 1.
ELSE.
   COMPUTE TipOption = 0.
END IF.
EXECUTE.

* Calculate Predicted Ratings for Pizza + TipOption and Thai + FlatFee.
COMPUTE Predicted_Rating_Pizza_TipOption = 6.249 + (-0.111 * Price) + (0.003 * Distance) + (0.556 * Pizza) + (-0.389 * Thai) + (0.918 * TipOption).
EXECUTE.

* Corrected formula for Thai + FlatFee, where TipOption is 0 (FlatFee).
COMPUTE Predicted_Rating_Thai_FlatFee = 6.249 + (-0.111 * Price) + (0.003 * Distance) + (0.556 * Pizza) + (-0.389 * Thai) + (0.918 * 0).
EXECUTE.

* Descriptive statistics for Predicted Ratings.
DESCRIPTIVES VARIABLES=Predicted_Rating_Pizza_TipOption Predicted_Rating_Thai_FlatFee 
  /STATISTICS=MEAN STDDEV MIN MAX.


* Splitting file by Respondent for separate analyses.
SORT CASES BY Respondent.
SPLIT FILE SEPARATE BY Respondent.
DESCRIPTIVES VARIABLES=Predicted_Rating_Pizza_TipOption Predicted_Rating_Thai_FlatFee 
  /STATISTICS=MEAN STDDEV MIN MAX.

* Turn off split file.
SPLIT FILE OFF.

