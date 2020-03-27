# Volatiltiy Calculations

## Table of Contents

- [Introduction](#Introduction)
- [Volatility Index Calculation (Python)](#volatilityindex)
- [Erik (R)](#erik)
- [Team](#team)
- [Support](#support)
- [License](#license)


---

## Introduction
This project was done as part of the quantitative portfolio management course at the University of St. Gallen. Our main goal was it to get a better understanding for volatility as well as its use cases.<br>
The Literature we used was:<br>
>Hilpsch (2017): Listed Volatility and Variance Derivatives

>Gruenbichler and Longstaff (1996): Valuing Futures and Options on Volatility, Journal of Banking & Finance

All Data used during this project was sourced from Bloomberg.

---

## <a name="volatilityindex"></a> Volatility Index Calculation (/python)

- [General Information](#pythongeneral)
- [calculation of the VSTOXX Index](#pythonvstoxx)
- [creation of a MSCI world volatility index](#pythonmsci)

### <a name="pythongeneral"></a> 1. General Information
All functions needed to compute the volatility index can be imported from the VIndex package. The other two classes (plotter_class.py and importer_class.py) are just used to get the data ready and plot it in a nice manner and will therefore not discussed further.<br>

From the VIndex package you can import the volatiltiy class which is used to do all necessary calcualtions. <br>
To use this class it needs to be initialized with option and interest data. The requirements for this data are as follows:<br>

```python
VSTOXXCalc = volatility_index(options, interest)
```
>options [pd.Dataframe]: "call_price" [float], "call_volume" [float], "date" [pd.Timestamp] , "maturity" [float], "strike" [float], "put_price" [float], "put_volume" [float]<br>

>interest [pd.Dataframe]: "interest_rate" [float], "date" [pd.Timestamp]<br>

The user can execute the following functions:

```python
VSTOXXCalc.calculate_index(min_price = 0.5, min_volume = 0, min_num_options = 6, return_data = False)
```
This function calculates the 30 day volatility index. The following parameter can be handed over:<br>
>min_price [float]: minimum price a option need to have to be considered.<br>
>min_volume [float]: Parameter which can be set >0 if only liquid options should be taken into account.<br>
>min_num_options [float]: minimum number of options needed for the index to be calculated. If at a given date less than min_num_options are available, NA is returned for the index.<br>

The return contains the daily volatiltiy index in the column "VIndex". The data provided in the other columns is described below:<br>
><b>return</b> [pd.Dataframe]: ["V_1" [float], "M_1" [pd.Timestamp], "NO_1" [float], "V_2" [float], "M_2" [pd.Timestamp], "NO_2" [float], "N_1" [float], "N_2" [float], "T_1" [float], "T_2" [float],"VIndex" [float]]<br>

>V_{} [float]: Value of subindex.<br>
>M_{} [pd.Timestamp]: Maturity date of the options the subindex is based on.<br>
>NO_{} [float]: Number of options available to calculate this subindex.<br>
>N_{} [pd.Timedelta]: time until the options the subindex is based on expire.
>VIndex [float]: Final volatility Index for the day

```python
VSTOXXCalc.compare_index(index2)
```
This function compares the vindex stored in the class to another index provided and matches the type dimensions.The following parameter need to be handed over:<br>
>index2 [pd.Dataframe]: Dataframe containing the data of the second index (columns= "date" [pd.Timestamp], "Index" [float])<br>
>return [pd.Dataframe]: ["constructed" [float], "real" [float], "diff" [float]]
>constructed [float]:  Volatility index contructed inside the class<br>
>real [float]: Index provided in the function for the matching timestamps<br>
>diff [float]: Difference between the two indices in percent<br>

```python
VSTOXXCalc.save_index(filepath, indexname)
```
This function saves the index created in the class to .xslx. The following parameter need to be handed over:<br>
>filepath [string]: file path were the index.xlsx should be stored. A trailing "\" is required.
>indexname [string]: filename of the excel file

### <a name="pythonvstoxx"></a> 2. calculation of the VSTOXX Index
> Note: Due to copyright restrictions no data can be provided. However in the data.xlsm file (input/data.xlsm) the general structure of the data can be seen. Furthermore this file can be used to download the data at a Bloomberg terminal.

Calculation of the 1 month VSTOXX and comparision with the real 1 month VSTOXX to ensure correct implementation.<br>
related files: /current_vstoxx.py<br>
By running this the following graphics will be created:
[![Options Available per Day](/python/output/VSTOXX_avail_options.png)]()
[![EUROSTOXX50](/python/output/EUROSTOXX50_lastmonths.png)]()
[![constructed VSTOXX](/python/output/const_VSTOXX.png)]()
[![real VSTOXX](/python/output/real_VSTOXX.png)]()
[![Difference between constructed and real VSTOXX](/python/output/VSTOXX_difference_real_const.png)]()

### <a name="pythonmsci"></a> 3. creation of a MSCI world volatility index
> Note: Due to copyright restrictions no data can be provided. However in the data.xlsm file (python/input/data.xlsm) the general structure of the data can be seen. Furthermore this file can be used to download the data at a Bloomberg terminal.

Creation of a new volatility index based on the MSCI World index.<br>
related files: /msci_world.py<br>
By running this the following graphics will be created:
[![Options Available per Day](/python/output/VMSCI_avail_options.png)]()
[![MSCI World](/python/output/MSCIWorld_lastmonths.png)]()
[![constructed Volatility Index on the MSC World](/python/output/const_VMSCI2.png)]()

---

## <a name="erik"></a> Erik (/R)



---

## Team
- <a href="http://github.com/drwatson42" target="_blank">`github.com/drwatson42`</a>
- <a href="http://github.com/faruman" target="_blank">`github.com/faruman`</a> |

---

## Support

If you have any queations please reach out to me via my GitHub account.

---

## License
- Copyright 2020 © DrWatson42 & Faruman</a>.