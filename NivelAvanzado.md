NivelAvanzado
================
@ana\_valdi
2 de mayo de 2017

Tutorial para Nivel Avanzado de R
---------------------------------

En este tutorial vamos a aprender como enfrentarnos a una competición de **Kaggle**. Utilizaremos nuestros conocimientos en R y Machine Learning.

La competición que hemos elegido es **Titanic: Machine Learning from Disaster**: <https://www.kaggle.com/c/titanic>.

Titanic fue un transatlántico que naufragó la noche del 14 de abril de 1912 al chocar contra un iceberg. Este hecho provocó la muerte de 1.515 personas (de un total de 2.224). Debido a las consecuencias de esta tragedia, el naufragió del Titanic se ha convertido en un de los más famosos de la historia.

El objetivo de esta competición es el de predecir qué personas sobrevivieron.

Descargar los Datasets
----------------------

El primer paso que debemos realizar es la descarga de datos. Para ellos, iremos al link: <https://www.kaggle.com/c/titanic/data> y procederemos a la descarga.

Los archivos los guardaremos en una carpeta que llamaremos **data**.

Librerías que Vamos a Utilizar
------------------------------

Es importante que instalemos y carguemos las librerías siguientes antes de empezar el tutorial: `ggplot2, reshape2, caret`:

``` r
require(ggplot2)
```

    ## Loading required package: ggplot2

    ## Warning: package 'ggplot2' was built under R version 3.3.3

``` r
require(reshape2)
```

    ## Loading required package: reshape2

    ## Warning: package 'reshape2' was built under R version 3.3.3

``` r
require(caret)
```

    ## Loading required package: caret

    ## Warning: package 'caret' was built under R version 3.3.3

    ## Loading required package: lattice

Importar los Datasets a R
-------------------------

Primero vamos a configurar nuestro espacio de trabajo. Para ello, vamos a decirle a R en qué carpeta vamos a trabajar:

``` r
setwd("C:/Users/Ana/Dropbox (Personal)/AlhambraAnalytics/TallerR/")
```

Leemos los datasets:

``` r
train <- read.csv("./data/train.csv")
test <- read.csv("./data/test.csv")
gender_submission <- read.csv("./data/gender_submission.csv")
```

Analizar la Estructura de los Datasets
--------------------------------------

La función `str` nos devuelve la estructura del dataset. Nos informa de cuántas observaciones y variables contiene el dataset. Además, también nos devuelve de las clases de las variables:

``` r
str(train)
```

    ## 'data.frame':    891 obs. of  12 variables:
    ##  $ PassengerId: int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ Survived   : int  0 1 1 1 0 0 0 0 1 1 ...
    ##  $ Pclass     : int  3 1 3 1 3 3 1 3 3 2 ...
    ##  $ Name       : Factor w/ 891 levels "Abbing, Mr. Anthony",..: 109 191 358 277 16 559 520 629 417 581 ...
    ##  $ Sex        : Factor w/ 2 levels "female","male": 2 1 1 1 2 2 2 2 1 1 ...
    ##  $ Age        : num  22 38 26 35 35 NA 54 2 27 14 ...
    ##  $ SibSp      : int  1 1 0 1 0 0 0 3 0 1 ...
    ##  $ Parch      : int  0 0 0 0 0 0 0 1 2 0 ...
    ##  $ Ticket     : Factor w/ 681 levels "110152","110413",..: 524 597 670 50 473 276 86 396 345 133 ...
    ##  $ Fare       : num  7.25 71.28 7.92 53.1 8.05 ...
    ##  $ Cabin      : Factor w/ 148 levels "","A10","A14",..: 1 83 1 57 1 1 131 1 1 1 ...
    ##  $ Embarked   : Factor w/ 4 levels "","C","Q","S": 4 2 4 4 4 3 4 4 4 2 ...

``` r
str(test)
```

    ## 'data.frame':    418 obs. of  11 variables:
    ##  $ PassengerId: int  892 893 894 895 896 897 898 899 900 901 ...
    ##  $ Pclass     : int  3 3 2 3 3 3 3 2 3 3 ...
    ##  $ Name       : Factor w/ 418 levels "Abbott, Master. Eugene Joseph",..: 210 409 273 414 182 370 85 58 5 104 ...
    ##  $ Sex        : Factor w/ 2 levels "female","male": 2 1 2 2 1 2 1 2 1 2 ...
    ##  $ Age        : num  34.5 47 62 27 22 14 30 26 18 21 ...
    ##  $ SibSp      : int  0 1 0 0 1 0 0 1 0 2 ...
    ##  $ Parch      : int  0 0 0 0 1 0 0 1 0 0 ...
    ##  $ Ticket     : Factor w/ 363 levels "110469","110489",..: 153 222 74 148 139 262 159 85 101 270 ...
    ##  $ Fare       : num  7.83 7 9.69 8.66 12.29 ...
    ##  $ Cabin      : Factor w/ 77 levels "","A11","A18",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ Embarked   : Factor w/ 3 levels "C","Q","S": 2 3 2 3 3 3 2 3 1 3 ...

``` r
str(gender_submission)
```

    ## 'data.frame':    418 obs. of  2 variables:
    ##  $ PassengerId: int  892 893 894 895 896 897 898 899 900 901 ...
    ##  $ Survived   : int  0 1 0 0 1 0 1 0 1 0 ...

No obstante, si sólo queremos obtener información de la clase podemos ejecutar la siguiente orden:

``` r
lapply(train, class)
```

    ## $PassengerId
    ## [1] "integer"
    ## 
    ## $Survived
    ## [1] "integer"
    ## 
    ## $Pclass
    ## [1] "integer"
    ## 
    ## $Name
    ## [1] "factor"
    ## 
    ## $Sex
    ## [1] "factor"
    ## 
    ## $Age
    ## [1] "numeric"
    ## 
    ## $SibSp
    ## [1] "integer"
    ## 
    ## $Parch
    ## [1] "integer"
    ## 
    ## $Ticket
    ## [1] "factor"
    ## 
    ## $Fare
    ## [1] "numeric"
    ## 
    ## $Cabin
    ## [1] "factor"
    ## 
    ## $Embarked
    ## [1] "factor"

``` r
lapply(test, class)
```

    ## $PassengerId
    ## [1] "integer"
    ## 
    ## $Pclass
    ## [1] "integer"
    ## 
    ## $Name
    ## [1] "factor"
    ## 
    ## $Sex
    ## [1] "factor"
    ## 
    ## $Age
    ## [1] "numeric"
    ## 
    ## $SibSp
    ## [1] "integer"
    ## 
    ## $Parch
    ## [1] "integer"
    ## 
    ## $Ticket
    ## [1] "factor"
    ## 
    ## $Fare
    ## [1] "numeric"
    ## 
    ## $Cabin
    ## [1] "factor"
    ## 
    ## $Embarked
    ## [1] "factor"

``` r
lapply(gender_submission, class)
```

    ## $PassengerId
    ## [1] "integer"
    ## 
    ## $Survived
    ## [1] "integer"

-   **Ejercicio 1:** ¿Existe alguna variable que sea `character`? ¿Crees que se debería de cambiar la clase de alguna de las variables?

La función `summary` devuelve un resumen por cada variable:

``` r
summary(train)
```

    ##   PassengerId       Survived          Pclass     
    ##  Min.   :  1.0   Min.   :0.0000   Min.   :1.000  
    ##  1st Qu.:223.5   1st Qu.:0.0000   1st Qu.:2.000  
    ##  Median :446.0   Median :0.0000   Median :3.000  
    ##  Mean   :446.0   Mean   :0.3838   Mean   :2.309  
    ##  3rd Qu.:668.5   3rd Qu.:1.0000   3rd Qu.:3.000  
    ##  Max.   :891.0   Max.   :1.0000   Max.   :3.000  
    ##                                                  
    ##                                     Name         Sex           Age       
    ##  Abbing, Mr. Anthony                  :  1   female:314   Min.   : 0.42  
    ##  Abbott, Mr. Rossmore Edward          :  1   male  :577   1st Qu.:20.12  
    ##  Abbott, Mrs. Stanton (Rosa Hunt)     :  1                Median :28.00  
    ##  Abelson, Mr. Samuel                  :  1                Mean   :29.70  
    ##  Abelson, Mrs. Samuel (Hannah Wizosky):  1                3rd Qu.:38.00  
    ##  Adahl, Mr. Mauritz Nils Martin       :  1                Max.   :80.00  
    ##  (Other)                              :885                NA's   :177    
    ##      SibSp           Parch             Ticket         Fare       
    ##  Min.   :0.000   Min.   :0.0000   1601    :  7   Min.   :  0.00  
    ##  1st Qu.:0.000   1st Qu.:0.0000   347082  :  7   1st Qu.:  7.91  
    ##  Median :0.000   Median :0.0000   CA. 2343:  7   Median : 14.45  
    ##  Mean   :0.523   Mean   :0.3816   3101295 :  6   Mean   : 32.20  
    ##  3rd Qu.:1.000   3rd Qu.:0.0000   347088  :  6   3rd Qu.: 31.00  
    ##  Max.   :8.000   Max.   :6.0000   CA 2144 :  6   Max.   :512.33  
    ##                                   (Other) :852                   
    ##          Cabin     Embarked
    ##             :687    :  2   
    ##  B96 B98    :  4   C:168   
    ##  C23 C25 C27:  4   Q: 77   
    ##  G6         :  4   S:644   
    ##  C22 C26    :  3           
    ##  D          :  3           
    ##  (Other)    :186

``` r
summary(test)
```

    ##   PassengerId         Pclass     
    ##  Min.   : 892.0   Min.   :1.000  
    ##  1st Qu.: 996.2   1st Qu.:1.000  
    ##  Median :1100.5   Median :3.000  
    ##  Mean   :1100.5   Mean   :2.266  
    ##  3rd Qu.:1204.8   3rd Qu.:3.000  
    ##  Max.   :1309.0   Max.   :3.000  
    ##                                  
    ##                                         Name         Sex     
    ##  Abbott, Master. Eugene Joseph            :  1   female:152  
    ##  Abelseth, Miss. Karen Marie              :  1   male  :266  
    ##  Abelseth, Mr. Olaus Jorgensen            :  1               
    ##  Abrahamsson, Mr. Abraham August Johannes :  1               
    ##  Abrahim, Mrs. Joseph (Sophie Halaut Easu):  1               
    ##  Aks, Master. Philip Frank                :  1               
    ##  (Other)                                  :412               
    ##       Age            SibSp            Parch             Ticket   
    ##  Min.   : 0.17   Min.   :0.0000   Min.   :0.0000   PC 17608:  5  
    ##  1st Qu.:21.00   1st Qu.:0.0000   1st Qu.:0.0000   113503  :  4  
    ##  Median :27.00   Median :0.0000   Median :0.0000   CA. 2343:  4  
    ##  Mean   :30.27   Mean   :0.4474   Mean   :0.3923   16966   :  3  
    ##  3rd Qu.:39.00   3rd Qu.:1.0000   3rd Qu.:0.0000   220845  :  3  
    ##  Max.   :76.00   Max.   :8.0000   Max.   :9.0000   347077  :  3  
    ##  NA's   :86                                        (Other) :396  
    ##       Fare                     Cabin     Embarked
    ##  Min.   :  0.000                  :327   C:102   
    ##  1st Qu.:  7.896   B57 B59 B63 B66:  3   Q: 46   
    ##  Median : 14.454   A34            :  2   S:270   
    ##  Mean   : 35.627   B45            :  2           
    ##  3rd Qu.: 31.500   C101           :  2           
    ##  Max.   :512.329   C116           :  2           
    ##  NA's   :1         (Other)        : 80

``` r
summary(gender_submission)
```

    ##   PassengerId        Survived     
    ##  Min.   : 892.0   Min.   :0.0000  
    ##  1st Qu.: 996.2   1st Qu.:0.0000  
    ##  Median :1100.5   Median :0.0000  
    ##  Mean   :1100.5   Mean   :0.3636  
    ##  3rd Qu.:1204.8   3rd Qu.:1.0000  
    ##  Max.   :1309.0   Max.   :1.0000

-   **Ejercicio 2:** ¿Cuál es la media de la variable `Survived`? ¿Y la mediana? ¿Qué relación existe entre estas dos medidas estadísticas?

Algunas Gráficas
----------------

Siempre es aconsejable acompañar las medidas estadísticas con alguna gráfica para hacernos una idea general del comportamiendo de los datos. La librería que utilizaremos es `ggplot2`, capaz de realizar gráficos excelentes (si sabemos cómo manejarla...). En este caso, vamos a realizar un histograma de train:

``` r
# Guardar las variables como factors
dataPlot <- train
nameVar <- c("Pclass", "Sex", "SibSp", "Parch", "Embarked", "Survived") 
dataPlot <- dataPlot[ ,nameVar]
dataPlot[ ,nameVar] <- lapply(dataPlot[,nameVar], as.factor)

# Histograma de las variables seleccionadas
meltData <- as.data.frame(melt(dataPlot, id.vars="Survived"))
```

    ## Warning: attributes are not identical across measure variables; they will
    ## be dropped

``` r
ggplot(meltData, aes(x = value)) + facet_wrap(~variable, scales = "free") +
  geom_bar(aes(fill=Survived)) + scale_fill_manual(values=c("coral2", "cyan3")) + 
  ggtitle("Histograma") + theme(plot.title = element_text(lineheight=.8, face="bold")) 
```

![](NivelAvanzado_files/figure-markdown_github/unnamed-chunk-8-1.png)

-   **Ejercicio 3:** Realiza el mismo histograma pero para las variables de test. ¿Tienen una distribución parecida?
-   **Ejercicio 4:** ¿Se te ocurre otro gráfico que ayude a realizar un análisi visual de los datos?
-   **Ejercicio 5:** ¿Si tuvieras que elegir una variable para explicar la clase (`Survived`), cuál eligirías? (*Pista:* [El mito de los naufrágeos](http://www.bbc.com/mundo/noticias/2012/04/120413_mujeres_ninos_primero_mito_adz.shtml))

Primer Modelo
-------------

Según la variable que hayamos elegido en el **Ejercicio 5**, construiremos el primer modelo. Por ejemplo, observamos que la variable `Sex` muestra un comportamiento muy diferente en la superviviencia según si es `Female` o `Male`:

``` r
table(train$Sex, train$Survived)
```

    ##         
    ##            0   1
    ##   female  81 233
    ##   male   468 109

``` r
prop.table(table(train$Sex, train$Survived))
```

    ##         
    ##                   0          1
    ##   female 0.09090909 0.26150393
    ##   male   0.52525253 0.12233446

Como observamos, perecieron muchos más hombres (52.52 %) que mujeres (0.09 %). Por lo tanto, vamos a crear nuestro primer modelo bajo la hipótesis que si eres mujer sobrevives y si eres hombre mueres:

``` r
test$Survived <- ifelse(test$Sex == "female", 1, 0)

GenderModel <- data.frame(PassengerId = test$PassengerId, Survived = test$Survived)
write.csv(GenderModel, file = "GenderModel.csv", row.names = FALSE)
```

-   **Ejercicio 6:** ¿Qué puntuación has obtenido?

Imputación de Valores Perdidos
------------------------------

Antes de construir un modelo de Machine Learning, debemos de
