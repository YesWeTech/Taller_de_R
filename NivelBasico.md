Nivel Basico
================
Geek and Tech Girls
17 de abril de 2017

Tutorial básico sobre R
=======================

Al terminar este tutorial tendrás unas nociones básicas de R y podrás:

-   Instalar paquetes nuevos en R
-   Crear un script de R
-   Hacer operaciones básicas
-   Utilizar distintos tipos de datos simples
-   Crear vectores y vectores-factores
-   Conocer los dataframes de R

R Studio
--------

En este taller utilizaremos R Studio. Consulta el [README](https://github.com/geekandtechgirls/Taller_de_R/blob/master/README.md) para saber más sobre cómo instalarlo. La interfaz de R Studioes así:

[](imgs/interfaz_R_studio.png)

Como ves, puedes ir escribiendo los comandos directamente en la línea de comandos, pero también puedes hacer un script. Para ello nos vamos arriba a la izquierda: [](imgs/new_file.png).

Aritmética con R
----------------

### Asignación de variables

### Operadores

Tipos de datos
--------------

Al igual que todos los lenguajes de programación, *R* trabaja los tipos de datos básicos:

-   **Numeric**: números decimales.
-   **Integer**: números enteros. Para diferenciarlos de los numeric, se coloca una `L` al final de número.
-   **Logical**: valores booleanos. En *R*, los valores booleanos son `TRUE` y `FALSE` aunque también se acepta `T` y `F`.
-   **Character**: texto (*string*).

Para saber el tipo de una variable, se usa la función `class`:

``` r
class(5.6)
```

    ## [1] "numeric"

``` r
class(5L)
```

    ## [1] "integer"

``` r
class(T)
```

    ## [1] "logical"

``` r
class(TRUE)
```

    ## [1] "logical"

``` r
class("TRUE")
```

    ## [1] "character"

### Ejercicio

**Prueba a declarar una variable con un número decimal, pero poniéndole la `L` que se pone al declarar números enteros ¿qué pasa?**

### Ejercicio

**Declara un entero sin la `L` al final y comprueba su tipo, ¿qué tipo de variable es?**

Vectores y factores
-------------------

Dataframes
----------
