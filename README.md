# Volatiltiy Calculations

## Table of Contents

- [Introduction](#Introduction)
- [Volatility Index Calculation (/Python)](#volatilityindex)
- [Volatility Derrivative Pricing (/R)](#volatilityderrivatives)
- [Volatility Trading Strategy (/R)](#volatilitytrading)
- [Team](#team)
- [Support](#support)
- [License](#license)


---

## Introduction
This project was done as part of the quantitative portfolio management course at the University of St. Gallen. Our main goal was it to get a better understanding of volatility as well as its use cases.<br>
The Literature we used was:<br>
>Hilpsch (2017): Listed Volatility and Variance Derivatives

>Gruenbichler and Longstaff (1996): Valuing Futures and Options on Volatility, Journal of Banking & Finance

>Bloomberg L.P. (2020) option prices SX5E, V2X, MXWO / prices SX5E, V2X, MXWO, FVS / interst rates US0003M, US0001M, EUR003M, EUR001M . Retrieved Mar. 17, 2020 from Bloomberg database

---

## <a name="volatilityindex"></a> Volatility Index Calculation (/python)

- [General Information](#pythongeneral)
- [Calculation of the VSTOXX Index](#pythonvstoxx)
- [Creation of a MSCI world volatility index](#pythonmsci)

### <a name="pythongeneral"></a> 1. General Information
All functions needed to compute the volatility index can be imported from the VIndex package. The other two classes (plotter_class.py and importer_class.py) are just used to get the data ready and plot it in a nice manner and will therefore not be discussed further.<br>

From the VIndex package you can import the volatiltiy class which is used to do all necessary calcualtions. <br>
To use this class it needs to be initialized with option and interest data. The requirements for this data are as follows:<br>

```python
VSTOXXCalc = volatility_index(options, interest)
```
><b>options</b> [pd.Dataframe]: "call_price" [float], "call_volume" [float], "date" [pd.Timestamp] , "maturity" [float], "strike" [float], "put_price" [float], "put_volume" [float]<br>

><b>interest</b> [pd.Dataframe]: "interest_rate" [float], "date" [pd.Timestamp]<br>

The user can execute the following functions:

```python
VSTOXXCalc.calculate_index(min_price = 0.5, min_volume = 0, min_num_options = 6, return_data = False)
```
This function calculates the 30 day volatility index. The following parameter can be handed over:<br>
><b>min_price</b> [float]: minimum price a option need to have to be considered.<br>
><b>min_volume</b> [float]: Parameter which can be set >0 if only liquid options should be taken into account.<br>
><b>min_num_options</b> [float]: minimum number of options needed for the index to be calculated. If at a given date less than min_num_options are available, NA is returned for the index.<br>

The return contains the daily volatiltiy index in the column "VIndex". The data provided in the other columns is described below:<br>
><b>return</b> [pd.Dataframe]: ["V_1" [float], "M_1" [pd.Timestamp], "NO_1" [float], "V_2" [float], "M_2" [pd.Timestamp], "NO_2" [float], "N_1" [float], "N_2" [float], "T_1" [float], "T_2" [float],"VIndex" [float]]<br>

><b>V_{}</b> [float]: Value of subindex.<br>
><b>M_{}</b> [pd.Timestamp]: Maturity date of the options the subindex is based on.<br>
><b>NO_{}</b> [float]: Number of options available to calculate this subindex.<br>
><b>N_{}</b> [pd.Timedelta]: time until the options the subindex is based on expire.<br>
><b>VIndex</b> [float]: Final volatility Index for the day<br>

```python
VSTOXXCalc.compare_index(index2)
```
This function compares the vindex stored in the class to another index provided and matches the type dimensions.The following parameter need to be handed over:<br>
><b>index2</b> [pd.Dataframe]: Dataframe containing the data of the second index (columns= "date" [pd.Timestamp], "Index" [float])<br>

><b>return</b> [pd.Dataframe]: ["constructed" [float], "real" [float], "diff" [float]]

><b>constructed</b> [float]:  Volatility index contructed inside the class<br>
><b>real</b> [float]: Index provided in the function for the matching timestamps<br>
><b>diff</b> [float]: Difference between the two indices in percent<br>

```python
VSTOXXCalc.save_index(filepath, indexname)
```
This function saves the index created in the class to .xslx. The following parameter need to be handed over:<br>
><b>filepath</b> [string]: file path were the index.xlsx should be stored. A trailing "\" is required.<br>
><b>indexname</b> [string]: filename of the excel file<br>

### <a name="pythonvstoxx"></a> 2. Calculation of the VSTOXX Index
> Note: Due to copyright restrictions no data can be provided. However in the data.xlsm file (/input/data.xlsm) the general structure of the data can be seen. Furthermore this file can be used to download the data at a Bloomberg terminal.

Calculation of the 1 month VSTOXX and comparision with the real 1 month VSTOXX to ensure correct implementation.<br>
related files: /current_vstoxx.py<br>
By running this the following graphics will be created:
[![Options Available per Day](/python/output/VSTOXX_avail_options.png)]()
[![EUROSTOXX50](/python/output/EUROSTOXX50_lastmonths.png)]()
[![constructed VSTOXX](/python/output/const_VSTOXX.png)]()
[![real VSTOXX](/python/output/real_VSTOXX.png)]()
[![Difference between constructed and real VSTOXX](/python/output/VSTOXX_difference_real_const.png)]()

### <a name="pythonmsci"></a> 3. Creation of a MSCI world volatility index
> Note: Due to copyright restrictions no data can be provided. However in the data.xlsm file (/input/data.xlsm) the general structure of the data can be seen. Furthermore this file can be used to download the data at a Bloomberg terminal.

Creation of a new volatility index based on the MSCI World index.<br>
related files: /msci_world.py<br>
By running this the following graphics will be created:
[![Options Available per Day](/python/output/VMSCI_avail_options.png)]()
[![MSCI World](/python/output/MSCIWorld_lastmonths.png)]()
[![constructed Volatility Index on the MSCI World](/python/output/const_VMSCI5.png)]()
[![constructed Volatility Index on the MSCI World](/python/output/const_VMSCI2.png)]()

---

## <a name="volatilityderrivatives"></a> Volatility Derrivative Pricing (/R)



---

## <a name="volatilitytrading"></a> Volatility Trading Strategy (/R)



---

## Team
- <a href="http://github.com/drwatson42" target="_blank">`github.com/drwatson42`</a>
- <a href="http://github.com/faruman" target="_blank">`github.com/faruman`</a>

---

## Support

If you have any queations please reach out to us via <a href="mailto:faruman.der.weise@googlemail.com">mail</a>.

---

## License
Copyright 2020 © DrWatson42 & Faruman</a>
