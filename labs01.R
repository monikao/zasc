###########################################################################
# Zaawansowana analiza szeregów czasowych                                 #
# semestr letni 2015                                                      #
# dr Aneta Dzik-Walczak, dr Paweł Sakowski                                #
# Uniwersytet Warszawski, Wydział Nauk Ekonomicznych                      #
###########################################################################

###########################################################################
# 1. Wprowadzenie do języka R                                             #
###########################################################################

# proste obliczenia
2 * 3

# jeśli nie zakończymy polecenia znak zachęty > zmienia się na +
5 + 6 + 3 + 6 + 4 + 2 + 4 + 8 +
3 + 2 + 7

# możemy grupować kilka poleceń w jednej linii oddzielając je średnikiem
2 + 3; 5 * 7; 3 - 7

# oblicz pole koła dla danego promienia
r <- 24 	# operator przypisania
pi
pi * r ^ 2

# funkcja logarytmiczna
log(67/8.4)

# podstawę inną niż e wprowadzamy jako kolejny argument:
log(16, 4)

# funckcja c() służy do konstrukcji wektorów
id <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
id

# calculation can be done on a whole vector
pi * id

# Dostęp do elementów wektora uzyskujemy za pomocą nawiasów kwadratowych.
# Wektor ma jeden wymiar, więc odnosimy się tylko do jednej liczby.
# Trzeci element wektora id:
id[3]

# Dwukropek generuje zakres wartości (serię)
id[1:3]
3:7

# możliwe także ujemne wartości wektora indeksu (deselecting), nie bierze tych wartości do wektora
id[-1:-3]

# lub
id[-c(1:3)]

# lets enter another vector using an assignment
age <- c(23, 43, 34, 54, 36, 49, 65, 29, 45, 51)
age

# operacje macierzowe: %+%, %*%
# funkcja cbind() łączy wektory "po kolumnach"
matrix <- cbind(id, age)
matrix

# sprawdźmy klasę
class(matrix)

# i strukturę obiektu matrix
str(matrix)

# do analiz statystycznych zwykle potrzebujemy jednak obketu typu "data.frame"

# załóżmy, że dysponujemy danymi dotyczącycmi kilku osób:
sex = c("female", "male", "male", "female", "female",
        "male", "male", "male", "female", "female")
height <- c(167, 176, 183, 165, 181,
            187, 172, 171, 184, 155)
weight <- c(60, 84, 80, 55, 50,
            82, 81, 85, 61, 82)

# statystyki opisowe
mean(id)
mean(age)
mean(height)
mean(weight)
mean(sex)

# jaki problem z wektorem sex?

# tablica częstości
table(sex)

# inne statystyki
min(age); max(age); median(age); var(age); sd(age); sqrt(var(age));
rank(age); sum(age); length(age); round(age);

# kwantyle
quantile(age)

# kwantyle inne niż dymyślne
quantile(age, c(.2, .4, .6, .8))		#kwintyle

# statystyki 'skumulowane'
cummax(age)
cummin(age)
cumsum(age)


# utwórzmy obiekt typu data.frame
# wektory muszą być tej samej długości!
data <- data.frame(id, age, sex, height, weight)
data
class(data)
str(data)

# dostęp do zmiennych za pomocą operatora $
data$age

# lub
data[, 2]

# lub
data[, "age"]

# statystyki opisowe
summary(data)

# nowy wektor
bmi <- weight/(height/100)^2

# nowa zmienna
data$bmi <- data$weight/(data$height/100)^2

# funkcja zaokrąglająca
data$bmi <- round(data$bmi, 2)

# wektor nazw zmiennych w zbiorze danych
names(data)

# usuwanie zmiennych ze zbioru danych
data.id.bmi <- data[, c(1, 6)] # zatrzymujemy tylko kolumny 1 i 6
data.id.bmi

# uswamy age
data.no.age = data[, -2]
data.no.age

# wyświetlamy obserwacje od 1 do 5
data[1:5, ]

# tylko obserwacje 1, 3i 7
data[c(1, 3, 7), ]

# wybieramy obserwacje, które spełniają pewne kryteria
data.young <-data[data$age <= 30, ]
data.young

# inny przykład
data[data$age == 30, ]

# jeszcze inny
data.male <-data[data$sex == "male", ]
data.male

# prosty histogram
hist(data$bmi)

# inne opcje
seq(10, 40, 2)
hist(data$bmi,
	main = "Histogram of variable BMI",
	col  = "light blue",
	breaks = seq(10, 40, 2))


# prosty boxplot
boxplot(data$bmi)

# prosty wykres rozrzutu
plot(data$height,
     data$weight,
     main = "Scatterplot for height and weight")


# wektor ze wszystkimi obiektami w pamięci
ls()

# usuwamy niepotrzebne obiekty
rm(age, bmi)

# usuwamy wszystki obiekty
# rm(list = ls())

# biblioteki (pakiety)
# instalacja pakietu
install.packages("zoo")

# ładowanie pakietu do pamięci
library(zoo)

# sprawdźmy, które są zaisntalowane na komputerze
library()

# dokumentacja dla danego pakietu
library(help = "zoo")
# albo
help(package = "zoo")

# dokumentacja dla danej funkcji
?quantile
help(quantile)
help.search("quantile")


#####################################################
# importowanie danych z innych źródeł

# sprawdzenie katalogu roboczego
getwd()

# ustawiamy katalog roboczy
setwd("...")

# Uwaga!
# Usilnie polecam organizowanie pracy w projekty
# i korzystanie ze ścieżek względnych!

# dane w natywnych formatch popularnych pakietów
# (CSV, Minitab, S, SAS, SPSS, Stata, Systat, dBase)
# można importować funkcjami z pakietu foreign
library(foreign)


url <- "http://stooq.com/q/d/l/?s=wig20&i=d"
# import pliku CSV
WIG20 <- read.csv(url, # nazwa pliku
                  header = TRUE,  	# czy obserwacje w pierwszym wierszu?
                  sep = ",", 	       # separator kolumn
                  dec = ".")	       # separator dziesiętny

# można też skorzystać z wartości domyślnych
WIG20 <- read.csv(url)


# obejrzymy to co zaimportowaliśmy
str(WIG20)
WIG20
head(WIG20
tail(WIG20)

# data we właściwym formacie
WIG20$Date <- as.Date(WIG20$Date)

# wykres w czasie
plot(WIG20$Date, WIG20$Close, type = 'l')

# dzienne stopy zwrotu
library(xts)
WIG20$r <- diff.xts(log(WIG20$Close))
plot(WIG20$Date, WIG20$r,
     type = "l",
     col = "red",
     main = "logarytmiczne zwroty WIG20",
     xlab = "data",
     ylab = 'zwroty')

# import notowań asseco
url <- "http://stooq.com/q/d/l/?s=acp&i=d"

# import pliku CSV
asseco <- read.csv(url, # nazwa pliku
                  header = TRUE,      # czy obserwacje w pierwszym wierszu?
                  sep = ",", 	       # separator kolumn
                  dec = ".")	       # separator dziesiętny
str(asseco)


# data i zwroty
asseco$Date <- as.Date(asseco$Date)

# mergowanie z WIG20 do obiektu data.frame
str(WIG20)
asseco$rasseco <- diff.xts(log(asseco$Close))
asseco.wig20 <- merge(WIG20[, c("Date", "r")],
                      asseco[, c("Date", "rasseco")],
                      by = "Date")
str(asseco.wig20)

# ucinanie obserwacji
asseco.wig20 <- asseco.wig20[asseco.wig20$Date >= "2014-01-01", ]

# wykres rozrzutu
# skorzystajmy z pakietu ggplot2
library(ggplot2)
qplot(data = asseco.wig20,
      x = r,
      y = rasseco,
      xlab = "zwroty WIG20",
      ylab = "zwroty Asseco",
      main = paste("zwroty Assseco vs. zwroty WIG20\n",
                   "od",
                   asseco.wig20$Date[1],
                   "do",
                   asseco.wig20$Date[length(asseco.wig20$Date)]
                   )
      ) +  geom_smooth(method = "lm", formula = y ~ x, se = T)

# regresja liniowa
asseco.reg <- lm(formula = r ~ rasseco,
                 data = asseco.wig20)
str(asseco.reg)
summary(asseco.reg)

# wykres reszt w czasie
plot(asseco.reg$residuals, type = 'l')

# histogram reszt
hist(asseco.reg$residuals)

# za pomocą ggplot2
ggplot(asseco.wig20, aes(x = rasseco)) +
    geom_histogram(aes( y = ..density..),      # Histogram with density instead of count on y-axis
                   binwidth = .005,
                   colour = "black",
                   fill = "white") +
    geom_density(alpha = .2, fill = "#FF6666")

# porównanie gęstości zwrotów
library(reshape)
molten.data <- melt(asseco.wig20,
                    id = c("Date"),
                    measured = c("r", "rasseco"))
ggplot(molten.data,
       aes(x = value, fill = variable)) +
    geom_density(alpha = .3) +
    xlab ("") + ylab("gęstość") +
    ggtitle("gęstości zwrotów WIG20 i Asseco")



# zapisywanie obiektu do pliku CSV
write.csv(WIG20, "WIG20_copy.csv")

# jeśli chcemy pominąć nazwy wierszy
write.csv(WIG20, "WIG20_copy.csv", row.names = F)



###################################################################
# Ćwiczenia

# Ćwiczenie 1
# zaimportuj dane z plików CSV dla wybranych innych spółek

# Ćwiczenie 2
# utwórz obiekt typu data.frame z datą, ceną zamknięcia i wolumenem

# Ćwiczenie 3
# przedstaw histogram cen zamknięcia

# Ćwiczenie 4
# przedstaw wykres rozrzutu ceny zamknięcia vw. wolumen

# Ćwiczenie 5
# dodaj do zbioru nową zmienną max_min
# która będzie relacją cen maksymalnej i minimalnej w ciągu dnia
# oraz zmienną p_diff = (close-open)/open

# Ćwiczenie 6
# dla których obserwacji procentowe dzienne zmiany cen były większe
# (co do modułu)# niż 3.5%?

# Ćwiczenie 7
# przedstawić statystyki opisowa dla zmiennej  p_diff

# Ćwiczenie 8
# Przeprowadzić podobną analizę zależności między zwrotami WIG20
# a zwrotami wybranej spółki i opublikować na RPubs.com
