# Volatiltiy Calculations
## Variance Replication
### 1. general information
All functions needed to compute the volatility index can be imported from the VIndex package. The other two classes (plotter_class.py and importer_class.py) are just used to get the data ready and plot it in a nice manner and will therefore not discussed further.

From the VIndex package you can import the volatiltiy class which is used to do all necessary calcualtions. 
To use this class it needs to be initialized with option and interest data. The requirements for this data are as follows:
options (pd.Dataframe()): 
interest (pd.Dataframe()): 
The user can execute the following functions:


### 2. calculation of the VSTOXX Index
Calculation of the 1 month VSTOXX and comparision with the real 1 month VSTOXX to ensure correct implementation.
related files: python/

### 3. creation of a volatility index based on the MSCI world
Creation of a new volatility index based on the MSCI World index.
related files: python/
