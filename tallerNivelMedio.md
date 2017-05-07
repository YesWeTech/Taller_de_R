Taller nivel medio
================
Cristina HG(@\_musicalnote)
19-mayo-2017

Bienvenidos al taller nivel medio de R. En él aprenderás a hacer más eficiente tu código con alternativas a los bucles, como son **apply**, **sapply**, **lapply**. También aprenderás a paralelizar tu código R, usando más de un núcleo, y por último aprenderás con un ejemplo distintas formas de particionar un dataset y a hacer algunas de las representaciones gráficas más comunes, como boxplots, nube de puntos o hibstogramas. ¡Empezamos!

Parte 1: Agilizando el código - programación funcional
======================================================

Una práctica muy recomendable en R es evitar los bucles, sobre todo los **for**. Incluso hay quien prohíbe su uso totalmente... la razón principal es la eficiencia. ¿Pero tanto se nota? Bueno... eso júzgalo tú a continuación. En el siguiente código vamos a crear un conjunto de datos. Para ello símplemente vamos a ir generando los datos mediante una distribución normal aleatoria con **rnorm**, especificando el número de observaciones que queremos crear, la media y la desviación típica de las mismas. Lo hacemos dentro de un for, y creamos el conjunto de datos con 10000 filas y 200 columnas:

``` r
# Creamos el conjunto de datos con un bucle for

dataset<-NULL

for(i in 1:200){
    dataset<-cbind(dataset,rnorm(10000,i,1))
}
# convertimos a data frame
dataset<-as.data.frame(dataset)
# renombramos las columnas
colnames(dataset)<-paste("c",1:200,sep = "")
# mostramos dos líneas de las 10 primeras columnas del conjunto creado
head(dataset[,1:10],2)
```

    ##         c1       c2       c3       c4       c5       c6       c7       c8
    ## 1 1.314100 2.332448 4.041926 3.406950 5.849706 5.275810 5.840109 7.979973
    ## 2 1.306786 2.576031 1.881525 6.177272 6.297485 5.980646 7.370110 6.849714
    ##         c9      c10
    ## 1 9.945375 11.12709
    ## 2 9.934660 11.39247

Te habrás percatado de que tarda unos segundos. Ahora hacemos lo mismo funcional:

``` r
# lo hacemos funcional
dataset<-NULL

dataset <-lapply(1:200, function(i) rnorm(10000,i,1) )
# convertimos a data frame
dataset<-as.data.frame(dataset)
# renombramos las columnas
colnames(dataset)<-paste("c",1:200,sep = "")
head(dataset[,1:10],2)
```

    ##           c1        c2       c3       c4       c5       c6       c7
    ## 1  3.1494619 0.4666837 3.013599 3.984017 5.091506 7.980825 6.754699
    ## 2 -0.5920479 2.0312720 3.688432 5.405028 4.198555 5.757965 9.105606
    ##         c8       c9      c10
    ## 1 7.579990 9.028846 10.65944
    ## 2 7.820918 8.976397 10.70250

¿Has notado la diferencia? Aunque en este caso la diferencia de tiempo no es muy grande (~3s), es sólo un ejemplo muy simple para ilustrar. Cuando trabajamos con datasets más grandes u operaciones más complejas la diferencia puede llegar a ser de horas.

#### Ejercicio 1:

**Puedes comprobar como la diferencia de tiempo aumenta repitiendo lo anterior creando un dataset más grande.**

Apply, lapply y sapply
----------------------

**Funcional** debe su nombre a que recibe una función como parámetro, así que tanto apply, como sapply y lapply recibirán una función entre sus parámetros.

### Apply

Cuando tenemos un conjunto de datos sobre el que queremos hacer alguna operación por filas o columnas, podemos usar **apply(datos,1|2,función)**, donde *datos* son los datos sobre los que queremos operar, *1* es un flag para indicar si queremos operar por filas o *2* si queremos operar por columnas, y *función* es la función que queremos aplicar a cada fila o columna de los datos proporcionados.

Por ejemplo, podemos usar **apply** para calcular la media de cada columna de nuestro gran dataset:

``` r
col.means<-apply(dataset,2,mean)
# mostramos sólo las 20 últimas líneas por simplificar la salida
tail(col.means,30)
```

    ##     c171     c172     c173     c174     c175     c176     c177     c178 
    ## 170.9954 171.9791 172.9869 173.9937 174.9968 176.0097 177.0081 177.9922 
    ##     c179     c180     c181     c182     c183     c184     c185     c186 
    ## 179.0244 179.9914 181.0024 181.9978 182.9843 184.0051 184.9832 185.9967 
    ##     c187     c188     c189     c190     c191     c192     c193     c194 
    ## 186.9976 188.0091 189.0136 189.9950 191.0031 191.9782 193.0082 193.9961 
    ##     c195     c196     c197     c198     c199     c200 
    ## 194.9857 196.0111 196.9945 197.9948 199.0160 200.0042

#### Ejercicio 2:

**Usa Apply para calcular el coeficiente de variación (desviación típica dividido por la media) de cada columna de nuestro conjunto de datos.**
