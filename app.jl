using YFinance, Genie, Genie.Router, Genie.Requests, Genie.Renderer.Json, Genie.Renderer, Genie.Renderer.Html, Genie.Renderer.Json, PlotlyJS, CSV, DataFrames, HTTP
import YFinance as yf

htm = """<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stonky!</title>
</head>
<body>
    <style>
        body{
            background: rgb(44, 44, 44);
            color: aliceblue;
        }
        h1{
            text-align: center;
            color: aliceblue;
            font-size: 80px;
        }
        form{
            text-align: center;
            margin: auto;
        }

        .searchbar{
            margin: auto;
            text-align: center;
            width: 10%;
            font-size: 16px;
            padding: 20px;
            border: none;
            border-radius: 50px;
            opacity: 0.75;
        }

        .searchbar::placeholder{
            color:gray;
            font-family: 'Roboto', sans-serif;
        }

        .searchbar:focus{
            outline: 2px solid rgb(82, 185, 245);

        }

        select{
            margin-top: 10px;
            margin-bottom: 10px;
            text-align: center;
            font-size: 16px;
            border: none;
            border-radius: 10px;
            opacity: 0.75;
        }

        .submitBtn{
            margin-top: 10px;
            margin-bottom: 10px;
            padding: 10px;
            width: 10%;
            text-align: center;
            font-size: 16px;
            border: none;
            border-radius: 10px;
        }


    </style>

    <h1>Stonky</h1>
    <div class="inp">
        <form action="/" method="POST" enctype="multipart/form-data">
          <input type="text" name="stock" class = "searchbar" value="" placeholder="Enter stock name:" /><br>
          Range: <select name="range">
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
        
          Interval: <select name="interval">
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
        
          <br>
          <input type="submit" class = "submitBtn" value="Submit" />
        </form>
        </div>
</body>
</html>
"""


route("/") do

  html(htm)

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

    savefig(p, "stock_chart.html")

    html(read("stock_chart.html", String))

end

up(async = false)