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
    ## 1 1.3782448 2.843755 1.908992 2.476228 6.249685 6.592305 7.403839 8.717924
    ## 2 0.7213582 2.877837 2.710931 5.108995 5.069998 4.546762 5.689932 9.612836
    ##         c9      c10
    ## 1 7.011970 9.159120
    ## 2 9.069267 9.445571

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

    ##          c1          c2       c3       c4       c5       c6       c7
    ## 1 1.7093284  1.35256167 2.659561 3.294237 4.529713 6.082433 6.484713
    ## 2 0.6821801 -0.07763474 3.114155 3.293220 6.748679 6.964857 7.577975
    ##         c8       c9      c10
    ## 1 7.981756 9.145868 11.57335
    ## 2 5.891570 8.608384 10.85979

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
    ## 171.0305 171.9922 172.9889 174.0140 175.0137 176.0074 177.0015 178.0042 
    ##     c179     c180     c181     c182     c183     c184     c185     c186 
    ## 179.0016 180.0018 180.9953 182.0037 182.9932 184.0024 184.9917 185.9992 
    ##     c187     c188     c189     c190     c191     c192     c193     c194 
    ## 186.9998 188.0031 189.0109 189.9801 191.0061 191.9986 192.9896 193.9940 
    ##     c195     c196     c197     c198     c199     c200 
    ## 195.0001 195.9836 197.0107 197.9976 199.0103 200.0097

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
    ## [1] 1566
    ## 
    ## [[2]]
    ## [1] 222
    ## 
    ## [[3]]
    ## [1] 9
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

    ##   [1] 1566  222    9    0    0    0    0    0    0    0    0    0    0    0
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

Por si quieres saber más: Paralelizando en R
--------------------------------------------

Una práctica muy útil en R es el paralelismo. Supongamos que queremos ejecutar una misma función sobre distintos datasets del mismo tamaño. Si los datasets fueran aproximadamente del tamaño del nuestro, o la función fuera costosa en cómputo, podría tardar mucho tiempo en realizar las ejecuciones.
Una opción para acortar ese tiempo es hacerlo en paralelo, es decir, utilizar varios núcleos del ordenador para realizar la tarea, y si has entendido **apply**, **lapply** y **sapply** es muy directo. Las tres funciones explicadas arriba, tienen una versión paralela: **parApply**, **parLapply** y **parSapply** incluidas en el paquete **parallel**. Para usarlas, sólo hay que tener en cuenta que es necesario crear un cluster con tantos cores como deseemos utilizar, con la función **makeCluster()** y pasarle el cluster a la función **parApply** que deseemos utilizar, además de los parámetros que ya le pasábamos anteriormente. Por último, una buena práctica es detener el cluster creado cuando ya no lo necesitamos con **stopCluster()**.

Por ejemplo, se puede paralelizar la generación de 25 soluciones binarias aleatorias y su optimización a través de un algoritmo de búsqueda local:

``` r
# cargamos librería
  library(parallel)
# obtenemos nuestro número de cores
  no_cores <- detectCores()
# creamos el cluster  
  cl <- makeCluster(no_cores-1,type="FORK")
# utilizamos parLapply , pasándole el cluster  
  ModelosBL <- parLapply(cl,seq_along(1:25),  function(i){
    set.seed(12345*i)
    # genera una solución vecina aleatoria
    vecina<-sample(0:1,350,replace=TRUE)
    # optimizar con búsqueda local
    modelo<-LocalSearchModified(vecina)
    modelo
  }) 
# detenemos el cluster  
stopCluster(cl)
```

(No se incluye el código del algoritmo de Búsqueda local).

#### Ejercicio 5 (Opcional) :

**Prueba a crear otro dataset como el que creamos al comienzo del taller. Luego paraleliza el código para aplicar una función que eleva cada valor al cuadrado, sobre cada dataset.** **Nota: Es conveniente que crees el cluster con tu número de cores -1.**
