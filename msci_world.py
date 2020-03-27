try:
    import os
    os.chdir("project")
    print("Changed working directory")
except:
    print("Already in correct working directory")

## Data import and description
# option importer
from project.importer_class import option_importer
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from project.plotter_class import time_chart, day_time_chart, year_time_chart, bar_chart

data_path = 'input/data_europe_compact_v6.xlsm'

option_sheets = ["v2x_call", "v2x_put", "mxwo_call", "mxwo_put", "stoxx_call", "stoxx_put"]
column_names = ["PX_LAST", "PX_VOLUME"]
processing_dict = {'stoxx':{"maturity_dict": False, "maturity": '([0-9][0-9])(\/)([0-9][0-9])(\/)([0-9][0-9])', "strike": '(?!.*(C|P)).*?(?= )'}, 'mxwo':{"maturity_dict": False, "maturity": '([0-9][0-9])(\/)([0-9][0-9])(\/)([0-9][0-9])', "strike": '(?!.*(C|P)).*?(?= )'}, 'v2x':{"maturity_dict": True, "maturity": '[^FVS]', "strike": '(?<=\s)(.*?)(?=\s)'}}
maturity_dict = {"H":"03/17/20", "J":"04/15/20", "K":"05/20/20", "M":"06/17/20","N":"07/22/20","Q":"08/19/20", "U":"09/16/20", "V":"10/21/20"}

opt_importer = option_importer(data_path)
opt_importer.option_import(option_sheets,column_names, processing_dict, maturity_dict, False)
options = opt_importer.clean_data(["PX_LAST", "date"], True)


# index importer
from VIndex import index_importer

index_sheets = ["Index"]

ind_importer = index_importer(data_path)
ind_importer.index_import(index_sheets, False)
indexes = ind_importer.clean_data(["PX_LAST", "date"], True)


#interest rate importer
from project.importer_class import index_importer

index_sheets = ["Rates"]

ind_importer = index_importer('input/data_europe_compact_v6.xlsm')
ind_importer.index_import(index_sheets, False)
interest_rates = ind_importer.clean_data(["PX_LAST", "PX_VOLUME"], True)

libor = interest_rates["US0001M Index"]
libor = libor.drop(["PX_VOLUME"], axis=1)
libor.columns = ["interest_rate", "date"]
libor["interest_rate"] = libor["interest_rate"].div(100)

plt = year_time_chart(libor["date"], libor["interest_rate"], "Libor", "Interest rate")
plt.savefig('output/Libor.png', dpi=300, bbox_inches='tight')
plt.show()


#get data
mxwo = indexes["MXWO Index"]
mxwo = mxwo.set_index("date", drop=True)

#plot MSCI World
mxwo.info()
plt = year_time_chart(mxwo.index, mxwo["PX_LAST"], "MSCI World", "Index Points")
plt.savefig('output/MSCIWorld.png', dpi=300, bbox_inches='tight')
plt.show()


#create log returns
import numpy as np

#calucalte log returns
mxwo["log_ret"] = np.log(mxwo["PX_LAST"].astype('float32')) - np.log(mxwo["PX_LAST"].astype('float32').shift(1))

plt = year_time_chart(mxwo.index, mxwo["log_ret"], "Log Returns MSCI World", "Log returns")
plt.savefig('output/MSCIWorld_logret.png', dpi=300, bbox_inches='tight')
plt.show()


## Volatility Index Calculation
# create option dataset
from project.vindex_class import volatility_index
import pandas as pd
from datetime import datetime

#data cleansing
mxwo_options = pd.merge(options["mxwo_call"], options["mxwo_put"], how='left', left_on=['date', 'maturity', 'strike'], right_on = ['date', 'maturity', 'strike'])
mxwo_options.columns = ["call_price", "call_volume", "date", "maturity", "strike", "put_price", "put_volume"]

VMSCICalc = volatility_index(mxwo_options, libor)
VMSCI = VMSCICalc.calculate_index(min_price= 0.5, min_volume= 0, min_num_options= 2, return_data=True)
VMSCICalc.save_index("output/", "VMSCI")

#plot available options per date
plt = bar_chart(VMSCICalc.index.index, VMSCICalc.index["NO_1"] , "VMSCI available options", "# call/put pairs")
plt.savefig('output/VMSCI_avail_options.png', dpi=300, bbox_inches='tight')
plt.show()

#plot MSCI World for selected time frame
plt = time_chart(VMSCI.index, mxwo.loc[VMSCI.index, ]["PX_LAST"], "MSCI World", "Index points")
plt.savefig('output/MSCIWorld_lastmonths.png', dpi=300, bbox_inches='tight')
plt.show()

#plot constructed VMSCI
plt = time_chart(VMSCI.index, VMSCI["VIndex"], "VMSCI (min number options = 2)", "Index points")
plt.savefig('output/const_VMSCI2.png', dpi=300, bbox_inches='tight')
plt.show()