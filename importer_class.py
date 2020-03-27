#import necessary packages
import pandas as pd
import re

class option_importer:
    def __init__(self, path):
        self.path = path
        self.rel_sheets = []
        self.processing_dict = {}
        self.maturity_dict = {}
        self.data = {}

    def option_import(self, relevant_sheets, column_names, processing_dict, maturity_dict, return_df):
        self.rel_sheets = relevant_sheets
        self.processing_dict = processing_dict
        self.maturity_dict = maturity_dict
        x = pd.DataFrame(columns=column_names.extend(["date", "maturity", "strike"]))
        self.data = dict(zip(relevant_sheets, [x] * len(relevant_sheets)))

        # create iterator object over sheets
        xls = pd.ExcelFile(self.path)

        # fill up the data
        for sheet in xls.sheet_names:
            sheet_regex = re.search('[^_]*_[^_]*', sheet)
            if not sheet_regex:
                continue
            if sheet_regex.group(0) in set(self.data.keys()):
                df = pd.read_excel(xls, sheet, header=None, skiprows=3)
                try:
                    dates = df.iloc[3:, 0].dt.strftime('%m/%d/%Y').reset_index(drop=True)
                except:
                    dates = df.iloc[3:, 0].reset_index(drop=True)
                for i in range(1, df.shape[1], 2):
                    name = df.iloc[:, i:(i + 2)].iloc[0, 0]
                    df_prcsd = df.iloc[2:, i:(i + 2)]
                    df_prcsd = df_prcsd.rename(columns=df_prcsd.iloc[0]).drop(df_prcsd.index[0])
                    df_prcsd = df_prcsd.reset_index(drop=True)
                    for column in df_prcsd.columns:
                        try:
                            df_prcsd[column] = df_prcsd[column].astype('float32')
                        except:
                            pass
                    if len(df_prcsd) > 1 and df_prcsd.iloc[0,0] != "#N/A Invalid Security":
                        maturity = re.search(
                            self.processing_dict[re.search('[^_]*', sheet_regex.group(0)).group(0)]["maturity"], name).group(
                            0)
                        if self.processing_dict[re.search('[^_]*', sheet_regex.group(0)).group(0)]["maturity_dict"]:
                            maturity = self.maturity_dict[maturity]
                        df_prcsd["date"] = pd.to_datetime(dates)
                        df_prcsd["maturity"] =  pd.to_datetime(pd.Series([maturity] * len(df_prcsd)))
                        try:
                            df_prcsd["strike"] = pd.Series([re.search(
                                self.processing_dict[re.search('[^_]*', sheet_regex.group(0)).group(0)]["strike"], name).group(
                                0)] * len(df_prcsd)).astype('float32')
                        except:
                            print("Exception occured")
                        self.data[sheet_regex.group(0)] = self.data[sheet_regex.group(0)].append(df_prcsd)
                        self.data[sheet_regex.group(0)] = self.data[sheet_regex.group(0)].reset_index(
                            drop=True)
                    else:
                        continue
        if return_df:
            return self.data

    def clean_data(self, columns_not_nan, return_df):
        self.columns_not_nan = columns_not_nan
        delete_sheets = []
        if len(self.data.keys()) > 0:
            for sheet in self.data.keys():
                if set(["date", "maturity"]).issubset(set(self.data[sheet].columns)):
                    self.data[sheet] = self.data[sheet].loc[self.data[sheet]["date"] <= self.data[sheet]["maturity"]]
                if set(self.columns_not_nan).issubset(set(self.data[sheet].columns)):
                    self.data[sheet] = self.data[sheet].dropna(subset=self.columns_not_nan)
                else:
                    delete_sheets.append(sheet)

            for sheet in delete_sheets:
                del self.data[sheet]

            if return_df:
                return self.data
        else:
            print("please load options first")



class index_importer:
    def __init__(self, path):
        self.path = path
        self.rel_sheets = []
        self.data = {}

    def index_import(self, relevant_sheets, return_df):
        self.rel_sheets = relevant_sheets

        # fill up the data
        xls = pd.ExcelFile(self.path)

        for sheet in self.rel_sheets:
            df = pd.read_excel(xls, sheet, header=None, skiprows=3)

            try:
                dates = df.iloc[3:, 0].dt.strftime('%m/%d/%Y').reset_index(drop=True)
            except:
                dates = df.iloc[3:, 0].reset_index(drop=True)

            for i in range(1, df.shape[1], 2):
                name = df.iloc[:, i:(i + 2)].iloc[0, 0]
                df_prcsd = df.iloc[2:, i:(i + 2)]
                df_prcsd = df_prcsd.rename(columns=df_prcsd.iloc[0]).drop(df_prcsd.index[0])
                df_prcsd = df_prcsd.reset_index(drop=True)
                df_prcsd["date"] = pd.to_datetime(dates)

                while name in set(self.data.keys()):
                    if name[-1:] in {"1", "2", "3", "4", "5", "6", "7", "8", "9"}:
                        name = name[:-1] + str(int(name[-1:]) + 1)
                    else:
                        name = name + str(1)

                self.data[name] = df_prcsd

        if return_df:
            return self.data

    def clean_data(self, columns_not_nan, return_df):
        self.columns_not_nan = columns_not_nan
        delete_sheets = []
        if len(self.data.keys()) > 0:
            for sheet in self.data.keys():
                if set(self.columns_not_nan).issubset(set(self.data[sheet].columns)):
                    self.data[sheet] = self.data[sheet].dropna(subset=self.columns_not_nan, how='all')
                else:
                    delete_sheets.append(sheet)

            for sheet in delete_sheets:
                del self.data[sheet]

            if return_df:
                return self.data
        else:
            print("please load options first")




