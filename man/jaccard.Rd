% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/jaccard.R
\name{jaccard}
\alias{jaccard}
\title{Computes single jaccard index from two bed files}
\usage{
jaccard(bed1, bed2)
}
\arguments{
\item{bed1}{The file path string of a query bed file}

\item{bed2}{The file path string of a second query bed file to be compared}
}
\value{
A vector containing a jaccard index, proportion of intersection similarity with bed1, and proportion of intersection similarity with bed2
}
\description{
Computes the jaccard index and respective similarities between two provided bed files.
}
\examples{
jaccard("/dir/bed1.txt","/dir/bed2.txt")
}
