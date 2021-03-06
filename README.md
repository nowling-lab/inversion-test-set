# Inversion Benchmark Data Set

We composed a benchmark data set for evaluating SNP-based inversion detection methods.  We collected variant data from three insect data sets.  We provide links to the original data sources, a pipeline for processing the raw data into the final usable product for the benchmark, and labels of samples' inversion genotypes.

## Overview of Data Sets

Genotype labels are provided under the `inversion_genotypes` directory, and inversion boundaries are provided under the `inversion_boundaries` directory.

| Data Set | Citation | Populations (samples) |
| -------- | -------- | --------------------- |
| 1000 Anopheles genomes | Miles, et al. (2017) | gambiae (81), coluzzii (69) |
| DGRPv2 | Mackay, et al. (2012); Huang, et al. (2014) | all (198) |
| UBC Sunflower Genome Project | Todesco, et al. (2020) | petiolaris (158), fallax (230), niveus (86) |
| Peach | Guan, et al. (2021) | persica (149), kansuensis (37) |
| Blue tit | Perrier, et al. (2020) | mainland (111), corsica (343) |

| Chromosome        | Inversions (populations)                             |
| ----------------- | -------------------------------------- |
| ag1000g\_2L       | 2La (gambiae)                          |
| ag1000g\_2R       | 2Rb (gambiae, coluzzii), 2Rbc (coluzzii), 2Rd (coluzzii), 2Ru (coluzzii) |
| dgrp2\_2L         | In2Lt (all)                                 |
| dgrp2\_2R         | In2Rns (all)                                 |
| dgrp2\_3R         | In3Rp (all), In3Rmo (all), In3Rk (all)                                 |
| sunflowers\_pet05 | pet05.01 (petiolaris)           |
| sunflowers\_pet09 | pet09.01 (petiolaris, fallax)           |
| sunflowers\_pet11 | pet11.01 (petiolaris, fallax)           |
| sunflowers\_pet17 | pet17.01 (petiolaris, fallax), pet17.02 (petiolaris), pet17.03 (fallax, niveus), pet17.04 (petiolaris)           |
| peach\_pp06       | pp06.01 (persica)                    |
| cyan\_chrom03     | chrom03.01 (mainland)                 |


### Positives

| Inversion ID | Groups (Samples)                       | Genotypes Available |
| ------------ | -------------------------------------- | ------------------- |
| ag1000g-2La  | gambiae (81)                           | Yes                 |
| ag1000g-2Rb  | gambiae (81), gambiae-nohomostd (79), coluzzii (69) | Yes    |
| ag1000g-2Rbc | coluzzii (69)                          | Yes                 |
| ag1000g-2Rc  | coluzzii (69), coluzzii-nohomo1 (68)   | Predicted           |
| ag1000g-2Rd  | coluzzii (69), coluzzii-nohomo1 (68)   | Predicted           |
| ag1000g-2Ru  | coluzzii (69)                          | Predicted           |
| dgrp2-In2Lt  | DGRPv2 (198)                           | Yes                 |
| dgrp2-In2Rns | DGRPv2 (198)                           | Yes                 |
| dgrp2-In3Rp  | DGRPv2 (198)                           | Yes                 |
| dgrp2-In3Rmo | DGRPv2 (198)                           | Yes                 |
| dgrp2-In3Rk  | DGRPv2 (198)                           | Yes                 |
| pet05.01     | petiolaris (158)                       | Yes                 |
| pet09.01     | petiolaris (158), fallax (230)         | Yes                 |
| pet11.01     | petiolaris (158), fallax (230)         | Yes                 |
| pet17.01     | petiolaris (158), fallax (230)         | Yes                 |
| pet17.02     | petiolaris (158)                       | Yes                 |
| pet17.03     | fallax (230), niveus (86)              | Yes                 |
| pet17.04     | petiolaris (158)                       | Yes                 |
| prunus06     | persica (149)                          | No                  |
| cyan03       | mainland (111), mainland-nohomo2 (109) | Predicted           |


### Notes
| Inversion ID | Groups (Samples)                       | Comments
| ------------ | -------------------------------------- | ---------------------------- |
| ag1000g-2Rc  | gambiae (81)                           | There are associated SNPs in the 2Rc region but not a clear three-stripe pattern. Probably not an inversion. |
| ag1000g-2Rd  | coluzzii (69)                          | We get much better results if we do the PCA on the part of 2Rd that does not include 2Ru. Use 2Rdtail for PCA, 2Rd for actual boundaries. |
| ag1000g-2Rd  | gambiae (81)                           | There are associated SNPs near the right side of the 2Rd region but not a clear three-stripe pattern. Probably not an inversion. |
| pet05.01     | fallax (230)                           | Todesco, et al. (2020) provides genotype labels, but we do not see evidence of associated SNPs in the inversion region. |
| pet09.01     | niveus (86)                            | Todesco, et al. (2020) genotype labels suggest that one sample is heterozygous, but we do not see evidence of associated SNPs in the inversion region. Frequency might be too low to be detectable. |
| pet17.01     | niveus (86)                            | Todesco, et al. (2020) genotype labels do not suggest any inversions, but there could be a three-stripe patterns in the PCA and associated SNPs in the region. Frequency might be too low to be detectable. |
| pet17.03, pet17.04 |  | The pet17.03 region includes pet17.04.  Petiolaris have the associated SNPs only in the pet17.04 region, while fallax and niveus have associated SNPs in the larger pet17.03 region. |

## Machine Learning Problems

There are several potential machine learning problems associated with these data.

### Inversion Segmentation
Given variant data from a population of samples for a chromosome, determine if there are any inversions and their locations.  Existing tools require quite a bit of manual parameter tuning to perform localization (segmentation).  The goal would be a develop a method that is completely and capable of working even when data include "noise" resulting from pooling samples from multiple locations or closely-related species.

The input to the problem would be a 2D matrix of allele counts.  Each position along the chromosome in which nucleotide variation was detected has a column in the matrix.  (Positions with fixed nucleotides are excluded -- the matrix is effectively sparse.)  The allele counts for each variant are stored in each row.  The output would be a 1D vector with an entry for each column with a value of 0 indicating "no inversion" and 1 indicating "inversion detected".  See the numpy output format description.

Some thoughts on the approach and associated challenges:

* Perform the evaluation with each chromosome held out once.  There are 16 total chromosomes so there would 16 models trained and evaluated.
* The number of samples will vary across chromosomes.  You can add rows with zeros (zero padding) so that all matrices have the same number of rows.
* The ordering of the samples is not relevant.  The rows can be permuted in the matrix and you should get the same result.  There are several ways to handle this.  You can generate permutations of the matrices (increasing the training set size) or find a way to sort the entries in a canonical order, or explore deep learning methods like [Deep Sets](https://proceedings.neurips.cc/paper/2017/file/f22e4747da1aa27e363d86d40ff442fe-Paper.pdf) that are permutation invariant.
* The inversion frequencies will vary quite substantially in potential target data sets.  You can use bootstrap sampling (sampling with replacement) to create new data sets for each chromosome that simulate different inversion frequencies.  This is effectively a form of data augmentation.
* Given the small number of samples, methods such as RNNs and LSTMs might not work.  Instead, you might want to consider dividing the chromosomes into overlapping windows and performing classification on each window.  Combine the results by averaging the predictions from each window.
* Use the S??rensen???Dice coefficient, Jaccard Similarity, or precision / recall on the predicted and ground truth masks.


### Genotype Prediction
Given variant data in a known inversion region from a population of samples for a chromosome, determine the inversion genotypes of the samples (homozygeous inverted, homozygeous standard, and heterozygeous).  Existing tools require quite a bit of manual parameter tuning to perform localization (segmentation).  The goal would be a develop a method that is completely and capable of working even when data include "noise" resulting from pooling samples from multiple locations or closely-related species.

The input would be a 2D matrix of allele counts.  Each position along the chromosome in which nucleotide variation was detected has a column in the matrix.  (Positions with fixed nucleotides are excluded -- the matrix is effectively sparse.)  The allele counts for each variant are stored in each row.  The output would be a 1D vector with an entry for each row (sample) indicating the number of inversion copies (0, 1, or 2).  A simpler problem would be to determine if the sample had at least 1 inversion; in which case, the output vector would only contain 0s or 1s.  See the numpy output format description.

Some thoughts on the approach and associated challenges:

* When chromosomes only have a small number of samples of a particular inversion type, exclude that class.  For example, only two of the Anopheles gambiae samples arehomozygous for the standard orientation of 2Rb, only 1 Anopheles coluzzii sample is homozygous for one of the inversion orientations for 2Rc and 2Rd, and only two of the blue tit samples are homozygous for one of the inversion genotypes.

## Setup Instructions
You will need to download:

* Drosophila: The `dgrp2.vcf` VCF file from the [Drosophila Genetics Reference Panel v2](http://dgrp2.gnets.ncsu.edu/data.html)
* Anopheles: The biallelic 3L, 2R, and 2L VCF files from the FTP site for the 1000 Anopheles Genomes project phase 1 AR3 data release (`ftp://ngs.sanger.ac.uk/production/ag1000g/phase1/AR3/variation/main/vcf/`).  These files are named: `ag1000g.phase1.ar3.pass.biallelic.{chrom}.vcf.gz` where chrom is 3L, 2R, or 2L.
* H. petiolaris: `Petiolaris.pet_gwas.tranche90_snps_bi_AN50_AF99.vcf.gz` from the [UBC Sunflower Genome project](https://rieseberglab.github.io/ubc-sunflower-genome/)
* Prunus: `SNP.vcf.gz` (for Prunus) from [Figshare](https://figshare.com/articles/dataset/SNP_SV_and_scripts_for_RYP1_genome_paper/12937340/1)
* Cyanistes: `BLUE2020VCF.vcf.gz` from [Dryad](https://datadryad.org/stash/dataset/doi:10.5061/dryad.x69p8czfg)

Place these files in the directory `input_files`.  The directory contains an empty file named `PLACE_INPUT_FILES_HERE`.

To run the pipeline, you will need to install:

* [VCFTools](https://vcftools.github.io/index.html)
* [Plink v1.9](https://www.cog-genomics.org/plink/1.9/)

## Running Pipeline to Generate Output Files
Once you've downloaded the data, you can process the individual data sets with the following commands:

```bash
$ snakemake prepare_all
```

Each task is assigned one thread.  If you want to run multiple tasks concurrently, use Snakemake's `--cores` flag:

```bash
$ snakemake --cores 4 prepare_all
```


## Output File Formats
The pipeline will convert the variants into three file formats:

* VCF (potentially gzipped): This file format can be read by Asaph
* Plink bed: This file format can be read by [pcadapt](https://bcm-uga.github.io/pcadapt/index.html)
* inveRsion: This text file format can be read by [inveRsion](https://bioconductor.org/packages/release/bioc/html/inveRsion.html)
* Numpy matrices (.npz): Each Numpy .npz file contains three objects.  Allele counts are stored as a 2D matrix.  Each position along the chromosome in which nucleotide variation was detected has a column in the matrix.  (Positions with fixed nucleotides are excluded -- the matrix is effectively sparse.)  The allele counts for each variant are stored in each row.  Values are either 0 (homozygeous reference), 1 (heterozygous), 2 (homozygeous alternate), or -1 (unknown).  A mapping of column indices to genomic coordinates is provided as a 1D array with one entry for each column of the allele counts matrix.  A ground truth mask is provided as a 1D array (1 for inversion, 0 for no inverson) with one entry for each column of the allele counts matrix.

## Citing

If you use this data set, please cite the original papers from which the data are derived:

* **Anopheles 1000 Genomes**: Miles, A., Harding, N., Bott??, G. et al. [Genetic diversity of the African malaria vector Anopheles gambiae.](https://doi.org/10.1038/nature24995) Nature 552, 96???100 (2017).
* **Anopheles 1000 Genomes**: Corbett-Detig, R. B., Said, I., Calzetta, M., et al. [Fine-Mapping Complex Inversion Breakpoints and Investigating Somatic Pairing in the Anopheles gambiae Species Complex Using Proximity-Ligation Sequencing](https://doi.org/10.1534/genetics.119.302385), Genetics, Volume 213, Issue 4, 1 December 2019, Pages 1495???1511
* **Drosophila Genetics Reference Panel**: Mackay, T., Richards, S., Stone, E., et al. [The Drosophila melanogaster Genetic Reference Panel.](https://doi.org/10.1038/nature10811) Nature 482, 173???178 (2012).
* **Drosophila Genetics Reference Panel**: Huang, W., Massouras, A., Inoue, Y., et al. [Natural variation in genome architecture among 205 Drosophila melanogaster Genetic Reference Panel lines.](https://doi.org/10.1101/gr.171546.113) Genome Research 24:1193-1208 (2014).
* **UBC Sunflower Genome project**: Todesco, et al. [Massive haplotypes underlie ecotypic differentiation in sunflowers](https://www.nature.com/articles/s41586-020-2467-6) Nature (2020).
* **Peach**: Guan, et al. [Genome structure variation analyses of peach reveal population dynamics and a 1.67???Mb causal inversion for fruit shape](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-020-02239-1). Genome Biology. (2021)
* **Blue tit**: Perrier, et al. [Demographic history and genomics of local adaptation in blue tit populations](https://onlinelibrary.wiley.com/doi/10.1111/eva.13035). Evolutionary Applications. 2020.

and our paper describing the test set:

* Nowling, R.J., Manke, K.R., and Emrich, S.J. [Detection of Inversions with PCA in the Presence of Population Structure.](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0240429) PLOS One (2020).
