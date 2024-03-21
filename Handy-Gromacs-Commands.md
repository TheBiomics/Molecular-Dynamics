# Get protein.pdb - Exclude HETATM and ANISOU records
### Convert lig.pdbqt to lig.mol2 using UCSF Chimera - AddH to add hydrogen under structure editing
### Follow https://www.swissparam.ch/SwissParam_gromacs_tutorial.html

```
!export path_to_gmx = /usr/local/gromacs/bin/gmx

!/usr/local/gromacs/bin/gmx pdb2gmx -f protein.pdb -water tip3p -ignh -o conf.pdb -nochargegrp
```
### Merge the protein and ligand coordinates. Insert the ATOM lines from the ligand.pdb into the conf.pdb file after the ter record. Atoms will be automatically renumbered in the next step.
```
!/usr/local/gromacs/bin/gmx editconf -f complex.pdb -o boxed.pdb -c -d 1.2 -bt octahedron
```
### add ligand topology to the topol.top earliest before [moleculetype] records and add lig to [molecules] record
```
!/usr/local/gromacs/bin/gmx solvate -cp boxed.pdb -cs spc216.gro -p topol.top -o solv.gro --quiet
```
### Moved to google colab

### Energy Minimisation
```
!/usr/local/gromacs/bin/gmx grompp -f ions.mdp -c solv.gro -p topol.top -o ions.tpr --quiet
```
!/usr/local/gromacs/bin/gmx genion -s ions.tpr -o solv_ions.gro -neutral -p topol.top --quiet

### Select 15 SOL to add ions to
```
!/usr/local/gromacs/bin/gmx grompp -f em.mdp -c solv_ions.gro -p topol.top -o em.tpr --quiet

!/usr/local/gromacs/bin/gmx mdrun -v -deffnm em --quiet
```
###  NVT

!/usr/local/gromacs/bin/gmx make_ndx -f em.gro -o index.ndx --quiet

!/usr/local/gromacs/bin/gmx grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -n index.ndx -o nvt.tpr --quiet

!/usr/local/gromacs/bin/gmx mdrun -deffnm nvt -v --quiet

###  NPT

!/usr/local/gromacs/bin/gmx grompp -f npt.mdp -c nvt.gro -t nvt.cpt -r nvt.gro -p topol.top -n index.ndx -o npt.tpr --quiet
!/usr/local/gromacs/bin/gmx mdrun -deffnm npt -v --quiet

###  Final Run
```
!/usr/local/gromacs/bin/gmx grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -n index.ndx -o md_dpmc_final.tpr --quiet
!/usr/local/gromacs/bin/gmx mdrun -deffnm md_dpmc_final -nb gpu -maxh 20 -v --quiet
```
# Resume the run
# if path.exists('md_dpmc_final.tpr'):
#   !/usr/local/gromacs/bin/gmx mdrun -deffnm md_dpmc_final -cpi md_dpmc_final -maxh 20 -v --quiet -nb gpu
#   For checksum error occurred use -noappend option 
#   !/usr/local/gromacs/bin/gmx mdrun -deffnm md_dpmc_final -cpi md_dpmc_final -maxh 20 -noappend -v --quiet -nb gpu

- Merging multiple trajectories-


- Analysis

press 0 for corrected trajectory


select 4 for both least square & rmsd

g_gyrate -s md_0_1.tpr -f md_0_1_noPBC.xtc -o gyrate.xvg  

g_rmsf -s md_0_1.tpr -f md_0_1_noPBC.xtc -o rmsf.xvg -res

g_sas -f md_0_1_noPBC.xtc -s md_0_1.tpr -o sas2.xvg -oa atomic2-sas.xvg -or residue2-sas.xvg 
g_hbond -f md_0_1_noPBC.xtc -s md_0_1.tpr -num hydrogen2-bond-intra-protein.xvg
g_hbond -f md_0_1_noPBC.xtc -s md_0_1.tpr -num hydrogen2-bond-protein-water.xvg

Local Analysis
1) 1D5R91-131
make_ndx -f md_0_1.tpr -o 1D5R91-131Local.ndx
g_rms -s md_0_1.tpr -f md_0_1_noPBC.xtc -n 1D5R91-131Local.ndx -o 1D5R91-131Rrmsd.xvg -tu ns
g_gyrate -s md_0_1.tpr -f md_0_1_noPBC.xtc -n 1D5R91-131Local.ndx -o 1D5R91-131gyrate.xvg 
g_rmsf -s md_0_1.tpr -f md_0_1_noPBC.xtc -n 1D5R91-131Local.ndx -o 1D5R91-131rmsf.xvg -res
g_sas -f md_0_1_noPBC.xtc -s md_0_1.tpr -n 1D5R91-131Local.ndx -o 1D5R91-131sas.xvg -oa 1D5R91-131atomic-sas.xvg -or 1D5R91-131residue-sas.xvg 
g_hbond -f md_0_1_noPBC.xtc -s md_0_1.tpr -n 1D5R91-131Local.ndx -num 1D5R91-131hydrogen1-bond-intra-protein.xvg

2)1D5R104-144
g_rms -s md_0_1.tpr -f md_0_1_noPBC.xtc -n 1D5R104-144Local.ndx -o 1D5R104-144rmsd.xvg -tu ns
g_gyrate -s md_0_1.tpr -f md_0_1_noPBC.xtc -n 1D5R104-144Local.ndx -o 1D5R104-144gyrate.xvg 
g_rmsf -s md_0_1.tpr -f md_0_1_noPBC.xtc -n 1D5R104-144Local.ndx -o 1D5R104-144rmsf.xvg -res
g_sas -f md_0_1_noPBC.xtc -s md_0_1.tpr -n 1D5R104-144Local.ndx -o 1D5R104-144sas.xvg -oa 11D5R104-144atomic-sas.xvg -or 1D5R104-144residue-sas.xvg 
g_hbond -f md_0_1_noPBC.xtc -s md_0_1.tpr -n 1D5R104-144Local.ndx -num 1D5R104-144hydrogen1-bond-intra-protein.xvg

3)1D5R107-147
make_ndx -f md_0_1.tpr -o 1D5R107-147Local.ndx
g_rms -s md_0_1.tpr -f md_0_1_noPBC.xtc -n 1D5R107-147Local.ndx -o 1D5R107-147rmsd.xvg -tu ns
g_gyrate -s md_0_1.tpr -f md_0_1_noPBC.xtc -n 1D5R107-147Local.ndx -o 1D5R107-147gyrate.xvg 
g_rmsf -s md_0_1.tpr -f md_0_1_noPBC.xtc -n 1D5R107-147Local.ndx -o 11D5R107-147rmsf.xvg -res
g_sas -f md_0_1_noPBC.xtc -s md_0_1.tpr -n 1D5R107-147Local.ndx -o 1D5R107-147sas.xvg -oa 1D5R107-147atomic-sas.xvg -or 1D5R107-147residue-sas.xvg 
g_hbond -f md_0_1_noPBC.xtc -s md_0_1.tpr -n 1D5R107-147Local.ndx -num 1D5R107-147hydrogen1-bond-intra-protein.xvg

PCA Analysis
g_covar -f md_0_1_noPBC.xtc -s md_0_1.tpr -o eigenval.xvg  -v eigenvec.trr -av average.pdb -xpm covar.xpm -xpma covara.xpm
g_anaeig -s ref.pdb -f md1_backbone.xtc  -v eigenvec.trr -extr extreme1.pdb -first 1 -last 1 -nframes 30
g_anaeig -s ref.pdb -f md1_backbone.xtc -2d -first 1 -last 2

g_anaeig -s md_0_1.tpr -f md_0_1_noPBC.xtc -v eigenvec.trr -eig eigenval.xvg -proj proj.xvg  -2d 2dproj.xvg -extr extreme1.pdb -first 1 -last 2 -nframes 30

g_covar -f md_I738V.xtc -s md_I738V.tpr -av average.pdb -o eigenval.xvg -l covar.log 


==========================================
export PS1="..Y3$ "

# Concatenate all the trajectories
gmx trjcat -f md_y3_f*.xtc -o final.xtc 

# Center the system (Select 0)
gmx trjconv -s md_dpmc_final.tpr -f md_dpmc_final.xtc -o md_dpmc_final_nopbc.xtc -pbc mol -ur compact

# RMS 3-3/3-19
gmx rms -s md_dpmc_final.tpr -f md_dpmc_final_nopbc.xtc -o rmsd-ca-lig.xvg -tu ns
gmx rms -s md_dpmc_final.tpr -f md_dpmc_final_nopbc.xtc -o rmsd-ca-ca.xvg -tu ns

gmx gyrate -s md_dpmc_final.tpr -f md_dpmc_final_nopbc.xtc -o gyrate.xvg
# Selected protein
gmx rmsf -s md_dpmc_final.tpr -f md_dpmc_final_nopbc.xtc -o rmsf-protein.xvg -res
gmx rmsf -s md_dpmc_final.tpr -f md_dpmc_final_nopbc.xtc -o rmsf-lig.xvg -res
gmx rmsf -s md_dpmc_final.tpr -f md_dpmc_final_nopbc.xtc -o rmsf-system.xvg -res

# Ramachandran Plot
gmx rama -f md_dpmc_final_nopbc.xtc -s md_dpmc_final.tpr -o ramachandran.xvg

# HydrogenBonds - Internal and External
gmx hbond -f md_dpmc_final_nopbc.xtc -s md_dpmc_final.tpr -num h-intra-protein.xvg
gmx hbond -f md_dpmc_final_nopbc.xtc -s md_dpmc_final.tpr -num h-inter-protein-lig.xvg

