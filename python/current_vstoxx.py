## Data import and description
# option importer
from importer_class import option_importer
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from plotter_class import time_chart, day_time_chart, bar_chart, year_time_chart

data_path = 'input/data.xlsm'

#options importer
option_sheets = ["v2x_call", "v2x_put", "mxwo_call", "mxwo_put", "stoxx_call", "stoxx_put"]
column_names = ["PX_LAST", "PX_VOLUME"]
processing_dict = {'stoxx':{"maturity_dict": False, "maturity": '([0-9][0-9])(\/)([0-9][0-9])(\/)([0-9][0-9])', "strike": '(?!.*(C|P)).*?(?= )'}, 'mxwo':{"maturity_dict": False, "maturity": '([0-9][0-9])(\/)([0-9][0-9])(\/)([0-9][0-9])', "strike": '(?!.*(C|P)).*?(?= )'}, 'v2x':{"maturity_dict": True, "maturity": '[^FVS]', "strike": '(?<=\s)(.*?)(?=\s)'}}
maturity_dict = {"H":"03/17/20", "J":"04/15/20", "K":"05/20/20", "M":"06/17/20","N":"07/22/20","Q":"08/19/20", "U":"09/16/20", "V":"10/21/20"}

opt_importer = option_importer(data_path)
opt_importer.option_import(option_sheets,column_names, processing_dict, maturity_dict, False)
options = opt_importer.clean_data(["PX_LAST", "date"], True)

# index importer
from importer_class import index_importer

index_sheets = ["Index"]

ind_importer = index_importer(data_path)
ind_importer.index_import(index_sheets, False)
indexes = ind_importer.clean_data(["PX_LAST", "date"], True)

#interest rate importer
from importer_class import index_importer

index_sheets = ["Rates"]

ind_importer = index_importer('input/data_europe_compact_v6.xlsm')
ind_importer.index_import(index_sheets, False)
interest_rates = ind_importer.clean_data(["PX_LAST", "PX_VOLUME"], True)

euribor = interest_rates["EUR001M Index"]
euribor = euribor.drop(["PX_VOLUME"], axis=1)
euribor.columns = ["interest_rate", "date"]
euribor["interest_rate"] = euribor["interest_rate"].div(100)

plt = year_time_chart(euribor["date"], euribor["interest_rate"], "Euribor", "Interest rate")
plt.savefig('output/Euribor.png', dpi=300, bbox_inches='tight')
plt.show()

#get data
eurstoxx = indexes["SX5E Index"]
eurstoxx = eurstoxx.set_index("date", drop=True)

#plot Stoxx 50
eurstoxx.info()
plt = year_time_chart(eurstoxx.index, eurstoxx["PX_LAST"], "EUROSTOXX50", "Index Points")
plt.savefig('output/EURSTOXX50.png', dpi=100, bbox_inches='tight')
plt.show()

#create log returns
import numpy as np

#calucalte log returns
eurstoxx["log_ret"] = np.log(eurstoxx["PX_LAST"].astype('float32')) - np.log(eurstoxx["PX_LAST"].astype('float32').shift(1))

plt = year_time_chart(eurstoxx.index, eurstoxx["log_ret"], "Log Returns EUROSTOXX50", "Log returns")
plt.savefig('output/EURSTOXX50_logret.png', dpi=300, bbox_inches='tight')
plt.show()


## Volatility Index Calculation
# create option dataset
from VIndex import volatility_index
import pandas as pd
from datetime import datetime

#data cleansing
eurstoxx_options = pd.merge(options["stoxx_call"], options["stoxx_put"], how='left', left_on=['date', 'maturity', 'strike'], right_on = ['date', 'maturity', 'strike'])
eurstoxx_options.columns = ["call_price", "call_volume", "date", "maturity", "strike", "put_price", "put_volume"]

VSTOXXCalc = volatility_index(eurstoxx_options, euribor)
VSTOXXCalc.calculate_index(min_price= 0.5, min_volume= 1, min_num_options= 6)
VSTOXX = VSTOXXCalc.compare_index(indexes["V2X Index"].drop(["PX_VOLUME"], axis=1))
VSTOXXCalc.save_index("output/", "VSTOXX")

#plot available options per date
plt = bar_chart(VSTOXXCalc.index.index, VSTOXXCalc.index["NO_1"] , "VSTOXX available options", "# call/put pairs")
plt.savefig('output/VSTOXX_avail_options.png', dpi=300)
plt.show()

#plot EUROSTOXX50 for selected time frame
plt = time_chart(VSTOXX.index, eurstoxx.loc[VSTOXX.index, ]["PX_LAST"], "EUROSTOXX50", "Index points")
plt.savefig('output/EUROSTOXX50_lastmonths.png', dpi=300, bbox_inches='tight')
plt.show()

#plot constructed VSTOXX
plt = time_chart(VSTOXX.index, VSTOXX["constructed"], "constructed VSTOXX", "Index points")
plt.savefig('output/const_VSTOXX.png', dpi=300, bbox_inches='tight')
plt.show()

#plot real VSTOXX
plt = time_chart(VSTOXX.index, VSTOXX["real"], "real VSTOXX", "Index points")
plt.savefig('output/real_VSTOXX.png', dpi=300, bbox_inches='tight')
plt.show()

#plut differneces real / constructed
plt = bar_chart(VSTOXX.index, VSTOXX["diff"]*100, "Differences \n VSTOXX constructed vs. VSTOXX real", "Difference in %")
plt.savefig('output/VSTOXX_difference_real_const.png', dpi=300, bbox_inches='tight')
plt.show()

