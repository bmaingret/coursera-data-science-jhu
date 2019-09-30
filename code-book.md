# Code book


* subject
  * Type: integer
  * Unit: integer factor with 30 levels
  * Description: Uniquely identifies one of the 30 subjects of the study

* activity
  * Type: factor
  * Unit: String factor with 6 levels (encoded in the text file with the level and the label)
  * Description: Identifies an activity as one of
    1. WALKING
    2. WALKING_UPSTAIRS
    3. WALKING_DOWNSTAIRS
    4. SITTING
    5. STANDING
    6. LAYING

* other features  follows the naming the one described in `features_info.txt` (part of the dataset) with a `_mean` suffix since this dataset summarized the variables by activity and subject with the mean.
  <br />`-` and `()` were replaced with `_`.
  <br /> Examples: tBodyAcc_mean_Z_mean : mean body acceleration signal along axis Z averaged over (activity, subject)