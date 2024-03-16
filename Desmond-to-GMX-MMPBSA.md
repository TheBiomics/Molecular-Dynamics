# Installation
* `pip install git+https://github.com/shirtsgroup/InterMol.git`
* 


# Commands



```sh
mkdir GMXOut

$SCHRODINGER/run trj_convert.py -trj PROJ_trj -output-trajectory-format xtc PROJ.cms ./GMXOut/gmx

intermol-convert --des_in PROJ.cms --gromacs --odir ./GMXOut

cd GMXOut

{ echo "1|14"; echo "13"; echo "23"; echo "q"; }|gmx make_ndx -f gmx.gro -o index.ndx

gmx grompp -f md.mdp -o gmx.tpr -c gmx.gro -n index.ndx -p gmx.top -maxwarn 1


gmx_MMPBSA -O -i mmpbsa.in -cs gmx.tpr -ci index.ndx -cg 1 13 -ct gmx.xtc -cp gmx.top -nogui
```
