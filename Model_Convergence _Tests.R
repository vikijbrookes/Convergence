################################################################
####      Model convergence tests
################################################################
# Can use a variety of methods. 
# Co-efficient of variation (sd/mean) is useful, because it is a measure of relative variability.
# Can either use it as in 'Brendan's method' and calculate the CV for all samples in a simulation,
# Or, we can use it as in 'Viki's Method': Run 10 simulations of each number of iterations, 
# e.g. 10 sets of 50 iterations each. Find the mean for each set, then calculate the sd and the CV.
# For this method, the CV will approach zero, because the variation between the means of the 
# samples in the sets will decrease. Estimate the point at which the CV is < 0.025.


# This is samples from the Warraber model.
Sample1 = read.csv("file:///C:/Users/viki.brookes/OneDrive/Rabies/Papers/Rabies_Model/NetworkPaper_results/Warraber_Warraber_NewWS_2018_09_29_131519/Duration.csv", header = F)
Sample2= read.csv("file:///C:/Users/viki.brookes/OneDrive/Rabies/Papers/Rabies_Model/NetworkPaper_results/Warraber_Warraber_NewWS_2018_09_29_131519/Rabid_dogs.csv", header = F)

Sample1 = c(Sample1$V2) # Make a list 
summary(Sample1)

Sample2 = c(Sample2$V2) # Make a list 
summary(Sample2)

# If zeros in sample just add 1 to all values
#Sample1 = c(Sample$V2 + 1)

###############################################################
## Brendans method
SD_All = c()
CV_All = c()
Mean_All = c()
j=10

for (i in  1:20000) { 
  Iter1 = sample(Sample1, j, replace = T)
  CV_Iter1 = sd(Iter1)/mean(Iter1)
  SD_Iter1 = sd(Iter1)
  Mean_Iter1 = mean(Iter1)
  j = j +1
  CV_All = c(CV_All, CV_Iter1)
  SD_All = c(SD_All, SD_Iter1)
  Mean_All = c(Mean_All, Mean_Iter1)
   }
 
par(mfrow = c(3,1))
plot(SD_All, xlab = 'iteration', ylab = 'sd')
plot(CV_All, xlab = 'iteration', ylab = 'CV')
plot(Mean_All, xlab = 'iteration', ylab = 'mean')


###############################################################
## Viki's method
## Duration
SD_All1 = c()
CV_All1 = c()
Mean_All1 = c()
j=10

for (i in  1:20000) { 
  Iter1 = c()
    for (l in 1:10) {
    IterS = sample(Sample1, j, replace = T)
    Mn = mean (IterS)
    Iter1 = c(Iter1, Mn)
    }
  CV_Iter1 = sd(Iter1)/mean(Iter1)
  SD_Iter1 = sd(Iter1)
  Mean_Iter1 = mean(Iter1)
  j = j +1
  CV_All1= c(CV_All1, CV_Iter1)
  SD_All1 = c(SD_All1, SD_Iter1)
  Mean_All1 = c(Mean_All1, Mean_Iter1)
}

par(mfrow = c(3,1))
plot(SD_All1, xlab = 'iterations', ylab = 'sd', type = 'l')
plot(CV_All1, xlab = 'iterations', ylab = 'CV', type = 'l')
abline(h= 0.025, col = 'red')
plot(Mean_All1, xlab = 'iterations', ylab = 'mean', type = 'l')

### Rabid dogs
SD_All2 = c()
CV_All2 = c()
Mean_All2 = c()
j=10

for (i in  1:20000) { 
  Iter1 = c()
  for (l in 1:10) {
    IterS = sample(Sample2, j, replace = T)
    Mn = mean (IterS)
    Iter1 = c(Iter1, Mn)
  }
  CV_Iter1 = sd(Iter1)/mean(Iter1)
  SD_Iter1 = sd(Iter1)
  Mean_Iter1 = mean(Iter1)
  j = j +1
  CV_All2 = c(CV_All2, CV_Iter1)
  SD_All2 = c(SD_All2, SD_Iter1)
  Mean_All2 = c(Mean_All2, Mean_Iter1)
}

par(mfrow = c(3,1))
plot(SD_All2, xlab = 'iterations', ylab = 'sd', type = 'l')
plot(CV_All2, xlab = 'iterations', ylab = 'CV', type = 'l')
abline(h= 0.025, col = 'red')
plot(Mean_All2, xlab = 'iterations', ylab = 'mean', type = 'l')

######################
### This finds the proportion of CVs that were < 0.05 or 0.025 in the previous 100 iterations.
# duration
resultsCV5_1 = c()
resultsCV25_1 = c()

for (i in 100:20000){
x = 0
y=0
output = c()
for (j in 1:100) {
  output = c(output, CV_All1[i - x])
  x = x +1
}
z = output < 0.05
a = output < 0.025
resultsCV5_1 = c(resultsCV5_1, length(which(z)[z==TRUE])/100)
resultsCV25_1 = c(resultsCV25_1, length(which(a)[a==TRUE])/100)
}

plot(resultsCV5_1, ylim = c(0, 1), type = "l", ylab = 'Proportion', xlab = 'iteration')
lines(resultsCV25_1, ylim = c(0, 1), type = "l", col = 'red')
abline(h = 0.975)

## Number of rabid dogs
resultsCV5_2 = c()
resultsCV25_2 = c()

for (i in 100:20000){
  x = 0
  y=0
  output = c()
  for (j in 1:100) {
    output = c(output, CV_All2[i - x])
    x = x +1
  }
  z = output < 0.05
  a = output < 0.025
  resultsCV5_2 = c(resultsCV5_2, length(which(z)[z==TRUE])/100)
  resultsCV25_2 = c(resultsCV25_2, length(which(a)[a==TRUE])/100)
}

plot(resultsCV5_2, ylim = c(0, 1), type = "l", ylab = 'Proportion', xlab = 'iteration')
lines(resultsCV25_2, ylim = c(0, 1), type = "l", col = 'red')
abline(h = 0.975)

setwd('C:/Users/viki.brookes/OneDrive/Rabies/Papers/Rabies_Model/Figures/')
tiff("Convergence.tiff", width = 10, height =8, units = 'in', res= 300, compression = "lzw")
par(mfrow = c(2, 2))
plot(CV_All1, xlab = 'iterations', ylab = 'CV', type = 'l', ylim = c(0, 0.4), main = 'Duration, a')
abline(h= 0.025, col = 'red', lwd = 1.5)
plot(CV_All2, xlab = 'iterations', ylab = 'CV', type = 'l', ylim = c(0, 0.4), main = 'Rabid dogs, a')
abline(h= 0.025, col = 'red', lwd = 1.5)
plot(resultsCV25_1, ylim = c(0, 1), type = "l", ylab = 'Proportion', xlab = 'iterations', main = 'Duration, b')
abline(h = 0.975, col = 'red', lwd = 1.5)
plot(resultsCV25_2, ylim = c(0, 1), type = "l", ylab = 'Proportion', xlab = 'iterations', main = 'Rabid dogs, b')
abline(h = 0.975, col = 'red', lwd = 1.5)
dev.off()
jpeg("Convergence.jpg", width = 10, height =8, units = 'in', res= 300)
par(mfrow = c(2, 2))
plot(CV_All1, xlab = 'iterations', ylab = 'CV', type = 'l', ylim = c(0, 0.4), main = 'Duration, a')
abline(h= 0.025, col = 'red', lwd = 1.5)
plot(CV_All2, xlab = 'iterations', ylab = 'CV', type = 'l', ylim = c(0, 0.4), main = 'Rabid dogs, a')
abline(h= 0.025, col = 'red', lwd = 1.5)
plot(resultsCV25_1, ylim = c(0, 1), type = "l", ylab = 'Proportion', xlab = 'iterations', main = 'Duration, b')
abline(h = 0.975, col = 'red', lwd = 1.5)
plot(resultsCV25_2, ylim = c(0, 1), type = "l", ylab = 'Proportion', xlab = 'iterations', main = 'Rabid dogs, b')
abline(h = 0.975, col = 'red', lwd = 1.5)
dev.off()
pdf("Convergence.pdf", width = 10, height = 8)
par(mfrow = c(2, 2))
plot(CV_All1, xlab = 'iterations', ylab = 'CV', type = 'l', ylim = c(0, 0.4), main = 'Duration, a')
abline(h= 0.025, col = 'red', lwd = 1.5)
plot(CV_All2, xlab = 'iterations', ylab = 'CV', type = 'l', ylim = c(0, 0.4), main = 'Rabid dogs, a')
abline(h= 0.025, col = 'red', lwd = 1.5)
plot(resultsCV25_1, ylim = c(0, 1), type = "l", ylab = 'Proportion', xlab = 'iterations', main = 'Duration, b')
abline(h = 0.975, col = 'red', lwd = 1.5)
plot(resultsCV25_2, ylim = c(0, 1), type = "l", ylab = 'Proportion', xlab = 'iterations', main = 'Rabid dogs, b')
abline(h = 0.975, col = 'red', lwd = 1.5)
dev.off()
