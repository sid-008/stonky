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

using YFinance, Genie, Genie.Router, Genie.Requests, Genie.Renderer.Json, Genie.Renderer, Genie.Renderer.Html, Genie.Renderer.Json, PlotlyJS, CSV, DataFrames, HTTP, Images
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

    savefig(p, "example.html")

#     html("""<div>
#     <script src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-AMS-MML_SVG"></script>
#     <script type="text/javascript">
# window.PlotlyConfig = {MathJaxConfig: 'local'};
# </script>
# <script src="https://cdn.plot.ly/plotly-2.3.0.min.js"></script>

#     <div
#         id=85bed594-7fff-42b3-aa33-60f54ef4b416
#         class="plotly-graph-div"
#         style="height:100%; width:100%;">
#     </div>
#     <script type="text/javascript">
        
#         window.PLOTLYENV = window.PLOTLYENV || {}
        
#         if (document.getElementById('85bed594-7fff-42b3-aa33-60f54ef4b416')) {
#     Plotly.newPlot(
#         '85bed594-7fff-42b3-aa33-60f54ef4b416',
#         [{"x":["2023-04-28T13:30:00","2023-04-28T13:45:00","2023-04-28T14:00:00","2023-04-28T14:15:00","2023-04-28T14:30:00","2023-04-28T14:45:00","2023-04-28T15:00:00","2023-04-28T15:15:00","2023-04-28T15:30:00","2023-04-28T15:45:00","2023-04-28T16:00:00","2023-04-28T16:15:00","2023-04-28T16:30:00","2023-04-28T16:45:00","2023-04-28T17:00:00","2023-04-28T17:15:00","2023-04-28T17:30:00","2023-04-28T17:45:00","2023-04-28T18:00:00","2023-04-28T18:15:00","2023-04-28T18:30:00","2023-04-28T18:45:00","2023-04-28T19:00:00","2023-04-28T19:15:00","2023-04-28T19:30:00","2023-04-28T19:45:00","2023-04-28T20:00:00"],"high":[169.0399932861328,168.61000061035156,169.3800048828125,169.85000610351562,169.85000610351562,169.4600067138672,168.7949981689453,168.38999938964844,168.5789031982422,168.8300018310547,168.97000122070312,168.88999938964844,168.75999450683594,168.85000610351562,168.88999938964844,168.83999633789062,168.76229858398438,168.42999267578125,168.52000427246094,168.4250030517578,168.41000366210938,168.59170532226562,168.86500549316406,169.02999877929688,169.14999389648438,169.7100067138672,169.67999267578125],"type":"candlestick","open":[168.49000549316406,167.99000549316406,168.50999450683594,169.35000610351562,169.8300018310547,169.1999969482422,168.77999877929688,168.1699981689453,168.3000030517578,168.55999755859375,168.77000427246094,168.8690948486328,168.66200256347656,168.5850067138672,168.8300018310547,168.77999877929688,168.75999450683594,168.4199981689453,168.34500122070312,168.3300018310547,168.2949981689453,168.25999450683594,168.57000732421875,168.82000732421875,168.82000732421875,169.1199951171875,169.67999267578125],"low":[167.88009643554688,167.91000366210938,168.22999572753906,169.3300018310547,169.17999267578125,168.57000732421875,168.02999877929688,168.09500122070312,168.1999969482422,168.50999450683594,168.69000244140625,168.36000061035156,168.3300018310547,168.4600067138672,168.50999450683594,168.58999633789062,168.25,168.14999389648438,168.24000549316406,168.22000122070312,168.1199951171875,168.19500732421875,168.5218963623047,168.76690673828125,168.7899932861328,168.86000061035156,169.67999267578125],"close":[167.98240661621094,168.50999450683594,169.35789489746094,169.8385009765625,169.1999969482422,168.77999877929688,168.1728057861328,168.2899932861328,168.55999755859375,168.75999450683594,168.85499572753906,168.6699981689453,168.58999633789062,168.83529663085938,168.7899932861328,168.75999450683594,168.42999267578125,168.35000610351562,168.33050537109375,168.2949981689453,168.26499938964844,168.57009887695312,168.82009887695312,168.81500244140625,169.1300048828125,169.69000244140625,169.67999267578125]}],
#         {"xaxis":{"rangeslider":{"visible":false}},"template":{"layout":{"coloraxis":{"colorbar":{"ticks":"","outlinewidth":0}},"xaxis":{"gridcolor":"white","zerolinewidth":2,"title":{"standoff":15},"ticks":"","zerolinecolor":"white","automargin":true,"linecolor":"white"},"hovermode":"closest","paper_bgcolor":"white","geo":{"showlakes":true,"showland":true,"landcolor":"#E5ECF6","bgcolor":"white","subunitcolor":"white","lakecolor":"white"},"colorscale":{"sequential":[[0.0,"#0d0887"],[0.1111111111111111,"#46039f"],[0.2222222222222222,"#7201a8"],[0.3333333333333333,"#9c179e"],[0.4444444444444444,"#bd3786"],[0.5555555555555556,"#d8576b"],[0.6666666666666666,"#ed7953"],[0.7777777777777778,"#fb9f3a"],[0.8888888888888888,"#fdca26"],[1.0,"#f0f921"]],"diverging":[[0,"#8e0152"],[0.1,"#c51b7d"],[0.2,"#de77ae"],[0.3,"#f1b6da"],[0.4,"#fde0ef"],[0.5,"#f7f7f7"],[0.6,"#e6f5d0"],[0.7,"#b8e186"],[0.8,"#7fbc41"],[0.9,"#4d9221"],[1,"#276419"]],"sequentialminus":[[0.0,"#0d0887"],[0.1111111111111111,"#46039f"],[0.2222222222222222,"#7201a8"],[0.3333333333333333,"#9c179e"],[0.4444444444444444,"#bd3786"],[0.5555555555555556,"#d8576b"],[0.6666666666666666,"#ed7953"],[0.7777777777777778,"#fb9f3a"],[0.8888888888888888,"#fdca26"],[1.0,"#f0f921"]]},"yaxis":{"gridcolor":"white","zerolinewidth":2,"title":{"standoff":15},"ticks":"","zerolinecolor":"white","automargin":true,"linecolor":"white"},"shapedefaults":{"line":{"color":"#2a3f5f"}},"hoverlabel":{"align":"left"},"mapbox":{"style":"light"},"polar":{"angularaxis":{"gridcolor":"white","ticks":"","linecolor":"white"},"bgcolor":"#E5ECF6","radialaxis":{"gridcolor":"white","ticks":"","linecolor":"white"}},"autotypenumbers":"strict","font":{"color":"#2a3f5f"},"ternary":{"baxis":{"gridcolor":"white","ticks":"","linecolor":"white"},"bgcolor":"#E5ECF6","caxis":{"gridcolor":"white","ticks":"","linecolor":"white"},"aaxis":{"gridcolor":"white","ticks":"","linecolor":"white"}},"annotationdefaults":{"arrowhead":0,"arrowwidth":1,"arrowcolor":"#2a3f5f"},"plot_bgcolor":"#E5ECF6","title":{"x":0.05},"scene":{"xaxis":{"gridcolor":"white","gridwidth":2,"backgroundcolor":"#E5ECF6","ticks":"","showbackground":true,"zerolinecolor":"white","linecolor":"white"},"zaxis":{"gridcolor":"white","gridwidth":2,"backgroundcolor":"#E5ECF6","ticks":"","showbackground":true,"zerolinecolor":"white","linecolor":"white"},"yaxis":{"gridcolor":"white","gridwidth":2,"backgroundcolor":"#E5ECF6","ticks":"","showbackground":true,"zerolinecolor":"white","linecolor":"white"}},"colorway":["#636efa","#EF553B","#00cc96","#ab63fa","#FFA15A","#19d3f3","#FF6692","#B6E880","#FF97FF","#FECB52"]},"data":{"barpolar":[{"type":"barpolar","marker":{"line":{"color":"#E5ECF6","width":0.5}}}],"carpet":[{"aaxis":{"gridcolor":"white","endlinecolor":"#2a3f5f","minorgridcolor":"white","startlinecolor":"#2a3f5f","linecolor":"white"},"type":"carpet","baxis":{"gridcolor":"white","endlinecolor":"#2a3f5f","minorgridcolor":"white","startlinecolor":"#2a3f5f","linecolor":"white"}}],"scatterpolar":[{"type":"scatterpolar","marker":{"colorbar":{"ticks":"","outlinewidth":0}}}],"parcoords":[{"line":{"colorbar":{"ticks":"","outlinewidth":0}},"type":"parcoords"}],"scatter":[{"type":"scatter","marker":{"colorbar":{"ticks":"","outlinewidth":0}}}],"histogram2dcontour":[{"colorbar":{"ticks":"","outlinewidth":0},"type":"histogram2dcontour","colorscale":[[0.0,"#0d0887"],[0.1111111111111111,"#46039f"],[0.2222222222222222,"#7201a8"],[0.3333333333333333,"#9c179e"],[0.4444444444444444,"#bd3786"],[0.5555555555555556,"#d8576b"],[0.6666666666666666,"#ed7953"],[0.7777777777777778,"#fb9f3a"],[0.8888888888888888,"#fdca26"],[1.0,"#f0f921"]]}],"contour":[{"colorbar":{"ticks":"","outlinewidth":0},"type":"contour","colorscale":[[0.0,"#0d0887"],[0.1111111111111111,"#46039f"],[0.2222222222222222,"#7201a8"],[0.3333333333333333,"#9c179e"],[0.4444444444444444,"#bd3786"],[0.5555555555555556,"#d8576b"],[0.6666666666666666,"#ed7953"],[0.7777777777777778,"#fb9f3a"],[0.8888888888888888,"#fdca26"],[1.0,"#f0f921"]]}],"scattercarpet":[{"type":"scattercarpet","marker":{"colorbar":{"ticks":"","outlinewidth":0}}}],"mesh3d":[{"colorbar":{"ticks":"","outlinewidth":0},"type":"mesh3d"}],"surface":[{"colorbar":{"ticks":"","outlinewidth":0},"type":"surface","colorscale":[[0.0,"#0d0887"],[0.1111111111111111,"#46039f"],[0.2222222222222222,"#7201a8"],[0.3333333333333333,"#9c179e"],[0.4444444444444444,"#bd3786"],[0.5555555555555556,"#d8576b"],[0.6666666666666666,"#ed7953"],[0.7777777777777778,"#fb9f3a"],[0.8888888888888888,"#fdca26"],[1.0,"#f0f921"]]}],"scattermapbox":[{"type":"scattermapbox","marker":{"colorbar":{"ticks":"","outlinewidth":0}}}],"scattergeo":[{"type":"scattergeo","marker":{"colorbar":{"ticks":"","outlinewidth":0}}}],"histogram":[{"type":"histogram","marker":{"colorbar":{"ticks":"","outlinewidth":0}}}],"pie":[{"type":"pie","automargin":true}],"choropleth":[{"colorbar":{"ticks":"","outlinewidth":0},"type":"choropleth"}],"heatmapgl":[{"colorbar":{"ticks":"","outlinewidth":0},"type":"heatmapgl","colorscale":[[0.0,"#0d0887"],[0.1111111111111111,"#46039f"],[0.2222222222222222,"#7201a8"],[0.3333333333333333,"#9c179e"],[0.4444444444444444,"#bd3786"],[0.5555555555555556,"#d8576b"],[0.6666666666666666,"#ed7953"],[0.7777777777777778,"#fb9f3a"],[0.8888888888888888,"#fdca26"],[1.0,"#f0f921"]]}],"bar":[{"type":"bar","error_y":{"color":"#2a3f5f"},"error_x":{"color":"#2a3f5f"},"marker":{"line":{"color":"#E5ECF6","width":0.5}}}],"heatmap":[{"colorbar":{"ticks":"","outlinewidth":0},"type":"heatmap","colorscale":[[0.0,"#0d0887"],[0.1111111111111111,"#46039f"],[0.2222222222222222,"#7201a8"],[0.3333333333333333,"#9c179e"],[0.4444444444444444,"#bd3786"],[0.5555555555555556,"#d8576b"],[0.6666666666666666,"#ed7953"],[0.7777777777777778,"#fb9f3a"],[0.8888888888888888,"#fdca26"],[1.0,"#f0f921"]]}],"contourcarpet":[{"colorbar":{"ticks":"","outlinewidth":0},"type":"contourcarpet"}],"table":[{"type":"table","header":{"line":{"color":"white"},"fill":{"color":"#C8D4E3"}},"cells":{"line":{"color":"white"},"fill":{"color":"#EBF0F8"}}}],"scatter3d":[{"line":{"colorbar":{"ticks":"","outlinewidth":0}},"type":"scatter3d","marker":{"colorbar":{"ticks":"","outlinewidth":0}}}],"scattergl":[{"type":"scattergl","marker":{"colorbar":{"ticks":"","outlinewidth":0}}}],"histogram2d":[{"colorbar":{"ticks":"","outlinewidth":0},"type":"histogram2d","colorscale":[[0.0,"#0d0887"],[0.1111111111111111,"#46039f"],[0.2222222222222222,"#7201a8"],[0.3333333333333333,"#9c179e"],[0.4444444444444444,"#bd3786"],[0.5555555555555556,"#d8576b"],[0.6666666666666666,"#ed7953"],[0.7777777777777778,"#fb9f3a"],[0.8888888888888888,"#fdca26"],[1.0,"#f0f921"]]}],"scatterternary":[{"type":"scatterternary","marker":{"colorbar":{"ticks":"","outlinewidth":0}}}],"scatterpolargl":[{"type":"scatterpolargl","marker":{"colorbar":{"ticks":"","outlinewidth":0}}}]}},"margin":{"l":50,"b":50,"r":50,"t":60}},
#         {"editable":false,"responsive":true,"staticPlot":false,"scrollZoom":true},
#     )
# }

        
#     </script>
# </div>""")
  html(read("example.html", String))

    # HTML(price_data)
    # html("""<img src='/test.png' />""")

    # savefig(p, "/test.png")
    # image_path = """<img src="/test.png"/>"""
    # HTML(image_path)

end

up(async = false)