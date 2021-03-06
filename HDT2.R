#title: "Hoja2"
#author: "Grupo 5"
#date: "2/21/2021"

  
  
  
library(dplyr)
library(cluster) # Para calcular la silueta
library(e1071)# Para cmeans
library(mclust) # Mixtures of gaussians
library(fpc) # Para hacer el plotcluster
library(NbClust) # Para determinar el n?mero de clusters ?ptimo
library(factoextra) # Para hacer gr?ficos de clustering
library(tidyr)

movies <- read.csv("C:/Users/Asus/Desktop/Nuevo Cosas Randy/Clustering/tmdb-movies.csv", stringsAsFactors = F)
movies <- na.omit(movies)

#Inciso 1

#Se obtienen las variables seleccionadas para trabajar
clusteringVar <- movies[c("popularity","budget","revenue","runtime","vote_average")]

#Inciso 2

#Nos ayuda a conocer cual es el numero de clusters adecuados
wss <- (nrow(clusteringVar)-1)*sum(apply(clusteringVar,2,var))
for (i in 2:10) 
  wss[i] <- sum(kmeans(clusteringVar, centers=i)$withinss)

# Se plotea la grafica de codo
plot(1:10, wss, type="b", xlab="Number of Clusters",  ylab="Within groups sum of squares")


#Inciso 3
# Algoritmo K-Means
datos<-movies
peliculasCompleto<-movies[complete.cases(movies),]
peliculasCompleto
km<-kmeans(clusteringVar,3)
datos$grupo<-km$cluster
peliculasCompleto$KM<-km$cluster

# Silueta para K-Means
silkm<-silhouette(km$cluster,dist(clusteringVar))
mean(silkm[,3]) 
plotcluster(clusteringVar,km$cluster) #grafica la ubicacion de los clusters


#Fuzzy C-Means
fcm<-cmeans(clusteringVar,3)
datos$FCGrupos<-fcm$cluster
peliculasCompleto$CM<-fcm$cluster
datos<-cbind(datos,fcm$membership)

# Silueta para Fuzzy C-Means
silfcm<-silhouette(fcm$cluster,dist(clusteringVar))
mean(silfcm[,3])
plotcluster(clusteringVar,fcm$cluster) #grafica la ubicacion de los clusters


#Clustering jer�rquico
hc<-hclust(dist(clusteringVar)) #Genera el clustering jer�rquico de los datos
plot(hc) #Genera el dendograma
rect.hclust(hc,k=3) #Dibuja el corte de los grupos en el gr�fico
groups<-cutree(hc,k=3) #corta el dendograma, determinando el grupo de cada fila
datos$gruposHC<-groups


g1HC<-datos[datos$gruposHC==1,]
g2HC<-datos[datos$gruposHC==2,]
g3HC<-datos[datos$gruposHC==3,]

#M�todo de la silueta para clustering jer�rquico
silch<-silhouette(groups,dist(clusteringVar))
mean(silch[,3]) 