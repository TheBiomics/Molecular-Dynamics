
mkdir GMXout

/opt/schrodinger2022-1/run trj_convert.py -trj JOBNAME1_trj -output-trajectory-format xtc JOBNAME1.cms ./GMXout/gmx

intermol-convert --des_in JOBNAME1-out.cms --gromacs --odir ./GMXout

{echo "1|14"; echo "13"; echo "23"; echo "q"}|gmx make_ndx -f conf.gro -o index.ndx

mx grompp -f md.mdp -o gmx.tpr -c gxm.gro -n index.ndx -p topol.top


gmxMMPBSA -O -i {_PROJ_DIR}/mmpbsa.in -prefix {_PROJ} -cs {_dir}/gmx.tpr -ci {_dir}/index.ndx -cg {_atom_group_selection} -ct {_dir}/gmx.xtc -cp {_dir}/topol.top -eo {_PROJ_DIR}/{_PROJ}.eo.csv -deo {_PROJ_DIR}/{_PROJ}.deo.csv -xvvfile {_PROJ_DIR}/{_PROJ}.results.xvv -nogui

gmx_MMPBSA -O -i mmpbsa.in -cs gmx.tpr -ci index.ndx -cg 1 13 -ct gmx.xtc -cp topol.top -nogui
