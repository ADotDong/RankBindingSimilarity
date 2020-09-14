#' @title Ranks the similarities between a given query bed file with multiple bed files (database files) without significance
#' @description  The function compares a given query bed file with multiple bed files (database files), and ranks the relative similarity between each file pairing, computed using jaccard indexes, where 0 indicates no similarities and 1 indicates an identical file. The function will not provide significance values, but the user should be aware that the computing time will be significantly faster.
#' @param bed1 The file path of a query bed file to be compared to the database files.
#' @param folder_dir The directory of a folder containing database files to be used for comparison with the query file.
#' @export
#' @return A dataframe with four columns, ranked by jaccard index. Contains the name of the database file, the respective jaccard index, the proportion of overlapping locations between the bed1 and database file over the total locations of bed1, and the proportion of overlapping locations between the bed1 and database file over the total locations of the database file.
#' @examples
#' jaccardOnly("/dir/bed1.txt","/dir/folder_dir")

jaccardOnly = function(bed1,folder_dir){
  levels = list.files(folder_dir)

  indexes = list()
  for (i in 1:length(levels)){
    ##jaccard
    pwd = paste(folder_dir,levels[i],sep="/")
    overlap = fread(cmd = paste("bedtools intersect -a",bed1, "-b",pwd))
    num_overlap = length(overlap$V1)

    length1 = dim(fread(cmd = paste("less",bed1)))[1]
    length2 = dim(fread(cmd = paste("less",pwd)))[1]

    num_total = length1 + length2 - num_overlap
    jaccard_id = num_overlap/num_total

    ##percentage --- ANB/A and ANB/B
    #ANB/A
    A_similarity = (num_overlap)/length1
    B_similarity = (num_overlap)/length2



    ##calc jaccard
    indexes[[i]] = c(bedfile = levels[i],jaccard_index = jaccard_id,percentage_A = A_similarity,percentage_B=B_similarity)
  }
  jaccard_df = as.data.frame(do.call(rbind,indexes))
  jaccard_df = jaccard_df[order(as.numeric(as.character(jaccard_df$jaccard_index)), decreasing = T),]
  return(jaccard_df)
}
