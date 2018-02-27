# Dependencias para el taller de R
Si venís al taller de R con vuestro portátil, os indicamos una lista de dependencias y librerías que es recomendable traer instaladas en función del nivel al que queráis asistir. Es importante que independientemente del nivel al que vayáis a asistir **traigáis instalado R y R-studio**. Podéis bajaros la versión de r-studio acorde con vuestro SO en [la web de rstudio](https://www.rstudio.com/products/rstudio/download/). 
Para instalar R en Linux debéis instalar los paquetes **r-base** y  **r-base-dev**, os dejamos aquí [una ayudita para instalar R en linux](https://www.r-bloggers.com/how-to-install-r-on-linux-ubuntu-16-04-xenial-xerus/). Para windows basta con descargar e instalar [el ejecutable](https://cran.r-project.org/bin/windows/base/).

### Nivel básico

### Nivel medio
Será necesario instalar las siguientes librerías:
- parallel
- ggplot
- ggplot2
- caret
- dplyr

Recordad que las dependencias se pueden instalar desde una consola de Rstudio con el comando: `install.packages("nombre_paquete", dependencies=T)`, por ejemplo: `install.packages("parallel", dependencies=T)`.

### Nivel avanzado
