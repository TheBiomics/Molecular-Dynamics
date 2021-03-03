library(readr)

# Plot Graphs From XVG File
# @TODO:
# Add file name as susbtitle for better description
# Change Line Color for Better Visibility
# Other options?
# Styling graphs to look good


# Prompt User to paste the directory to generate graphs in
# n1<-readline(prompt="Enter skip 1: " )
# n1<-as.integer(n1)


plotdir = "/path/to/xvg/file/directory/"

# https://sites.harding.edu/fmccown/r/

files.xvg <- dir(plotdir, pattern =".xvg$")

# windows.options(width=10, height=10)

for(i in 1:length(files.xvg)){
  file <- files.xvg[i]
  fileLines <- readLines(paste(plotdir, file, sep=''))
  graph_meta = list()
  graph_values_x = c()
  graph_values_y = c()
  for(i in 1:length(fileLines)){
    line <- fileLines[i]
    # print(line)
    # print(substr(line, 1, 1))
    if(substr(line, 1, 1) == '@'){
      line <- scan(text=line, what='character', quiet=TRUE)
      indx <- line[2]
      if(length(line[0]) > 1 && line[0] == '@TYPE'){
        indx <- 'type'
      }
      graph_meta[[indx]] <- line[length(line)]
    }else if(substr(line, 1, 1) == '#'){
      # Ignore the real Comments
    }else{
      # Remaining are the values
      v <- scan(text=line, what='character', quiet=TRUE)
      # graph_values <- c(graph_values, list(v))
      graph_values_x <- c(graph_values_x, v[1])
      graph_values_y <- c(graph_values_y, v[2])
    }
  }
  graph_values <- data.frame(graph_values_x, graph_values_y)
  # par(mar = c(4,4,4,4))
  names(graph_values) <- c(graph_meta$xaxis, graph_meta$yaxis)
  jpeg(paste(plotdir, file, '.jpg', sep=''), width = 11, height = 8.5, units = 'in', res = 300)
  plot(graph_values, type='l')
  title(main = graph_meta$title, sub = graph_meta$subtitle,
      cex.main = 2,   font.main= 4, col.main= "red",
      cex.sub = 0.75, font.sub = 3, col.sub = "red",
      # col.lab ="darkblue"
      )
  dev.off()
}
