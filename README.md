# RankBindingSimilarity

Written by Amy Dong and Dr. Xiaomin Bao, Northwestern University, Bao Lab.

### INSTALLATION AND PRE-REQUISITES

XXX is an R package that can be run on an R environment. However, XXX requires that another software tool, BedTools, be installed and executable in order to run XXX.

BedTools is a toolset developed and maintained by the Quinlan laboratory at the University of Utah used to compare large sets of genomic features. Information relating to BedTools installation and tool function, etc. can be found at http://bedtools.readthedocs.org/en/latest/ .

### DESCRIPTION:

The purpose of XXX is to compute and rank the similarities between the locations of a given query bed file with multiple bed files (database files).

The computation makes use of the jaccard index to provide the relative similarity between each file pairing. The jaccard index is the overlap of locations for two bed files over the total locations of both bed files, where an index of 0 indicates no similarities and 1 indicates an identical file.

### USAGE AND PARAMETERS:

> rankBedSimilarity(100, "/dir/bed1.txt, "/dir/genome_file.txt", "/dir/folder_dir", "jaccard_only", "/dir/output_folder")

**n** The number of background files generated in order to compute the p-value. As the n increases, the p-value will become more reliable, but the user should be aware that this will significantly increase the computing time. We have set a default n of 100.

**bed1** The file path of a query bed file to be compared to the database files, which should be tab delimited and structured as follows: <chromName><TAB><chromStart><TAB><chromEND>

**genome** The file path of a genome file, which should be tab delimited and structured as follows: chromName, TAB, chromSize. A pre-formatted hg19 genome file can be found on the Github.

**folder_dir** The directory of a folder containing database files to be used for comparison with the query file.

**method** The method that specifies the output format. "jaccard_pval" will output the jaccard indexes and the p-value significance. "jaccard_only" will only output jaccard indexes, but will run faster.

**output_path** The output path specifies where the exported .csv file (with the run results) will appear. Keep in mind that this file must already exist. Do not include a '/' at the end of the output file path.

### EXAMPLE

Download all files present in the "Examples" folder in Github. Then, run the following command after filling their file paths:

> rankBedSimilarity(100, "/dir/bed1.txt, "/dir/hg19_formatted_genomebedfile.txt", "/dir/folder_dir", "jaccard_only", "/dir/database_folder")

### TROUBLESHOOTING:
Please note: the given parameters for bed1, genome and folder_dir must be strings, and must give the exact file path instead of reading the files in to R.

Please note: all given files must be tab delimited, and cannot exceed the given columns (e.g. bed1 MUST only contain the three given columns)

**Please note:** bedtools must be installed for XXX to run, as XXX uses the bedtools shuffle and intersect tools. Information on the installation can be found here: http://bedtools.readthedocs.org/en/latest/
