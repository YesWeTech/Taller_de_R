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

    ##          c1       c2       c3       c4       c5       c6       c7       c8
    ## 1  0.940916 3.019587 2.905043 2.843252 5.529765 5.975697 7.429405 7.342353
    ## 2 -1.462041 1.976032 3.219560 1.967850 4.731060 5.896555 6.639822 7.679912
    ##          c9       c10
    ## 1 10.108764  9.907254
    ## 2  8.568124 10.245012

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

    ##         c1       c2       c3       c4       c5       c6       c7       c8
    ## 1 0.983066 2.256665 3.547952 3.107136 6.428676 7.230708 4.852892 7.170250
    ## 2 2.161487 3.620396 3.959297 3.010506 5.796606 8.002496 7.586940 8.080179
    ##         c9      c10
    ## 1 9.251400 9.827403
    ## 2 9.028154 9.382904

¿Has notado la diferencia? Aunque en este caso la diferencia de tiempo no es muy grande (~3s), es sólo un ejemplo muy simple para ilustrar. Cuando trabajamos con datasets más grandes u operaciones más complejas la diferencia puede llegar a ser de horas.

#### Ejercicio 1:

**Puedes comprobar como la diferencia de tiempo aumenta repitiendo lo anterior creando un dataset más grande.**

Apply, lapply y sapply
----------------------

**Funcional** debe su nombre a que recibe una función como parámetro, así que tanto apply, como sapply y lapply recibirán una función entre sus parámetros.

### Apply

Cuando tenemos un conjunto de datos sobre el que queremos hacer alguna operación por filas o columnas, podemos usar **apply(datos, 1|2, función)**, donde ***datos*** son los datos sobre los que queremos operar, ***1*** es un flag para indicar si queremos operar por filas o ***2*** si queremos operar por columnas, y ***función*** es la función que queremos aplicar a cada fila o columna de los datos proporcionados. Es importante que los datos sean del mismo tipo para poder realizar las mismas operaciones sobre ellos.

Por ejemplo, podemos usar **apply** para calcular la media de cada columna de nuestro gran dataset:

``` r
col.means<-apply(dataset,2,mean)
# mostramos sólo las 30 últimas líneas por simplificar la salida
tail(col.means,30)
```

    ##     c171     c172     c173     c174     c175     c176     c177     c178 
    ## 171.0035 172.0050 173.0042 174.0050 174.9939 176.0040 176.9878 177.9911 
    ##     c179     c180     c181     c182     c183     c184     c185     c186 
    ## 179.0005 179.9926 180.9822 182.0019 182.9939 183.9917 184.9963 186.0041 
    ##     c187     c188     c189     c190     c191     c192     c193     c194 
    ## 187.0097 187.9767 189.0128 190.0088 190.9890 192.0011 192.9992 194.0096 
    ##     c195     c196     c197     c198     c199     c200 
    ## 194.9993 196.0066 196.9842 198.0030 198.9923 200.0002

#### Ejercicio 2:

**Usa Apply para calcular el coeficiente de variación (desviación típica dividido por la media) de cada columna de nuestro conjunto de datos.**

### Lapply

Esta función recibe unos datos, que suelen ser una lista o un vector, y una función como parámetros. Su funcionamiento consiste en recorrer los datos especificados y aplicarles la función especificada. Es como una versión de Apply que devuelve el resultado en forma de lista, por eso la **L**.

Por ejemplo, podemos usar **lapply** para calcular cuántos números negativos hay en cada columna de nuestro dataset:

``` r
negatives.count<-lapply(1:ncol(dataset), function(i){
  length(which(dataset[[i]]<0))
})

# mostramos sólo un trozo del output por simplicidad
head(negatives.count,4)
```

    ## [[1]]
    ## [1] 1565
    ## 
    ## [[2]]
    ## [1] 216
    ## 
    ## [[3]]
    ## [1] 13
    ## 
    ## [[4]]
    ## [1] 0

Como veis, nos devuelve el resultado en una lista. Si quisiéramos el resultado en forma de vector en vez de lista, podemos usar **unlist** sobre la salida de **lapply**.

### Sapply

La sintaxis es la misma que la de **lapply**, cambiando el nombre de la función. La dinámica también es la misma, pero **sapply** devuelve como resultado un vector en lugar de una lista.

Por ejemplo, podemos repetir el código anterior usando **sapply**, y veremos que sólo difiere en el formato que presenta la salida:

``` r
negatives.count<-sapply(1:ncol(dataset), function(i){
  length(which(dataset[[i]]<0))
})

# mostramos la salida
negatives.count
```

    ##   [1] 1565  216   13    0    0    0    0    0    0    0    0    0    0    0
    ##  [15]    0    0    0    0    0    0    0    0    0    0    0    0    0    0
    ##  [29]    0    0    0    0    0    0    0    0    0    0    0    0    0    0
    ##  [43]    0    0    0    0    0    0    0    0    0    0    0    0    0    0
    ##  [57]    0    0    0    0    0    0    0    0    0    0    0    0    0    0
    ##  [71]    0    0    0    0    0    0    0    0    0    0    0    0    0    0
    ##  [85]    0    0    0    0    0    0    0    0    0    0    0    0    0    0
    ##  [99]    0    0    0    0    0    0    0    0    0    0    0    0    0    0
    ## [113]    0    0    0    0    0    0    0    0    0    0    0    0    0    0
    ## [127]    0    0    0    0    0    0    0    0    0    0    0    0    0    0
    ## [141]    0    0    0    0    0    0    0    0    0    0    0    0    0    0
    ## [155]    0    0    0    0    0    0    0    0    0    0    0    0    0    0
    ## [169]    0    0    0    0    0    0    0    0    0    0    0    0    0    0
    ## [183]    0    0    0    0    0    0    0    0    0    0    0    0    0    0
    ## [197]    0    0    0    0

#### Ejercicio 3:

**El ejemplo que hemos hecho con lapply y sapply no es muy reutilizable, ya que estamos asumiendo que existe una variable que se llama *dataset* y que contiene un dataset. ¿Cómo podemos arreglarlo?** **Pista: las funciones pueden recibir más de un sólo parámetro.**

#### Ejercicio 4:

**Usa programación funcional para sustituir por *NAs* todos los números negativos del dataset. Puedes usar *length(which(is.na(dataset\[\[i\]\])))* para comprobar si lo has hecho bien, comprobando que el número de NAs de cada columna coincide con el número de negativos que obtuvimos anteriormente para cada columna.**
