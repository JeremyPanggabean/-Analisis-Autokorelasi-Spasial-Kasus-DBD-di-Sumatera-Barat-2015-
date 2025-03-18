#--------------------------------------------------------------#
#------------- AUTOKORELASI SPASIAL SUMATERA -------------
#--------------------------------------------------------------#

# setwd("D:/PROJECT/Pelatihan-Autokorelasi Spasial dengan R Studio")

#--------------------------------------------------------------# 
#IMPORT DATA
data.sumatera=read.csv("data DBD Sumbar 2015.csv", sep = ";")
str(data.sumatera)
View(data.sumatera)

#--------------------------------------------------------------#
#--------PLOT LOKAL MORAN BERDASARKAN KUADRAN------------------#
#--------------------------------------------------------------#
library(dplyr)
library(spdep)
library(gridExtra)
library(ggplot2)

#KOORDINAT
longlat<-data.sumatera[3:4]


#Pembobot 1/Jarak
jarak=dist(longlat)
w<-as.matrix(1/jarak)
listw=mat2listw(w)

# #-------------------------------------------------------------
# #PEMBOBOT KNN
# #-------------------------------------------------------------
# longlat<-as.matrix(longlat) #dibuat supaya terbaca numerik.
# k1=knn2nb(knearneigh(longlat,k=2))
# listw=nb2listw(k1)
# #-------------------------------------------------------------
#PEMBOBOT CONTIGUITY
#-------------------------------------------------------------
#IMPORT PETA SHP
shp.sumatera=read_sf("SHP Sumbar kec tnp Mentawai/sumbar_kec.shp")
##Bobot Queen Contiguity
bobot<-poly2nb(shp.sumatera,queen = TRUE)

#Style: W=terstandarisasi baris, B=Tidak Terstandarisasi
W<-nb2mat(bobot)
dlist1=mat2listw(W,style="W")
listw<-dlist1
#-------------------------------------------------------------


#GEARY'S GLOBAL
geary.test(data.sumatera$KasusDBD ,listw)

#MORAN GLOBAL
moran.test(data.sumatera$KasusDBD ,listw,randomisation=F)
#--------------------------------------------------------------#
#LOCAL MORAN
lmoran1 <- localmoran(data.sumatera$KasusDBD,mat2listw(w)) %>% as.data.frame()

#Penghitungan KUADRAN Local MORAN
#standarisasi peubah Jumlah kasus DBD
data.sumatera$scale.Y <- scale(data.sumatera$KasusDBD)  %>% as.vector()
#pembobotan spasial pada peubah Jumlah kasus DBD yg terstandariasi
data.sumatera$lag.Y <- lag.listw(listw, data.sumatera$scale.Y)

# moran sccaterplot dasar
x1 <- data.sumatera$scale.Y
moran.plot(x1, listw)

data.sumatera$quad_sig <- NA

# high-high quadrant
data.sumatera[(data.sumatera$scale.Y >= 0 &
                 data.sumatera$lag.Y >= 0), "quad_sig"] <- "high-high"
# low-low quadrant
data.sumatera[(data.sumatera$scale.Y <= 0 & 
                 data.sumatera$lag.Y <= 0), "quad_sig"] <- "low-low"
# high-low quadrant
data.sumatera[(data.sumatera$scale.Y >= 0 & 
                 data.sumatera$lag.Y <= 0), "quad_sig"] <- "high-low"
# low-high quadrant
data.sumatera[(data.sumatera$scale.Y <= 0 & 
                 data.sumatera$lag.Y >= 0), "quad_sig"] <- "low-high"

#------------------ menghitung Signifikansi ------------------------------
#------------------------------------------------------------------------#
data.sumatera$sig <- NA

# high-high quadrant
data.sumatera[(lmoran1$`Pr(z != E(Ii))` < 0.05), "sig"] <- "Signifikan"
# low-low quadrant
data.sumatera[(lmoran1$`Pr(z != E(Ii))` >= 0.05), "sig"] <- "Tidak Signifikan"

View(data.sumatera)

#--------------PEMETAAN MORAN SCATTERPLOT--------------------------
#------------------------------------------------------------------------#
#Gabung data GWR dengan SHP
#IMPORT PETA SHP
shp.sumatera=read_sf("SHP Sumbar kec tnp Mentawai/sumbar_kec.shp")
ggplot(data=shp.sumatera) +
  geom_sf()

#Menggabungkan Data ke file SHP
gabung.sumatera=left_join(shp.sumatera,data.sumatera,by="id")

#---------------------------------------------------------------#
#---------------------------------------------------------------#
# Pemetaan Kuadran Local Moran dengan warna dan label yang lebih informatif
plot.sumatera = ggplot(data=gabung.sumatera) +
  geom_sf(aes(fill = quad_sig), color = "black", size = 0.1) +
  scale_fill_manual(
    values = c(
      "high-high" = "#D7191C",  # merah
      "low-low" = "#A6D854",    # hijau muda
      "high-low" = "#FDAE61",   # oranye
      "low-high" = "#2C7BB6"    # biru
    ),
    name = "Local Moran's I"
  ) +
  labs(
    title = "Peta Kuadran Local Moran Kasus DBD SUMBAR",
    subtitle = "Dikategorikan tiap kecamatan berdasarkan hasil Local Moran",
    fill = "Kategori Kuadran"
  ) +
  theme_minimal()
plot.sumatera


#--------------PEMETAAN SIGNIFIKANSI AUTOKORELASI SPASIAL-----------------
plot.sumatera.sig = ggplot(data=gabung.sumatera) +
  geom_sf(aes(fill = sig), color = "black", size = 0.1) +
  scale_fill_manual(
    values = c(
      "Signifikan" = "tomato",
      "Tidak Signifikan" = "white"
    ),
    name = "Signifikansi"
  ) +
  labs(
    title = "Signifikansi Autokorelasi Spasial",
    subtitle = "Ditentukan berdasarkan p-value < 0.05",
    fill = "Status"
  ) +
  theme_minimal()
plot.sumatera.sig


