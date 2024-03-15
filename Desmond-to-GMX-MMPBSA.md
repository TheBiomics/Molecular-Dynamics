
mkdir gmxoutput

/opt/schrodinger2022-1/run trj_convert.py -trj JOBNAME1_trj -output-trajectory-format xtc JOBNAME1.cms ./gmxoutput/gmx

intermol-convert --des_in JOBNAME1-out.cms --gromacs --odir ./gmxoutput/gmx

{echo "1|14"; echo "13"; echo "23"; echo "q"}|gmx make_ndx -f conf.gro -o index.ndx

mx grompp -f md.mdp -o gmx.tpr -c gxm.gro -n index.ndx -p topol.top


