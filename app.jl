# using PyCall, Genie, JSON
# run(`$(PyCall.python) -m pip install yfinance`)
# yf = pyimport("yfinance")


# route("/") do 
#     println("Welcome")
# end

# route("/msft") do
#     msft = yf.Ticker("MSFT")
#     info = msft.info
#     println(info)
# end

# up(async = false)

using YFinance, Genie, Genie.Router, Genie.Requests, Genie.Renderer.Json
using Genie.Renderer, Genie.Renderer.Html, Genie.Renderer.Json
using PlotlyJS, CSV, DataFrames, HTTP

import YFinance as yf

form = """
<form action="/" method="POST" enctype="multipart/form-data">
  <input type="text" name="stock" value="" placeholder="Stock?" />
  <select name="range">
    <option selected="selected" value="1d">1d</option>
    <option value="5d">5d</option>
    <option value="1mo">1mo</option>
    <option value="3mo">3mo</option>
    <option value="6mo">6mo</option>
    <option value="1y">1y</option>
    <option value="2y">2y</option>
    <option value="5y">5y</option>
    <option value="10y">10y</option>
    <option value="ytd">YTD</option>
    <option value="max">MAX</option>
  </select>

  <select name="interval">
    <option value="1m">1m</option> 
    <option value="2m">2m</option>
    <option value="5m">5m</option>
    <option selected="selected" value="15m">15m</option>
    <option value="30m">30m</option>
    <option value="60m">60m</option>
    <option value="90m">90m</option>
    <option value="1h">1h</option>
    <option value="1d">1d</option>
    <option value="5d">5d</option>
    <option value="1wk">1 week</option>
    <option value="1mo">1 month</option>
    <option value="3mo">3 months</option>

  </select>


  <input type="submit" value="Submit" />
</form>
"""





route("/") do
    html(form)
end

route("/", method = POST) do 
    stockName = payload(:stock, "Placeholder")
    stockRange = payload(:range, "Placeholder")
    stockInterval = payload(:interval, "Placeholder")
    price_data= yf.get_prices(stockName, range = stockRange, interval = stockInterval)
    
    df = DataFrame(price_data)

    p = plot(candlestick(
        x=df[:, "timestamp"],
        open=df[:, "open"],
        high=df[:, "high"],
        low=df[:, "low"],
        close=df[:, "close"]
        ),
    Layout(xaxis_rangeslider_visible=false)
    )

end

up(async = false)