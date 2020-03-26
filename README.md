# Volatiltiy Calculations
## Variance Replication
### 1. general information
All functions needed to compute the volatility index can be imported from the VIndex package. The other two classes (plotter_class.py and importer_class.py) are just used to get the data ready and plot it in a nice manner and will therefore not discussed further.

From the VIndex package you can import the volatiltiy class which is used to do all necessary calcualtions. 
To use this class it needs to be initialized with option and interest data. The requirements for this data are as follows:
options (pd.Dataframe()): "call_price" [float], "call_volume" [float], "date" [pd.Timestamp] , "maturity" [float], "strike" [float], "put_price" [float], "put_volume" [float]
interest (pd.Dataframe()): "interest_rate" [float], "date" [pd.Timestamp]

The user can execute the following functions:
<b>calculate_subindices</b>(self, min_price = 0.5, min_volume = 0, min_num_options = 6, return_data = False)

### 2. calculation of the VSTOXX Index
Calculation of the 1 month VSTOXX and comparision with the real 1 month VSTOXX to ensure correct implementation.
related files: python/

### 3. creation of a volatility index based on the MSCI world
Creation of a new volatility index based on the MSCI World index.
related files: python/
