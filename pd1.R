###################################################################
# Ćwiczenia

# Ćwiczenie 1
# zaimportuj dane z plików CSV dla wybranych innych spółek

url <- "http://stooq.com/q/d/l/?s=kgh&i=d"
kghm <- read.csv(url, 
                 header = TRUE,
                 sep = ",",
                 dec = ".")

url2 <- "http://stooq.com/q/d/l/?s=pko&i=d"
pko <-  read.csv(url2, 
                 header = TRUE,
                 sep = ",",
                 dec = ".")

# Ćwiczenie 2
# utwórz obiekt typu data.frame z datą, ceną zamknięcia i wolumenem

#zmiana formatu daty
kghm$Date <- as.Date(kghm$Date)
kghm_dcv <- data.frame(kghm$Date, kghm$Close, kghm$Volume)
#poprawa nazw kolumn
colnames(kghm_dcv) <- c("Date", "Close", "Volume")

# Ćwiczenie 3
# przedstaw histogram cen zamknięcia

hist(kghm_dcv$Close, 
     main = "Histogram cen zamknięcia", 
     col = "light blue", 
     xlab = "ceny", ylab = "częstość",
     breaks = seq(0, 180, 20))


# Ćwiczenie 4
# przedstaw wykres rozrzutu ceny zamknięcia vw. wolumen

library(ggplot2)
qplot(data = kghm_dcv, 
      x = Close,
      y = Volume,
      main = paste("ceny zamknięcie vs. wolumen\n", 
                   "od", kghm_dcv$Date[1], "do", kghm_dcv$Date[length(kghm_dcv$Date)])
      ) + geom_smooth(method = "lm", formula = y ~ x, se = T )


# Ćwiczenie 5
# dodaj do zbioru nową zmienną max_min
# która będzie relacją cen maksymalnej i minimalnej w ciągu dnia
# oraz zmienną p_diff = (close-open)/open


kghm_dcv$max_min <- kghm$High / kghm$Low
kghm_dcv$p_diff <- (kghm$Close - kghm$Open) / kghm$Open


# Ćwiczenie 6
# dla których obserwacji procentowe dzienne zmiany cen były większe
# (co do modułu)# niż 3.5%?

kghm_dcv.changes <- kghm_dcv[abs(kghm_dcv$p_diff) >= 0.035, ]

# Ćwiczenie 7
# przedstawić statystyki opisowa dla zmiennej  p_diff

#średnia
mean(kghm_dcv$p_diff)
#min
min(kghm_dcv$p_diff)
#max
max(kghm_dcv$p_diff)
#median
median(kghm_dcv$p_diff)
#variance and standard deviation
var(kghm_dcv$p_diff); sd(kghm_dcv$p_diff); 


# Ćwiczenie 8
# Przeprowadzić podobną analizę zależności między zwrotami WIG20
# a zwrotami wybranej spółki i opublikować na RPubs.com

# dzienne stopy zwrotu KGHM
library(xts)
kghm_dcv$rkghm <- diff.xts(log(kghm_dcv$Close))


#read WIG20

url <- "http://stooq.com/q/d/l/?s=wig20&i=d"
# import pliku CSV
WIG20 <- read.csv(url, # nazwa pliku
                  header = TRUE,    # czy obserwacje w pierwszym wierszu?
                  sep = ",", 	       # separator kolumn
                  dec = ".")	       # separator dziesiętny
WIG20$Date <- as.Date(WIG20$Date)

#dzienne stopy zwrotu wig20
WIG20$r <- diff.xts(log(WIG20$Close))

#mergowanie KGHM i WIG20 do obiektu data.frame
kghm.wig20 <- merge(WIG20[, c("Date", "r")],
                      kghm_dcv[, c("Date", "rkghm")],
                      by = "Date")

#ucinanie obserwacji
kghm.wig20 <- kghm.wig20[kghm.wig20$Date >= "2014-01-01", ]

# wykres rozrzutu
qplot(data = kghm.wig20,
      x = r,
      y = rkghm,
      xlab = "zwroty WIG20",
      ylab = "zwroty KGHM",
      main = paste("zwroty KGHM vs. zwroty WIG20\n",
                   "od",
                   kghm.wig20$Date[1],
                   "do",
                   kghm.wig20$Date[length(kghm.wig20$Date)]
      )
) +  geom_smooth(method = "lm", formula = y ~ x, se = T)

# regresja liniowa
kghm.reg <- lm(formula = r ~ rkghm,
                 data = kghm.wig20)
str(kghm.reg)
summary(kghm.reg)

# wykres reszt w czasie
plot(kghm.reg$residuals, type = 'l')

# histogram reszt
hist(kghm.reg$residuals)

# za pomocą ggplot2
ggplot(kghm.wig20, aes(x = rkghm)) +
  geom_histogram(aes( y = ..density..),      # histogram z gestoscią zamiast liczebnością na osi y
                 binwidth = .005,
                 colour = "blue",
                 fill = "white") +
  geom_density(alpha = .2, fill = "#FF6666")

# porównanie gęstości zwrotów
library(reshape)
molten.data <- melt(kghm.wig20,
                    id = c("Date"),
                    measured = c("r", "rkghm"))
ggplot(molten.data,
       aes(x = value, fill = variable)) +
  geom_density(alpha = .3) +
  xlab ("") + ylab("gęstość") +
  ggtitle("gęstości zwrotów WIG20 i KGHM")



