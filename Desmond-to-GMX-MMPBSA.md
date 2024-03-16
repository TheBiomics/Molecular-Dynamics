# Installation
* `pip install git+https://github.com/shirtsgroup/InterMol.git`
* 


# Commands




mkdir GMXout

/opt/schrodinger2022-1/run trj_convert.py -trj JOBNAME1_trj -output-trajectory-format xtc JOBNAME1.cms ./GMXout/gmx

intermol-convert --des_in JOBNAME1-out.cms --gromacs --odir ./GMXout

cd GMXout

{ echo "1|14"; echo "13"; echo "23"; echo "q"; }|gmx make_ndx -f conf.gro -o index.ndx

gmx grompp -f md.mdp -o gmx.tpr -c gmx.gro -n index.ndx -p gmx.top

gmx_MMPBSA -O -i mmpbsa.in -cs gmx.tpr -ci index.ndx -cg 1 13 -ct gmx.xtc -cp gmx.top -nogui
