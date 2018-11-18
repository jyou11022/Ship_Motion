import numpy as np
import scipy.io
import torch

data1 = scipy.io.loadmat('data1.mat')
data2 = scipy.io.loadmat('data2.mat')
data3 = scipy.io.loadmat('data3.mat')
data4 = scipy.io.loadmat('data4.mat')
data5 = scipy.io.loadmat('data5.mat')

data1 = data1['data1']
data2 = data2['data2']
data3 = data3['data3']
data4 = data4['data4']
data5 = data5['data5']

#x y z Roll Pitch Yaw

data = np.vstack((data1[3,:],data2[3,:],data3[3,:],data4[3,:],data5[3,:]))
torch.save(data, open('traindata.pt', 'wb'))
