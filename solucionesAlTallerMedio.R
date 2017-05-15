# Soluciones al taller nivel medio

#Ejercicio2
col.CoefficientOfVariation<-apply(dataset,2,function(x) sd(x)/mean(x))

#Ejercicio3
#opcion1:
negatives.count<-lapply(1:200, function(i,data){
  length(which(data[[i]]<0))
},data=dataset)

#opcion2:
count.negatives<-function(data){
  length(which(data<0))
}

negatives<-lapply(dataset,count.negatives)

#Ejercicio4

negativesToNAs<-sapply(1:200, function(i){
  dataset[[i]][dataset[[i]]<0]<-NA
  dataset[[i]]
  })

# comprobamos que es correcto
length(which(is.na(negativesToNAs[[1]])))


# Ejercicio 5:

## Creando el dataset 2

# lo hacemos funcional
dataset2<-NULL

dataset2 <-lapply(1:200, function(i) rnorm(10000,i,1) )
# convertimos a data frame
dataset2<-as.data.frame(dataset)
# renombramos las columnas
colnames(dataset2)<-paste("c",1:200,sep = "")
head(dataset2[,1:10],2)

#combinamos los datasets
datasets<-list(dataset,dataset2)
#comprobamos si son iguales
identical(datasets[[1]],dataset)
identical(datasets[[2]],dataset2)

#aplicamos la función en paralelo
library(parallel)
no_cores <- detectCores()-1
cl <- makeCluster(no_cores-1,type="FORK")
dataset2_squared <- parLapply(cl,1:length(datasets),  function(i){
  dt<-apply(datasets[[i]],2, function(x) x^2)
  dt
})
stopCluster(cl)

# comprobamos si es correcto
dataset2_squared[[2]][,200]==(dataset2[,200]^2)


#Ejercicio 6

class(iris)
str(iris)
summary(iris)

#gráfico
library(ggplot2)
#sépalo
qplot(Sepal.Length, Sepal.Width, data = iris, geom = "point",xlab = "longitud de sépalo", ylab="ancho del sépalo", colour=Species, main="Representación por sépalo de los lirios")+theme(plot.title = element_text(hjust = 0.5))+scale_color_manual(values= c("#ff0000","#ff4000","#ff8000"),name="Especie")


#pétalo
qplot(Petal.Length, Petal.Width, data = iris, geom = "point",xlab = "longitud de sépalo", ylab="ancho del sépalo", colour=Species, main="Representación por pétalo de los lirios")+theme(plot.title = element_text(hjust = 0.5))+scale_color_manual(values= c("#ff0000","#ff4000","#ff8000"),name="Especie")

# b)
table(iris$Sepal.Length,iris$Species)

# Ejercicio 7
# longitud del pétalo por tipo de flor
d<-subset(iris,select = c(Petal.Length,Species))
# lo pasamos a data frame para que ggplot lo sepa manejar
d<-as.data.frame(d)
# creamos el gráfico
ggplot(d,aes(x=Species,y=Petal.Length,fill=Species))+geom_boxplot()+xlab("clase de lirio")+ylab("longitud del pétalo")+scale_fill_discrete(name="Lirio")+ggtitle("Longitud del pétalo por tipo de lirio")+theme(plot.title = element_text(hjust = 0.5))

# ancho del pétalo por tipo de flor
d<-subset(iris,select = c(Petal.Width,Species))
# lo pasamos a data frame para que ggplot lo sepa manejar
d<-as.data.frame(d)
# creamos el gráfico
ggplot(d,aes(x=Species,y=Petal.Width,fill=Species))+geom_boxplot()+xlab("clase de lirio")+ylab("ancho del pétalo")+scale_fill_discrete(name="Lirio")+ggtitle("Ancho del pétalo por tipo de lirio")+theme(plot.title = element_text(hjust = 0.5))

# longitud del sépalo por tipo de flor
d<-subset(iris,select = c(Sepal.Length,Species))
# lo pasamos a data frame para que ggplot lo sepa manejar
d<-as.data.frame(d)
# creamos el gráfico
ggplot(d,aes(x=Species,y=Sepal.Length,fill=Species))+geom_boxplot()+xlab("clase de lirio")+ylab("longitud del sépalo")+scale_fill_discrete(name="Lirio")+ggtitle("Longitud del sépalo por tipo de lirio")+theme(plot.title = element_text(hjust = 0.5))

# ancho del sépalo por tipo de flor
d<-subset(iris,select = c(Sepal.Width,Species))
# lo pasamos a data frame para que ggplot lo sepa manejar
d<-as.data.frame(d)
# creamos el gráfico
ggplot(d,aes(x=Species,y=Sepal.Width,fill=Species))+geom_boxplot()+xlab("clase de lirio")+ylab("ancho del sépalo")+scale_fill_discrete(name="Lirio")+ggtitle("Ancho del sépalo por tipo de lirio")+theme(plot.title = element_text(hjust = 0.5))



#Ejercicio 8
ggplot(as.data.frame.numeric(iris$Sepal.Length),aes(x=iris$Sepal.Length,fill=I("#003300")))+geom_histogram(binwidth = 0.4,colour="#00b300")+xlab("longitud del sépalo")+ylab("Frecuencia")+ggtitle("Ocurrencia de valores de longitud de sépalo")+theme(plot.title = element_text(hjust = 0.5))

# Ejercicio 9
# Ir ejecutando el código de ejemplo y calculando el porcentaje con:
summary(train$Tree)/nrow(train)*100
summary(test$Tree)/nrow(test)*100
