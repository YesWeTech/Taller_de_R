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

    ##            c1       c2       c3       c4       c5       c6       c7
    ## 1  0.90917822 2.216374 1.900270 3.142260 4.129645 6.651031 5.123328
    ## 2 -0.00252234 1.676310 3.927706 3.309619 5.707584 4.343166 7.999579
    ##         c8        c9      c10
    ## 1 9.218790  8.692785 9.180642
    ## 2 7.201006 10.184900 8.576594

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

    ##          c1        c2       c3       c4       c5       c6       c7
    ## 1 1.0953191 3.2259873 3.231367 4.731914 5.885225 6.863831 7.400126
    ## 2 0.4499808 0.5008557 1.829581 6.018862 6.126394 6.920153 7.235304
    ##         c8       c9      c10
    ## 1 7.558036 8.227761 11.05047
    ## 2 8.692539 8.013604 11.36355

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
    ## 170.9850 171.9954 173.0031 173.9887 174.9885 175.9860 177.0056 177.9841 
    ##     c179     c180     c181     c182     c183     c184     c185     c186 
    ## 178.9913 180.0054 180.9911 181.9935 183.0085 184.0012 185.0115 186.0088 
    ##     c187     c188     c189     c190     c191     c192     c193     c194 
    ## 187.0001 187.9994 188.9892 190.0021 190.9984 192.0144 193.0164 194.0079 
    ##     c195     c196     c197     c198     c199     c200 
    ## 195.0031 196.0035 196.9998 197.9896 199.0043 199.9974

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
    ## [1] 1591
    ## 
    ## [[2]]
    ## [1] 244
    ## 
    ## [[3]]
    ## [1] 18
    ## 
    ## [[4]]
    ## [1] 1

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

    ##   [1] 1591  244   18    1    0    0    0    0    0    0    0    0    0    0
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

Por si quieres saber más: paralelizando en R
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

#### Ejercicio 5 (Opcional):

**Crea otro dataset como el que creamos al comienzo del taller, con distinto nombre. Luego crea una lista con ambos datasets usando la función *list* , y paraleliza el código para aplicar sobre cada dataset una función que eleva cada valor al cuadrado. ¡Verás qué rápido lo hace a pesar del tamaño de los datasets!** **Nota: Es conveniente que crees el cluster con tu número de cores -1.**

El paquete **parallel** incluye otras funciones que puedes consultar en [documentación paquete parallel](https://stat.ethz.ch/R-manual/R-devel/library/parallel/doc/parallel.pdf "paquete parallel").

Parte 2: Visualización y particionado de datos
==============================================

Una buena práctica cada vez que tenemos delante un conjunto de datos es explorar su contenido, echando un vistazo a la estructura de las variables, los rangos en los que se mueven, de qué tipo son... Esto nos da una idea de ante qué problema estamos, y como podemos abordarlo. Para hacer el análisis exploratorio de los datos, podemos usar funciones como **class** para ver la clase de los objetos, **str** para ver información sobre la estructura de los datos o **summary** para ver un resumen del dataset. También es común hacer una representación visual como una nube de puntos, para ver visualmente cómo se distribuyen los datos, y boxplots o hibstogramas para visualizar los rangos en los que toman valores las variables. Veamos un ejemplo:

Con rstudio tenemos incluidos varios datasets que vienen incluidos en el paquete *datasets*. Para ver una lista completa de los datasets incluidos:

``` r
data()
```

Vamos a hacer un análisis exploratorio del dataset **Orange**, que incluye datos sobre el crecimiento de 5 naranjos, concretamente la edad del árbol y el grosor de su tronco, cuando se le realizó la medición.

``` r
# Información sobre estructura
str(Orange)
```

    ## Classes 'nfnGroupedData', 'nfGroupedData', 'groupedData' and 'data.frame':   35 obs. of  3 variables:
    ##  $ Tree         : Ord.factor w/ 5 levels "3"<"1"<"5"<"2"<..: 2 2 2 2 2 2 2 4 4 4 ...
    ##  $ age          : num  118 484 664 1004 1231 ...
    ##  $ circumference: num  30 58 87 115 120 142 145 33 69 111 ...
    ##  - attr(*, "formula")=Class 'formula'  language circumference ~ age | Tree
    ##   .. ..- attr(*, ".Environment")=<environment: R_EmptyEnv> 
    ##  - attr(*, "labels")=List of 2
    ##   ..$ x: chr "Time since December 31, 1968"
    ##   ..$ y: chr "Trunk circumference"
    ##  - attr(*, "units")=List of 2
    ##   ..$ x: chr "(days)"
    ##   ..$ y: chr "(mm)"

``` r
# Resumen del dataset
summary(Orange)
```

    ##  Tree       age         circumference  
    ##  3:7   Min.   : 118.0   Min.   : 30.0  
    ##  1:7   1st Qu.: 484.0   1st Qu.: 65.5  
    ##  5:7   Median :1004.0   Median :115.0  
    ##  2:7   Mean   : 922.1   Mean   :115.9  
    ##  4:7   3rd Qu.:1372.0   3rd Qu.:161.5  
    ##        Max.   :1582.0   Max.   :214.0

Con **str** vemos que el dataset está compuesto por 35 filas y 3 columnas, y que una de sus columnas son factores, mientras que las otras dos son numéricas. Con **summary** obtenemos un resumen del dataset, como cual es el mínimo, máximo, media, mediana... de cada columna. Nota: En la columna *Tree* solo se muestra el número de muestras de casa clase porque los datos no son numéricos).

Podemos hacer una primera exploración visual de los datos pintando los datos con la función **qplot** de **ggplot2**. Si no la tenemos instalada, la instalamos con `install.packages('ggplot2')`.

``` r
library(ggplot2)
qplot(age, circumference, data = Orange, geom = "point",xlab = "años", ylab="circuferencia del tronco", colour=Tree, main="Crecimiento de los árboles de naranja")+theme(plot.title = element_text(hjust = 0.5))+scale_color_discrete(name="Árbol")
```

![](tallerNivelMedio_files/figure-markdown_github/unnamed-chunk-8-1.png)

**qplot** es una forma rápida y sencilla de hacer gráficos completos. Le indicamos los datos que queremos representar, qué geometría deseamos ( *geom* ) y qué deseamos poner en los ejes. Con `colour=Tree`, indicamos que nos coloree los datos en función de la clase a la que pertenezca, con los colores por defecto. Si quisiéramos darle unos colores personalizados, podríamos hacerlo añadiendo una nueva capa con **scale\_color\_manual**, lo que nos permitirá cambiar los colores manualmente. Por ejemplo, añadiendo: `scale_color_manual(values = c("#ff0000","#ff4000","#ff8000","#ffbf00","#ffff00")` cambiaríamos los colores por defecto por unos tonos cálidos. Usando el atributo *name* en **scale\_color\_discrete**, ponemos cambiar el título por defecto que le damos a la leyenda. Ésto también podemos hacerlo con **scale\_color\_manual** siempre y cuando especifiquemos también un conjunto de valores. Por último, podemos añadirle un título a nuestro gráfico usando el parámetro *main* o con *ggtitle()*.
