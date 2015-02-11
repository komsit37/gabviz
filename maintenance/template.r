library(ggplot2)
library(gridExtra)

source("/Users/komsit37/Development/qserver/qserver.R")
h<-open_connection("127.0.0.1",5555)
booking <- execute(h, "select count i by cal from booking")
str(booking)

execute(h, "\\a")
head(booking)
is.data.frame(booking)
ggplot(booking, aes(x=cal, y=price, col=action)) + geom_point()
