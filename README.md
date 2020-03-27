# Volatiltiy Calculations
## Variance Replication
### 1. general information
All functions needed to compute the volatility index can be imported from the VIndex package. The other two classes (plotter_class.py and importer_class.py) are just used to get the data ready and plot it in a nice manner and will therefore not discussed further.<br>

From the VIndex package you can import the volatiltiy class which is used to do all necessary calcualtions. <br>
To use this class it needs to be initialized with option and interest data. The requirements for this data are as follows:<br>
options [pd.Dataframe]: "call_price" [float], "call_volume" [float], "date" [pd.Timestamp] , "maturity" [float], "strike" [float], "put_price" [float], "put_volume" [float]<br>
interest (pd.Dataframe()): "interest_rate" [float], "date" [pd.Timestamp]<br>

The user can execute the following functions:

<b>calculate_index</b>(min_price = 0.5, min_volume = 0, min_num_options = 6, return_data = False)<br>
This function calculates the 30 day volatility index. The following parameter can be handed over:<br>
min_price [float]: minimum price a option need to have to be considered.<br>
min_volume [float]: Parameter which can be set >0 if only liquid options should be taken into account.<br>
min_num_options [float]: minimum number of options needed for the index to be calculated. If at a given date less than min_num_options are available, NA is returned for the index.<br>
return [pd.Dataframe]: ["V_1" [float], "M_1" [pd.Timestamp], "NO_1" [float], "V_2" [float], "M_2" [pd.Timestamp], "NO_2" [float], "N_1" [float], "N_2" [float], "T_1" [float], "T_2" [float],"VIndex" [float]]<br>
The return contains the daily volatiltiy index in the column "VIndex". The data provided in the other columns is described below:<br>
V_{} [float]: Value of subindex.<br>
M_{} [pd.Timestamp]: Maturity date of the options the subindex is based on.<br>
NO_{} [float]: Number of options available to calculate this subindex.<br>
N_{} [pd.Timedelta]: time until the options the subindex is based on expire.
VIndex [float]: Final volatility Index for the day

<b>compare_index</b>(index2)<br>
This function compares the vindex stored in the class to another index provided and matches the type dimensions.The following parameter need to be handed over:<br>
index2 [pd.Dataframe]: Dataframe containing the data of the second index (columns= "date" [pd.Timestamp], "Index" [float])<br>
return [pd.Dataframe]: ["constructed" [float], "real" [float], "diff" [float]]
constructed [float]:  Volatility index contructed inside the class<br>
real [float]: Index provided in the function for the matching timestamps<br>
diff [float]: Difference between the two indices in percent<br>

<b>save_index</b>(filepath, indexname):
This function saves the index created in the class to .xslx. The following parameter need to be handed over:<br>
filepath [string]: file path were the index.xlsx should be stored. A trailing "\" is required.
indexname [string]: filename of the excel file

### 2. calculation of the VSTOXX Index
Calculation of the 1 month VSTOXX and comparision with the real 1 month VSTOXX to ensure correct implementation.
related files: python/

### 3. creation of a volatility index based on the MSCI world
Creation of a new volatility index based on the MSCI World index.
related files: python/
