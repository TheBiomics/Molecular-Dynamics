# Installing Desmond on Google Colab
  * You should posses Desmond license (academic trial license if you are a student, or other appropriate license)

## Steps
* Copy desmond `desmond.tar.gz` file to google drive
* Extract 
* Install


### Installation Notebook Code
It takes around 15 minutes to install Desmond on google colab.

```py
import time as TIME
import os
os.environ["USER"] = "root"

start_time = TIME.time()

# Adapt to this code to extract the tar gzipped file according to your file type
!tar xvf /content/drive/MyDrive/Desmond_Maestro_2021.1.tar --directory /content


%cd /content/Desmond_Maestro_2021.1
%ls

print(f"Extracted in %s" % (TIME.time() - start_time))

start_time = TIME.time()
!pwd
!{ echo -ne "\n"; wait; echo -ne "\n"; wait; echo -ne "y\n"; wait; echo -ne "y\n"; wait; echo -ne "\n"; wait; echo -ne "y\n"; wait; echo -ne "\n"; wait; echo -ne "y\n"; wait; echo -ne "n\n"; wait;  echo -ne "n\n"; wait;  echo -ne "n\n"; wait;  echo -ne "n\n"; wait; }|./INSTALL

print(f"Installed in %s" % (TIME.time() - start_time))

```

## Example command
Refer to [Desmond documentation](http://gohom.win/ManualHom/Schrodinger/Schrodinger_2012_docs/desmond/desmond_user_manual.pdf) for better understanding.
```py
!/opt/schrodinger2021-1/utilities/multisim <YOUR COMMAND>
!/opt/schrodinger2021-1/desmond <YOUR COMMAND>
```
