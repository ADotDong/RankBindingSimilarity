#' @title Computes single jaccard index from two bed files
#' @description Computes the jaccard index, where 0 signifies no similarities between the bed files and 1 signifies that the files are identical, and the proportions of overlapping locations between two bed files over the total locations of each respective bed file.
#' @param bed1 The file path string of a query bed file
#' @param bed2 The file path string of a second query bed file to be compared
#' @export
#' @return A vector containing a jaccard index and proportions of overlapping locations between two bed files over the total locations of each respective bed file.
#' @examples
#' jaccard("/dir/bed1.txt","/dir/bed2.txt")


jaccard = function(bed1, bed2){
  overlap = fread(cmd = paste("bedtools intersect -a",bed1, "-b",bed2))
  num_overlap = length(overlap$V1)

  length1 = dim(fread(cmd = paste("less",bed1)))[1]
  length2 = dim(fread(cmd = paste("less",bed2)))[1]

  #jaccard index
  num_total = length1 + length2 - num_overlap
  jaccard_index = num_overlap/num_total
  #jaccard_index

  #percentage --- ANB/A and ANB/B
  #ANB/A
  A_similarity = (num_overlap)/length1
  B_similarity = (num_overlap)/length2

  #jaccard, ANB/A, ANB/B
  output = c(jaccard_index,A_similarity,B_similarity)
  return(output)
}
