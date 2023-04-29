route("/") do
    html(form)
end

route("/", method = POST) do 
    stockName = payload(:stock, "Placeholder")
    stockRange = payload(:range, "Placeholder")
    stockInterval = payload(:interval, "Placeholder")
    json(yf.get_prices(stockName, range = stockRange, interval = stockInterval))
end

up(async = false)