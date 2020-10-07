# RankBindingSimilarity

Written by Amy Dong and Dr. Xiaomin Bao, Northwestern University, Bao Lab.

## INSTALLATION AND PRE-REQUISITES

XXX is an R package that can be run on an R environment. However, XXX requires that another software tool, BedTools, be installed and executable in order to run XXX.

BedTools is a toolset developed and maintained by the Quinlan laboratory at the University of Utah used to compare large sets of genomic features. Information relating to BedTools installation and tool function, etc. can be found at http://bedtools.readthedocs.org/en/latest/ .

## DESCRIPTION:

The purpose of XXX is to compute and rank the similarities between the locations of a given query bed file with multiple bed files (database files).

The computation makes use of the jaccard index to provide the relative similarity between each file pairing. The jaccard index is the overlap of locations for two bed files over the total locations of both bed files, where an index of 0 indicates no similarities and 1 indicates an identical file.

## INSTALLATION

### External Pre-Requisites

Our package is intended to run in an R environment on any Mac, Windows, or LINUX operating system. In order to install XXX, the following pre-requisites must be met:

**R-Studio** Please have a 1.3.1056 or higher version of RStudio installed. To install RStudio, follow the installation steps at the bottom of the page: https://rstudio.com/products/rstudio/download/

**bedtools** bedtools must be installed for XXX to run, as XXX uses the bedtools shuffle and intersect tools. Information on the installation of bedtools can be found here: https://bedtools.readthedocs.io/en/latest/content/installation.html

### XXX Package installation

Once all above pre-requisites have been met, open RStudio and run the following commands to install devtools, which allows for easier installation of XXX:

> install.packages("devtools")\
> library(devtools)

Please note that XXX requires the installation of another R package **data.table** before proper usage. In order to install data.table, run the following commands:

> install.packages("data.table")\
>library(data.table)

If the data.table package still isn't installing, try running the following commands instead:

> library(devtools)\
> install_github('Rdatatable/data.table')

Once data.table is installed and loaded, you can install and load the XXX package by running the following commands:

> install_github("ADotDong/RankBindingSimilarity")\
> library(RankBindingSimilarity)

You should now be set to use the XXX package!

## USAGE AND PARAMETERS:

### Usage Instructions

Once you have loaded the XXX package using the library() command, you should now be able to use the XXX package. The XXX package allows the user to run the following command, which compares the locations from a query bed file and a folder of database bed files:

> rankBedSimilarity(n, "/dir/bed1.txt, "/dir/genome_file.txt", "/dir/folder_dir", "jaccard_only", "/dir/output_folder")

**n** The number of background files generated in order to compute the p-value. As the n increases, the p-value will become more reliable, but the user should be aware that this will significantly increase the computing time. We have set a default n of 100.

**bed1** The file path of a query bed file to be compared to the database files, which should be tab delimited and structured as follows: chromName, TAB, chromSize, TAB, chromEND

**genome** The file path of a genome file, which should be tab delimited and structured as follows: chromName, TAB, chromSize. A pre-formatted hg19 genome file can be found on the Github.

**folder_dir** The directory of a folder containing database files to be used for comparison with the query file.

**method** The method that specifies the output format. "jaccard_pval" will output the jaccard indexes and the p-value significance. "jaccard_only" will only output jaccard indexes, but will run faster.

**output_path** The output path specifies where the exported .csv file (with the run results) will appear. Keep in mind that this file must already exist. Do not include a '/' at the end of the output file path.

### Interpreting Output

By selecting **"jaccard_pval"** as the method parameter, the command will output a .csv file in the given folder provided in the output_path parameter. The .csv file will contain an ordered table with the following columns:

**bedfile** This column provides the name of each database bed file that had been compared with the query bed file. Each respective row corresponds to the comparison between the provided database bed file and the query bed file.

**jaccard_index** This column provides the jaccard index score between the database file and the query bed file. The jaccard index provides the relative similarity between each file pairing, and indicates the relative amount of overlap of locations for two bed files over the total locations of both bed files. An index of 0 indicates no similarities and 1 indicates an identical file; thus, the greater the jaccard index, the more similar the files are. The table is sorted based on the jaccard index, so the first rows of the table are the most similar database files in comparison to the query file.

**pi_score** This column provides the pi score between the database file and the query bed file. The pi score takes into account the significance of the similarity using the p-value, and is calculated using the jaccard index mean ratio (real jaccard index/mean of generated background file jaccard indexes) multiplied by the negative logarithm of the p-value. The larger the pi score, the more significant the similarities between the database file and the query bed file are.

**p_value** This column provides the p-value of the query bed file jaccard index in relation to a generated amount of background jaccard indexes. Essentially, the p-value is created by comparing the real jaccard index to the jaccard indexes of randomly generated background bed files. The p-value signifies how significant the jaccard index between the database file and the query bed file is, and how it compares to jaccard scores generated solely by random chance. This value increases in relability as the parameter n increases. The smaller the p-value, the more significant the jaccard index between the database file and the query bed file is.

**percentage_A** This column provides the proportion of the similarities between the query file and the database bed file to the query file itself. It is the ratio of the total overlap between the query file and the database bed file over the total length of the query file. It allows users to get an idea of where the similarities between files exist.

**percentage_B** This column provides the proportion of the similarities between the query file and the database bed file to the database bed file itself. It is the ratio of the total overlap between the query file and the database bed file over the total length of the database file. For example, if the percentage_A has an output of 1 while the percentage_B is lower, the query file may have been a subset of the database bed file.

**five number summary** The last columns provide a general statistical summary of the jaccard indexes of the background bed files that were generated. The background files are created with the same length as the query file, and their locations are randomly generated. By deriving jaccard indexes of these randomly generated background files, we get an idea of the significance of the similarity (determining whether this similarity may or may not have been due to statistical chance or if the similarity differs from random expectation).

By selecting **"jaccard_only"** as the method parameter, the command will output a .csv file in the given folder provided in the output_path parameter. The .csv file will contain an ordered table with only the columns **bedfile, jaccard_index, percentage_A, and percentage_B**

## EXAMPLE

Download all files present in the "Examples" folder in Github. Then, run the following command after filling their file paths:

> rankBedSimilarity(100, "/dir/bed1.txt, "/dir/hg19_formatted_genomebedfile.txt", "/dir/database_folder", "jaccard_only", "/dir/output_path")

The provided bed1.txt is a subset of the Broad_ChIP_H3K27ac_NHEK_Broad file from the database folder. If run correctly, the outputs should look like the following (with some minor differences due to the random generation of the background files and the number of n run):

## TROUBLESHOOTING:

Please note: the given parameters for bed1, genome and folder_dir must be strings, and must give the exact file path instead of reading the files in to R.

All given files must be tab delimited, and cannot exceed the given columns (e.g. bed1 MUST only contain the three given columns)
