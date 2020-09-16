#' @title Ranks the similarities between a given query bed file with multiple bed files (database files) with or without significance
#' @description The function compares a given query bed file with multiple bed files (database files), and ranks the relative similarity between each file pairing, computed using jaccard indexes, where 0 has no similarities and 1 has an identical file. The function can also provide a significance value (p-value) of the similarity index based on user selection.
#' @param n The number of background files generated in order to compute the p-value. As the n increases, the p-value will become more reliable, but the user should be aware that this will significantly increase the computing time. We have set a default n of 100.
#' @param bed1 The file path of a query bed file to be compared to the database files.
#' @param genome The file path of a genome file, which should be tab delimited and structured as follows: <chromName><TAB><chromSize>. A pre-formatted hg19 genome file can be found on the Github.
#' @param folder_dir The directory of a folder containing database files to be used for comparison with the query file.
#' @param method The method that specifies the output format. "jaccard_pval" will output the jaccard indexes and the p-value significance. "jaccard_only" will only output jaccard indexes, but will run faster.
#' @param output_path The file path where the output .csv file will be generated.
#' @export
#' @return A dataframe that shows the similarities of the query file to the database files ranked from greatest to least, tailored to user method specification.
#' @examples
#' rankBedSimilarity(100,"/dir/bed1.txt,"/dir/genome-file.txt","/dir/folder_dir","jaccard_only")

rankBedSimilarity = function(n=100,bed1,genome,folder_dir,method=c("jaccard_pval","jaccard_only"),output_path){
  if (missing(method)){
    method = "jaccard_only"
  }
  else{
    method = match.arg(method)
  }

  if (method == "jaccard_pval"){
    bed1 = jaccardAndPValue(n, bed1, genome, folder_dir)
    write.csv(bed1,paste(output_path,"/",gsub("^.*/", "", bed1),"_jaccard_pval.csv",sep=""))
  }
  else if (method == "jaccard_only"){
    bed2 = jaccardOnly(bed1,folder_dir)
    write.csv(bed2,paste(output_path,"/",gsub("^.*/", "", bed1),"_jaccard_only.csv",sep=""))
  }
}
