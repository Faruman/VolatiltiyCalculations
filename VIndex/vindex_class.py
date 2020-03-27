#import necessary packages
import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import math

#create volatility index class
class volatility_index:
    def __init__(self, options, interest):
        self.options = options
        self.interest = interest
        self.subindices = pd.DataFrame()
        self.index = pd.DataFrame()

    @staticmethod
    def calculate_subindex(data, delta_T, R):

        # reindex dataframe
        data = data.sort_values(by=["strike"], ascending=True)
        data = data.reset_index(drop=True)

        # calculate the price differences betwen put and call
        data['Diff_Put_Call'] = np.abs(data["put_price"] - data["call_price"])

        # differences between the different strikes of the series
        data['delta_K'] = None
        data.iloc[1:-1, data.columns.get_loc('delta_K')] = [(data['strike'][i + 1] - data['strike'][i - 1]) / 2 for i in
                                                            data.index[1:-1]]
        data.iloc[0, data.columns.get_loc('delta_K')] = data['strike'][1] - data['strike'][0]
        data.iloc[-1, data.columns.get_loc('delta_K')] = float(data['strike'][-1:]) - float(data['strike'][-2:-1])

        # find the smallest difference between put and call price
        min_index = data["Diff_Put_Call"].argmin()

        # the forward price of that option
        forward_price = data['strike'][min_index] + R * data["Diff_Put_Call"][min_index]
        K_0 = data['strike'][data['strike'] < forward_price].max()

        # the index of the ATM strike
        K_0_index = data.index[data['strike'] == K_0][0]

        # selects the OTM options
        data['M'] = pd.concat((data["put_price"][0:K_0_index], data["call_price"][K_0_index:]))

        # ATM we take the average of put and call price
        data.iloc[K_0_index, data.columns.get_loc('M')] = (data["put_price"][K_0_index] + data["call_price"][
            K_0_index]) / 2

        # the single OTM values
        data['MFactor'] = (data['delta_K'] / (data['strike']) ** 2) * R * data['M']

        # the forward term
        fterm = 1. / delta_T * (forward_price / K_0 - 1) ** 2

        # summing up
        sigma = 2 / delta_T * np.sum(data['MFactor']) - fterm
        subVSTOXX = 100 * math.sqrt(sigma)

        return subVSTOXX

    def calculate_subindices(self, min_price = 0.5, min_volume = 0, min_num_options = 6, return_data = False):
        self.min_price = min_price
        self.min_volume = min_volume
        self.min_num_options = min_num_options

        #data cleansing
        options = self.options.dropna(subset=["call_price", "put_price"])
        options = options.loc[(self.options["call_price"]>self.min_price)&(self.options["put_price"]>self.min_price)]
        if self.min_volume > 0:
            options = options.loc[(options["call_volume"] >= self.min_volume) & (options["put_volume"] >= self.min_volume)]

        #calculate subindices
        options = options.sort_values(by=["date"], ascending=True)

        #intialize empty dataframe to store subindices
        V = pd.DataFrame(index=sorted(set(options["date"])), columns=["V_1", "M_1", "NO_1", "V_2", "M_2", "NO_2"])

        #loop over dates and maturities
        for current_date, data_group_date in options.groupby("date"):
            data_group_date = data_group_date.sort_values(by=["maturity"], ascending=True)
            is_end = False
            i = 1

            for current_maturity, data_group_mat in data_group_date.groupby("maturity"):
                delta_T = ((current_maturity - current_date).days - 1) / 365
                j = 0
                R = None
                while R is None:
                    try:
                        R = math.exp(self.interest.loc[self.interest["date"] == (current_date - timedelta(days=j)), "interest_rate"] * delta_T)
                    except:
                        j += 1
                        pass

                if (current_date < current_maturity - timedelta(days=1)) and not is_end:
                    if data_group_mat.shape[0] >= self.min_num_options:
                        V.loc[current_date, ["V_1", "M_1", "NO_1"]] = [self.calculate_subindex(data_group_mat, delta_T, R),
                                                                       current_maturity, data_group_mat.shape[0]]
                    else:
                        V.loc[current_date, ["M_1", "NO_1"]] = [current_maturity, data_group_mat.shape[0]]

                    if (i < len(set(data_group_date["maturity"]))):
                        is_end = True
                        i += 1
                        continue

                elif (is_end):
                    if data_group_mat.shape[0] >= self.min_num_options:
                        V.loc[current_date, ["V_2", "M_2", "NO_2"]] = [self.calculate_subindex(data_group_mat, delta_T, R),
                                                                       current_maturity, data_group_mat.shape[0]]
                    else:
                        V.loc[current_date, ["M_2", "NO_2"]] = [current_maturity, data_group_mat.shape[0]]
                    break
                else:
                    pass
        self.subindices = V

        if return_data:
            return self.subindices
        else:
            pass

    def calculate_mainindex(self, return_data = False):
        if not self.subindices.empty:
            # drop function
            V = self.subindices.loc[
                (pd.to_datetime(self.subindices["M_1"]) - self.subindices.index <= timedelta(days=36))
                & ~(pd.isna(self.subindices["NO_1"]) | pd.isna(self.subindices["NO_2"]))]

            # calculate VMSCI from sub indices
            V.loc[:, "N_1"] = pd.to_datetime(V["M_1"]) - V.index
            V.loc[:, "N_2"] = pd.to_datetime(V["M_2"]) - V.index
            N_month = timedelta(days=30)
            N_year = timedelta(days=365)
            V.loc[:, "T_1"] = V["N_1"] / N_year
            V.loc[:, "T_2"] = V["N_2"] / N_year
            V.loc[:, "VIndex"] = ((V["T_1"] * V["V_1"]**2 * ((V["N_2"]- N_month) / (V["N_2"] - V["N_1"])) + V["T_2"] * V["V_2"]**2 *
                                   ((N_month - V["N_1"]) / (V["N_2"] - V["N_1"]))).div(N_month/N_year)).pow(0.5)

            V = V.drop(["T_1", "T_2"], axis=1)
            self.index = V

            if return_data:
                return V
            else:
                pass
        else:
            print("Please run calculate_subindices first")

    def calculate_index(self, min_price=0.5, min_volume=0, min_num_options=6, return_data=True):
        self.calculate_subindices(min_price=min_price, min_volume=min_volume, min_num_options=min_num_options, return_data=False)
        if return_data:
            return self.calculate_mainindex(return_data = True)
        else:
            self.calculate_mainindex(return_data=False)

    def compare_index(self, index2):
        if not self.index.empty:
            index = pd.merge(self.index["VIndex"], index2, how='left', left_index=True, right_on=['date'])
            index = index.set_index(['date'], drop=True)
            index.columns = ["constructed", "real"]
            index["diff"] = ((index["constructed"] - index["real"]) / index["constructed"])

            return index
        else:
            print("Please run calculate_index first")

    def save_index(self, filepath, indexname):
        if not self.index.empty:
            self.index.to_excel(filepath + indexname + "_" + str(self.min_volume) + "_" + str(self.min_price) + "_" + str(self.min_num_options) + ".xlsx")
        else:
            print("Please run calculate_index first")
