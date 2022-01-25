"""
Temporary converter for .lig extension structures to PDB as there are no program directly available to read lig file
Without using biopython
"""

def frame_pdb_atom_hetatm_record_line(**kwargs):
  """
  Method to frame PDB ATOM/HETATM Record
  Formats atom information according to
  http://www.wwpdb.org/documentation/file-format-content/format33/sect9.html#ATOM
  """
  records_attrinutes = {
    "type": kwargs.get("type") , # 6
    "serial": kwargs.get("serial") , # 5
    "name": kwargs.get("name") , # 4
    "altloc": kwargs.get("altloc") , # 1
    "resname": kwargs.get("resname") , # 3
    "chainid": kwargs.get("chainid") , # 1
    "resseq": kwargs.get("resseq") , # 4
    "icode": kwargs.get("icode") , # 1
    "x": kwargs.get("x") , # 8
    "y": kwargs.get("y") , # 8
    "z": kwargs.get("z") , # 8
    "occupancy": kwargs.get("occupancy") , # 6
    "tempfactor": kwargs.get("tempfactor") , # 6
    "element": kwargs.get("element") , # 2
    "charge": kwargs.get("charge") , # 2
  }

  records_attrinutes["type"] = str(records_attrinutes["type"])[:6]
  records_attrinutes["serial"] = str(records_attrinutes["serial"])[:5]
  records_attrinutes["name"] = str(records_attrinutes["name"])[:3]
  records_attrinutes["altloc"] = str(records_attrinutes["altloc"])[0]
  records_attrinutes["resname"] = str(records_attrinutes["resname"])[:3]
  records_attrinutes["chainid"] = str(records_attrinutes["chainid"])[0]
  records_attrinutes["resseq"] = str(records_attrinutes["resseq"])[:4]
  records_attrinutes["icode"] = str(records_attrinutes["icode"])[0]
  records_attrinutes["x"] = float(records_attrinutes["x"])
  records_attrinutes["y"] = float(records_attrinutes["y"])
  records_attrinutes["z"] = float(records_attrinutes["z"])
  records_attrinutes["occupancy"] = float(records_attrinutes["occupancy"])
  records_attrinutes["tempfactor"] = float(records_attrinutes["tempfactor"])
  records_attrinutes["element"] = str(records_attrinutes["element"])[:2]
  records_attrinutes["charge"] = str(records_attrinutes["charge"])[:2]
  records_attrinutes["ten_space"] = " " * 10
  
  return "{type:<6}{serial:>5} {name:<3}{altloc}{resname:>3} {chainid}{resseq:>4}{icode}   {x:8.3f}{y:8.3f}{y:8.3f}{occupancy:6.2f}{tempfactor:6.2f}{ten_space}{element:>2}{charge:>2}\n".format(**records_attrinutes)

# Read <file_name>.lig file
with open("<LIG_FILE_PATH>") as f:
  file = f.readlines()

atom_lines = []

for line in file:
  if line[0].isdigit():
    coordinates = line.split()
    if coordinates[1][0].isdigit() and len(coordinates[1][0]) > 1:
      element_name = coordinates[1][1]
      element = coordinates[1][1]
    else:
      element_name = coordinates[1][0]
      element = coordinates[1][0]
    
    args = {
      "type": "ATOM", # 6
      "serial": coordinates[0], # 5
      "name": f"{element_name}{coordinates[0]}", # 4
      "altloc": " ", # 1
      "resname": "LIG", # 3
      "chainid": "A", # 1
      "resseq": 1, # 4
      "icode": " ", # 1
      "x": float(coordinates[2]), # 8
      "y": float(coordinates[3]), # 8
      "z": float(coordinates[4]), # 8
      "occupancy": 1.0, # 6
      "tempfactor": 21, # 6
      "element": element, # 2
      "charge": " ", # 2
    }
    
    atom_lines.append(frame_pdb_atom_hetatm_record_line(**args))
  if line.startswith("<BOND>"):
    break

# Write <file_name>.lig file
with open("<PDB_OUTPUT_PATH>", "w+") as f:
  f.writelines(atom_lines)
  
  
 
