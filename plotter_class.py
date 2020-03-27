import matplotlib.pyplot as plt
import matplotlib.dates as mdates

def year_time_chart(x, y, title, yaxis):
    fig, ax = plt.subplots()
    fig.set_figwidth(15)
    ax.plot(x, y)
    ax.xaxis.set_major_locator(mdates.YearLocator())
    ax.xaxis.set_major_formatter(mdates.DateFormatter("%Y"))
    ax.set_xlabel("Date")
    ax.set_ylabel(yaxis)
    ax.set_title(title, fontsize=20)
    plt.setp(ax.get_xticklabels(), rotation=0, ha="center")
    plt.grid(which="both")
    return plt

def time_chart(x, y, title, yaxis):
    fig, ax = plt.subplots()
    fig.set_figwidth(15)
    ax.plot(x, y)
    ax.xaxis.set_major_locator(mdates.YearLocator())
    ax.xaxis.set_minor_locator(mdates.MonthLocator())
    ax.xaxis.set_major_formatter(mdates.DateFormatter("\n%Y"))
    ax.xaxis.set_minor_formatter(mdates.DateFormatter("%b"))
    ax.set_xlabel("Date")
    ax.set_ylabel(yaxis)
    ax.set_title(title, fontsize=20)
    plt.setp(ax.get_xticklabels(), rotation=0, ha="center")
    plt.grid(which="both")
    return plt

def day_time_chart(x, y, title, yaxis):
    fig, ax = plt.subplots()
    fig.set_figwidth(15)
    ax.plot(x, y)
    ax.xaxis.set_major_locator(mdates.MonthLocator())
    ax.xaxis.set_minor_locator(mdates.DayLocator())
    ax.xaxis.set_major_formatter(mdates.DateFormatter("\n%b"))
    ax.xaxis.set_minor_formatter(mdates.DateFormatter("%d"))
    ax.set_xlabel("Date")
    ax.set_ylabel(yaxis)
    ax.set_title(title, fontsize=20)
    plt.setp(ax.get_xticklabels(), rotation=0, ha="center")
    plt.grid(which="both")
    return plt

def bar_chart(x,y, title, yaxis):
    fig, ax = plt.subplots()
    fig.set_figwidth(15)
    ax.bar(x, y)
    ax.xaxis.set_major_locator(mdates.YearLocator())
    ax.xaxis.set_minor_locator(mdates.MonthLocator())
    ax.xaxis.set_major_formatter(mdates.DateFormatter("\n%Y"))
    ax.xaxis.set_minor_formatter(mdates.DateFormatter("%b"))
    ax.set_xlabel("Date")
    ax.set_ylabel(yaxis)
    ax.set_title(title, fontsize=20)
    plt.setp(ax.get_xticklabels(), rotation=0, ha="center")
    plt.grid(which="both")
    return plt