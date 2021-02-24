
import re
import shlex as SH
import matplotlib.pyplot as PLOT
import pandas as PD
import csv as CSV

def graph_plot_xvg_file(filepath):
  file = open(filepath, 'r', encoding='utf-8')
  lines = file.readlines()
  graph_meta = {}
  graph_meta["title"] = 'TITLE_HERE'
  graph_meta["subtitle"] = 'TITLE_HERE'
  graph_meta["xaxis"] = 'XAXIS LABEL'
  graph_meta["yaxis"] = 'YAXIS LABEL'
  graph_meta["type"] = 'YAXIS LABEL'
  graph_values = []

  for line in lines:
    if line[0] == "@":
      # Meta values
      s = SH.split(line)
      if(len(s[0]) > 1 and s[0] == '@TYPE'):
        graph_meta["type"] = s[-1]
      else:
        graph_meta[s[1]] = s[-1]

      # print(s)
      pass
    elif line[0] == '#':
      # ignore
      pass
    else:
      # These are values 
      graph_values.append(line.split())
      pass
  
  # lis = graph_values
  # graph_columns = [a for a in graph_meta["type"]]
  graph_columns = [graph_meta['xaxis'], graph_meta['yaxis']]

  # graph_values = PD.DataFrame(graph_values, columns = graph_columns)
  # graph_values = graph_values.to_dict()

  # print(graph_values)

  with open(f'downloads/values.csv', 'w+', newline='', encoding="utf8")  as output_file:
    write = CSV.writer(output_file) 
    write.writerow(graph_columns) 
    write.writerows(graph_values) 

  # PLOT.plot(
  #       list(graph_values['x']),
  #       list(graph_values['y']),
  #       color='green',
  #       linestyle='solid',
  #       linewidth = 1, 
  #       marker='.',
  #       markerfacecolor='blue',
  #       markersize=1
  #     ) 

  # # naming the x axis 
  # PLOT.xlabel(graph_meta['xaxis']) 
  # # naming the y axis 
  # PLOT.ylabel(graph_meta['yaxis'])

  # # giving a title to my graph 
  # PLOT.title(graph_meta['title'] + ": " + graph_meta['subtitle'])
    
  # PLOT.locator_params(axis='y', nbins=6)
  # PLOT.locator_params(axis='x', nbins=10)
  # # function to show the plot

  # PLOT.show()
  # PLOT.savefig('project/testplot.png')

graph_plot_xvg_file('project/rmsd.xvg')
