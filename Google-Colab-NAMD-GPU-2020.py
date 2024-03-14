!ls

%cd /content/drive/MyDrive/NAMD/

"""
URLs may required to change or you many need to acquire working URL
No Simulation Example is Included

"""


import os.path
from os import path

""" Download and Install NAMD """
# if path.exists('NAMD_Git-2021-01-21_Linux-x86_64-multicore-CUDA.tar.gz'):
#  print('NAMD already downloaded')
# else:
#  !wget https://www.ks.uiuc.edu/Research/namd/cvs/download/741376/NAMD_Git-2021-01-21_Linux-x86_64-multicore-CUDA.tar.gz
#  !tar xfz NAMD_Git-2021-01-21_Linux-x86_64-multicore-CUDA.tar.gz


""" Install CUDA (Internet Installation) """

!wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
!mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
!apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
!add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
!apt-get update
!apt-get -y install cuda

""" Confirm CUDA Libraries """
!dpkg -l | grep cuda

if path.exists('/content/drive/MyDrive/NAMD/namd/namd2'):
  print('NAMD already downloaded')

""" Run NAMD Fir First Time """
!/content/drive/MyDrive/NAMD/namd/namd2
