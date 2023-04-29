f = open("example.html", "r")
 
# read entire file into a string
s = read(f, String)  

spl = split(s, "<body>")

print(spl{1})
close(f)