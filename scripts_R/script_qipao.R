#rewrite the script of ggplot2 bubble chart, under the guide of Gemini, in order to save it in github.
#replace the original file path for general use, so anyone can just run it with only the parameter change.
#add a signal for program's successfully running.
#Command could be: "Rscript script_qipao.R -i pathwayThiamine_v2.csv -o pathwayThiamine_v2.png -H 8000 -W 6000 -res 900"
#create time: 20260319, YXiao. Add stringr and debug on 20260320.

library(optparse)
library(ggplot2)
library(stringr)

#define user input parameters
#a input screen. input “-i data.csv”/"-input data.csv" to specify the input file. Other parameters are like the same.

option_list <- list(
    make_option(c("-i", "--input"), type = "character", help = "csv file input file path"),
    make_option(c("-o", "--output"), type = "character", default = "output.png", help = "name of output image"),
    make_option(c("-H", "--height"), type = "integer", default = "8000", help = "height"),
    make_option(c("-W", "--width"), type = "integer", default = "6000", help = "width"),
    make_option(c("-R", "--res"), type = "integer", default = "900", help = "resolution")
)

#got what user input and save them into the variable “opt”.
opt <- parse_args(OptionParser(option_list=option_list))

data=read.csv(opt$input)

#transfer Y_axis for factor, in order to fix the sequence of pathways on the Y_axis
#use str_wrap() from the "stringr" function to do this, and auto-line-change too.
yz_data=data[,1]
data$pathway <- factor(data$pathway, level = yz_data)

png(opt$output, width = opt$width, height = opt$height, res = opt$res)
ggplot(data, aes(x=UpRatio, y=pathway, color=log(pvalue,base=10), size = Geneup)) + 
    geom_point() + 
    scale_color_gradient(low="green", high="red") + 
    labs(x="Ratio of Upregulated Genes",colour=expression(log[10]("pvalue")), size = "Number of\nUpregulated\nGenes") + 
    ylab(NULL) + 
    theme(axis.text = element_text(size = rel(1.5))) + 
    scale_y_discrete(labels = function(y)str_wrap(yz_data, width = 40))
dev.off()

cat(paste0("Success and save to: ", opt$output, "\n"))

