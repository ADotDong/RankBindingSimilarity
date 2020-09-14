#' @title Ranks the similarities between a given query bed file with multiple bed files (database files) with significance
#' @description The function compares a given query bed file with multiple bed files (database files), and ranks the relative similarity between each file pairing, computed using jaccard indexes, where 0 indicates no similarities and 1 indicates an identical file. The function will provide significance values (p-values) of each jaccard index by simulating background files through bedtool's shuffle tool. The user should be aware that this function will take significantly longer to run as the amount of background files generated increases.
#' @param n The number of background files generated in order to compute the p-value. As the n increases, the p-value will become more reliable, but the user should be aware that this will significantly increase the computing time. We have set a default n of 100.
#' @param bed1 The file path of a query bed file to be compared to the database files.
#' @param genome The file path of a genome file, which should be tab delimited and structured as follows: <chromName><TAB><chromSize>. A pre-formatted hg19 genome file can be found on the Github.
#' @param folder_dir The directory of a folder containing database files to be used for comparison with the query file.
#' @export
#' @return A dataframe with 12 columns, ranked by jaccard index. Contains the name of the database file, the respective jaccard index, the pi score, the significance value (p-value) of the similarity, the proportion of overlapping locations between the bed1 and database file over the total locations of bed1, the proportion of overlapping locations between the bed1 and database file over the total locations of the database file, and a five-number summary of the jaccard indexes computed from the background files generated.
#' @examples
#' jaccardAndPValue(100,"/dir/bed1.txt","/dir/genome.txt","/dir/folder_dir)

jaccardAndPValue = function(n, bed1, genome, folder_dir){
  levels = list.files(folder_dir)
  final_values = list()

  #generate background files from query:
  background_dir = paste(folder_dir,"background",sep="_")
  dir.create(background_dir)
  print("generating background files")
  background_list = list()
  for (i in 1:(n)){
    background <- fread(cmd = paste("bedtools shuffle -i", bed1, "-g", genome))
    write.table(background, paste(background_dir,"/background_file",i,".txt",sep = ""),sep="\t",row.names=F, col.names = F, quote = F)
  }
  print("finished generating background files")


  ##generates, A and B... then A' B
  for (i in 1:length(levels)){
    print(paste("computing",levels[i]))
    pwd = paste(folder_dir,levels[i],sep="/")
    #real jaccard (lists jaccard, A similarity and B similarity)
    real_jaccard = jaccard(bed1, pwd)

    ########
    background_n = list.files(background_dir)
    background_jaccard = list()
    for (j in 1:length(background_n)){
      #################################################watch
      jaccard_id = jaccard(paste(background_dir,background_n[j],sep="/"),pwd)[1]
      #jaccard_id = jaccard(paste(background_dir,background_n[j],sep="/"),pwd)
      background_jaccard[[j]] = c(bedfile = levels[i],jaccard_index = jaccard_id)

      # print(j)
    }

    jaccard_df = as.data.frame(do.call(rbind,background_jaccard))

    bed = as.numeric(as.character(jaccard_df[,2]))

    #find the p-value
    num = as.numeric(as.character(match(real_jaccard[1],sort(c(bed,real_jaccard[1]),decreasing=T))))
    value = num/(n+1)

    #finding the pi-score = mean ratio * (-log10(p-value))
    if (mean(bed) == 0){
      piscore = (real_jaccard[1])/(0.000001) * (-log(value))
    }
    else{
      piscore = (real_jaccard[1])/(mean(bed)) * (-log(value))
    }



    final_values[[i]] = c(bedfile = levels[i],jaccard_index = real_jaccard[1],pi_score = piscore, p_value = value, percentage_A = real_jaccard[2], percentage_B = real_jaccard[3],summary(bed))

  }
  unlink(background_dir, recursive = TRUE)

  values_df = as.data.frame(do.call(rbind,final_values))
  values_df = values_df[order(as.numeric(as.character(values_df$jaccard_index)),decreasing = T),]
  return(values_df)

}
