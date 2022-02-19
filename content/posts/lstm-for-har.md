---
title: "LSTM for Human Activity Recognition classification"
author: Andreas Lien
date: 2022-02-19T12:22:06+01:00
draft: false
toc: false
images:
tags:
  - LSTM
  - Deep learning
  - HAR
  - AI
  - Machine learning
  - Neural network
---
The approach and results of identifying the most accurate collection of attributes from data acquired by embedded smartphone sensors to detect five different daily activities. In this project, we are using a LSTM feature extraction approach with 784 features to distinguish standing, sitting, walking, walking upstairs and downstairs. This approach is getting an accuracy of 92.4% and F1-score of 92.46% as an average for test, train, and validation from the data set created.

## Transform the data

The 3-axis raw signals tAcc-XYZ and tGyro-XYZ from the accelerometer and gyroscope were used to create this data set. At a constant rate of 50 Hz, the time domain signals (prefix 't' to signify time) were collected. To reduce noise, they were filtered with a median filter and a 3rd order low pass Butterworth filter with a 20 Hz corner frequency. Using a low pass Butterworth filter with a corner frequency of 0.3 Hz, the acceleration signal was split into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ).

The 3-axis signals tAcc-XYZ and tGyro-XYZ depicted in Figure 1 and 2 are the raw data from the accelerometer and gyroscope.

{{< image src="/media/lstm/raw_acceleration.png" alt="Image showing the raw acceleration data"
attrlink="https://github.com/DiFronzo/LSTM-for-Human-Activity-Recognition-classification"
caption="Figure 1: Plot of raw acceleration data (50Hz) within 128 readings (2.56 sec)." attr="Andreas Lien, CC0"
>}}

{{< image src="/media/lstm/raw_gyroscope.png" alt="Image showing the raw gyroscope data"
attrlink="https://github.com/DiFronzo/LSTM-for-Human-Activity-Recognition-classification"
caption="Figure 2: Plot of raw gyroscope data (50Hz) within 128 readings (2.56 sec)." attr="Andreas Lien, CC0"
>}}

To reduce noise, it where filtered with a median filter, as shown in Figures 3 and 4, and a 3rd order low pass Butterworth filter with a 20 Hz corner frequency, like shown in Figures 5 and 6. In both acceleration and gyroscope data, a median filter with a filter length of 5 was employed.

{{< image src="/media/lstm/median_acceleration.png" alt="Image showing the median acceleration data"
attrlink="https://github.com/DiFronzo/LSTM-for-Human-Activity-Recognition-classification"
caption="Figure 3: Plot acceleration data every 128 readings (2.56 sec) with median filter." attr="Andreas Lien, CC0"
>}}

{{< image src="/media/lstm/median_gyroscope.png" alt="Image showing the median gyroscope data"
attrlink="https://github.com/DiFronzo/LSTM-for-Human-Activity-Recognition-classification"
caption="Figure 4: Plot of raw gyroscope data (50Hz) every 128 readings (2.56 sec) with median filter." attr="Andreas Lien, CC0"
>}}

{{< image src="/media/lstm/median_butterworth_acceleration.png" alt="Image showing the median butterworth acceleration data"
attrlink="https://github.com/DiFronzo/LSTM-for-Human-Activity-Recognition-classification"
caption="Figure 5: Plot acceleration data within 128 readings (2.56 sec) with median filter and Butterworth filter." attr="Andreas Lien, CC0"
>}}

{{< image src="/media/lstm/median_butterworth_gyroscope.png" alt="Image showing the median butterworth gyroscope data"
attrlink="https://github.com/DiFronzo/LSTM-for-Human-Activity-Recognition-classification"
caption="Figure 6: Plot gyroscope data within 128 readings (2.56 sec) with median filter and Butterworth filter." attr="Andreas Lien, CC0"
>}}

Another low pass Butterworth filter with a corner frequency of 0.3 Hz was used to split the acceleration signal into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ), like shown in Figures 8 and 7. And separating acceleration signal into body and gravity acceleration signals by each window, like shown in Figure 9.


{{< image src="/media/lstm/separate_acceleration.png" alt="Image showing the gravity acceleration data"
attrlink="https://github.com/DiFronzo/LSTM-for-Human-Activity-Recognition-classification"
caption="Figure 7: Plot gravity acceleration data within 128 readings (2.56 sec) with median filter and Butterworth filter." attr="Andreas Lien, CC0"
>}}


{{< image src="/media/lstm/separate_acceleration_body.png" alt="Image showing the body acceleration data"
attrlink="https://github.com/DiFronzo/LSTM-for-Human-Activity-Recognition-classification"
caption="Figure 8: Plot body acceleration data within 128 readings (2.56 sec) with median filter and Butterworth filter." attr="Andreas Lien, CC0"
>}}


{{< image src="/media/lstm/separate_acceleration_window_gravity.png" alt="Image showing the gravity acceleration data"
attrlink="https://github.com/DiFronzo/LSTM-for-Human-Activity-Recognition-classification"
caption="Figure 9: Plot gravity acceleration window data within 128 readings (2.56 sec) with median filter and Butterworth filter." attr="Andreas Lien, CC0"
>}}

To acquire Jerk signals, the body linear acceleration and angular velocity were calculated in time (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ), as shown in Figure 10 and 11.

{{< image src="/media/lstm/acceleration_jerk.png" alt="Image showing the acceleration Jerk signals"
attrlink="https://github.com/DiFronzo/LSTM-for-Human-Activity-Recognition-classification"
caption="Figure 10: Plot acceleration Jerk signals." attr="Andreas Lien, CC0"
>}}

{{< image src="/media/lstm/angular_velocity_jerk.png" alt="Image showing the angular velocity Jerk signals"
attrlink="https://github.com/DiFronzo/LSTM-for-Human-Activity-Recognition-classification"
caption="Figure 11: Plot angular velocity Jerk signals." attr="Andreas Lien, CC0"
>}}

Lastly a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag, as shown in Figure 12. The 'f' is to indicate frequency domain signals. 

{{< image src="/media/lstm/fft.png" alt="Image showing the acceleration with hamming"
attrlink="https://github.com/DiFronzo/LSTM-for-Human-Activity-Recognition-classification"
caption="Figure 12: Plot acceleration with hamming." attr="Andreas Lien, CC0"
>}}

See [DiFronzo/LSTM-for-Human-Activity-Recognition-classification](https://github.com/DiFronzo/LSTM-for-Human-Activity-Recognition-classification) for access to the repository with all the data.