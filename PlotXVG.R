library(readr)

# plotdir = "D:/RProjects/Plots/downloads/"
plotdir = "D:/Documents/R/RProjects/Plots/downloads/xvg1/"

files.xvg <- dir(plotdir, pattern =".xvg$")


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
  # graph_values <- data.frame(graph_values)
  # names(graph_values) <- c(graph_meta$xaxis, graph_meta$yaxis)
  # print(graph_values)
  graph_values <- data.frame(graph_values_x, graph_values_y)
  names(graph_values) <- c(graph_meta$xaxis, graph_meta$yaxis)
  # plot(graph_values, type='l')
  jpeg(paste(plotdir, file, '.jpg', sep=''), width = 4, height = 4, units = 'in', res = 300)
  plot(graph_values, type='l')
  title(main = graph_meta$title, sub = graph_meta$subtitle,
      cex.main = 2,   font.main= 4, col.main= "red",
      cex.sub = 0.75, font.sub = 3, col.sub = "red",
      # col.lab ="darkblue"
      )
  dev.off()
}

# files.csv <- dir(plotdir, pattern =".csv$")
# print(files.csv)
# for(i in 1:length(files.csv)){
#   # print(files.csv[i])
#   fn <- files.csv[i]
#   print(paste(plotdir, fn, sep=''))
#   # data_matrix <- read_csv(paste(plotdir, fn, sep=''))
#   # jpeg(paste(plotdir, fn, '.jpg', sep=''))
#   # y <- plot(data_matrix, type='l')
#   # dev.off()
# }
