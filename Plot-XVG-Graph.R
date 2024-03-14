library(readr)

"
Features:

Plot Graphs From XVG File
Change pattern to draw in a folder or in all subdirectories
Transparent PNG Files
Multiple lines if more than one columns are present
Different Line Colors for visibility
Adds Legends
Adds Title and Subtitle to the graph


source('/mnt/DataDrive/RProjects/MDD/analysis/xvg-plot-manual.R')

"

#
# @TODO:
# Add file name as susbtitle for better description
# Other options?
# 
# Prompt User to paste the directory to generate graphs in
# n1<-readline(prompt="Enter skip 1: " )
# n1<-as.integer(n1)

time.stamp = format(Sys.time(), "%Y-%m-%d-%H-%M") # nolint

# plotdir <- readline(prompt="Directory To Process")

plotdir <- "/path/to/directory/with/xvg/files"

# files.xvg <- list.files(path= plotdir, pattern = "*/*.xvg$", recursive = TRUE, full.names = TRUE)
files.xvg <- list.files(path= plotdir, pattern = "*.xvg$", recursive = TRUE, full.names = TRUE)

line_colors <- c("darkred", "#0202ab", "orange", "darkgreen", "black", 'red', 'green')

# https://sites.harding.edu/fmccown/r/

# windows.options(width=10, height=10)
# print(files.xvg)

details <- c()
details <- c(details, c(paste("File Name", "Line Description", "Mean Value", "Standard Deviation", sep="\t")))
details <- c(details, c(paste("==========", "===============", "==========", "==================", sep="\t")))
for(i in 1:length(files.xvg)){
  file <- files.xvg[i]
  if(is.na(file)) {
    next
  }

  file.readablename <- unlist(strsplit(file, '/'))
  file.dirname <- file.readablename[length(file.readablename) - 1]
  file.subdirname <- file.readablename[length(file.readablename) - 2]
  # file.dirname <- unlist(strsplit(file.readablename, '-', fixed = TRUE))
  # file.dirname <- head(file.dirname, -1)
  file.readablename <- file.readablename[length(file.readablename)]
  file.readablename <- unlist(strsplit(file.readablename, '.', fixed = TRUE))
  file.readablename <- head(file.readablename, -1)
  file.readablename <- gsub("--", ": ", file.readablename)
  file.readablename <- gsub("-", " ", file.readablename)

  details <- c(details, c(paste(file.readablename, "(", file.subdirname, ") ")))
  print(paste("==== Generating Graph for: ", file.subdirname, file.dirname, file.readablename, " ==============="))
  # fileLines <- readLines(paste(plotdir, file, sep=''))
  fileLines <- readLines(paste(file))
  graph_meta <- list()
  graph_meta['subtitle'] <- file.readablename
  graph_matrix_raw <- c()
  graph_values_x <- c()
  graph_values_y <- c()
  graph_column_count <- 0
  graph_legends <- c()
  graph_legends_col_count <- 0

  for(i in 1:length(fileLines)){
    line <- fileLines[i]
    # print(line)
    # print(first_char)
    dum = scan(text=line, what='character', quiet=TRUE)
    first_char = substr(trimws(line), 1, 1)

    if(!is.na(as.numeric(first_char))) {
      # Remaining are the values
      v <- scan(text=line, what='character', quiet=TRUE)
      if(!graph_column_count) {
        graph_column_count = length(v)
      }
      graph_matrix_raw <- c(graph_matrix_raw, v)
      graph_values_x <- c(graph_values_x, v[1])
      graph_values_y <- c(graph_values_y, v[2])

    }else{
      if(grepl("legend", line, fixed=TRUE)){
        if(grepl("@ legend", line, fixed=TRUE)) {
          # it is setting for legend
        }else{
          leg.v <- scan(text=line, what='character', quiet=TRUE)
          leg.s <- gsub("\\\\S", "^", leg.v)
          leg.s <- gsub("\\\\s", "_", leg.s)
          leg.s <- gsub("\\\\N", " ", leg.s)
          graph_legends <- c(graph_legends, leg.s)
          graph_legends_col_count = length(leg.v)
          # it is title for the legend
        }
      } else if(first_char == '@'){
        line <- scan(text=line, what='character', quiet=TRUE)
        indx <- line[2]
        if(length(line[0]) > 1 && line[0] == '@TYPE'){
          indx <- 'type'
        }
        labelclean <- gsub("\\\\S", "^", line[length(line)])
        labelclean <- gsub("\\\\s", "_", labelclean)
        labelclean <- gsub("\\\\N", " ", labelclean)
        graph_meta[[indx]] <- labelclean
      }else if(first_char == "#"){
        # Ignore comments
      }
    }
  }

  if(is.null(graph_legends) || graph_legends_col_count < 1){
    graph_legends <- c("@", graph_meta$yaxis)
    graph_legends_col_count = 2
  }

  graph_legends <- matrix(graph_legends, graph_legends_col_count)
  graph_legends <- c(graph_legends[nrow(graph_legends),])
  # graph_legends <- c(graph_meta$xaxis, c(graph_legends))

  graph_matrix_raw <- matrix(data=graph_matrix_raw, ncol = graph_column_count, byrow = TRUE)
  class(graph_matrix_raw) <- "numeric"
  colnames(graph_matrix_raw) <- c(graph_meta$xaxis, c(graph_legends))
  colnames(graph_matrix_raw)[1] <- graph_meta$xaxis
  colnames(graph_matrix_raw)[2] <- graph_meta$yaxis

  graph_values <- data.frame(graph_matrix_raw[, 1], graph_matrix_raw[, 2])
  names(graph_values) <- c(graph_meta$xaxis, graph_meta$yaxis)

  par(bg = NA, mar = c(5.1, 4.5, 5.8, 3), xpd = F)

  # plot(c(graph_matrix_raw[,1]), c(graph_matrix_raw[,2]), xlab= graph_meta$xaxis, ylab= graph_meta$yaxis, type='l', xlim=c(0, graph_x_max), ylim=c(0, graph_y_max))

  plot(
    c(graph_matrix_raw[, 1]),
    c(graph_matrix_raw[, 2]),
    xlab = graph_meta$xaxis,
    ylab = graph_meta$yaxis,
    ylim = c(min(graph_matrix_raw[, -1]), max(graph_matrix_raw[, -1])),
    type = "l",
    col = line_colors[1]
  )

  line_columns <- as.matrix(graph_matrix_raw[, -1, drop=FALSE])

  col_index <- 0
  for(i in colnames(line_columns)) {
    col_index <- col_index + 1
    lines(graph_matrix_raw[, 1], line_columns[, col_index], type = "l", col = line_colors[col_index])
    colm.mean = mean(line_columns[, col_index])
    colm.sd = sd(line_columns[, col_index])
    details <- c(details, c(paste("Line", paste(i, graph_meta$yaxis, sep=""), colm.mean, colm.sd, sep="\t")))
    abline(h=colm.mean, lty="dashed", col = line_colors[col_index])
    abline(h=(colm.mean + colm.sd), lty="dotted", lwd=1, col = line_colors[col_index])
    abline(h=(colm.mean - colm.sd), lty="dotted", lwd=1, col = line_colors[col_index])
  }

  legend_position <- (length(graph_legends) / 20)

  legend(
    "topright", 
    legend = graph_legends,
    col = line_colors,
    lty = 1,
    inset = c(0, -(legend_position)),
    cex = 0.6,
    xpd = TRUE
  )

  # title(main = graph_meta$title, sub = graph_meta$subtitle,
  #     cex.main = 2,   font.main= 4, col.main= line_colors[1],
  #     cex.sub = 0.75, font.sub = 3, col.sub = line_colors[3],
  #     col.lab = line_colors[3]
  #     )
  
  mtext(side=3, line=1.5, at=-0.07, adj=0, cex=1, graph_meta$title, col=line_colors[1])
  mtext(side=3, line=0.5, at=-0.07, adj=0, cex=0.7, graph_meta$subtitle, col.sub = line_colors[3])

  dev.copy(png, paste(file, '.png', sep=''), width = 11, height = 8.5, units = 'in', res = 300)
  dev.off()

}

write.table(details, file = paste(plotdir, "/details-", time.stamp, ".txt", sep=""), row.names = FALSE, quote=FALSE)
