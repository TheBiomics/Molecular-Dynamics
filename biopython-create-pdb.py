"""
Creating BioPython PDB using stored coordinates

NOTE: This is not a working example


https://www.cgl.ucsf.edu/chimera/docs/UsersGuide/tutorials/pdbintro.html
Ref: https://biopython.org/docs/1.75/api/Bio.PDB.StructureBuilder.html

"""

from Bio import PDB
from Bio.PDB.PDBIO import PDBIO
import numpy as NP


builder = PDB.StructureBuilder.StructureBuilder()
builder.init_structure("ligand")
builder.init_model(1)
builder.init_chain(1)
builder.init_seg("1")
builder.init_residue("LIG", "", 1, "")
structure = builder.get_structure()

model = [m for m in structure.get_models()][0]
chain = [c for c in model.get_chains()][0]
residue = [r for r in model.get_residues()][0]

# atom_lines = []
atom_lines = ["1    C1        -9.222     4.864     6.718 .....".split()]

for coordinates in atom_lines:
    # print(coordinates[1][0])
    
    if coordinates[1][0].isdigit() and len(coordinates[1][0]) > 1:
      element_name = coordinates[1][1]
      element = coordinates[1][1]
    else:
      element_name = coordinates[1][0]
      element = coordinates[1][0]

    # init_atom(self, name, coord, b_factor, occupancy, altloc, fullname, serial_number=None, element=None)
    atom_list = [a.name for a in residue.get_atoms() if a.name == element_name]

    if element_name in atom_list:
      element_name = f"{element_name}"
    atom = PDB.Atom.Atom(
      f"{element_name}{coordinates[0]}",
      NP.array([coordinates[2], coordinates[3], coordinates[4]]),
      21,
      1,
      " ",
      element,
      serial_number=coordinates[0],
      element=element
    )
    if not element_name in atom_list:
      residue.add(atom)

"""
Ref: https://biopython.org/docs/1.74/api/Bio.PDB.PDBIO.html
"""
io = PDBIO()
io.set_structure(structure)
io.save("<PDB_OUTPUT_LOCATION>.pdb")
