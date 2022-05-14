# Inversion Benchmark Data Set

We composed a benchmark data set for evaluating SNP-based inversion detection methods.  We collected variant data from three insect data sets.  We provide links to the original data sources, a pipeline for processing the raw data into the final usable product for the benchmark, and labels of samples' inversion genotypes.

## Overview of Data Sets

| Source | Group | Samples | Inversion | Genotype Labels Included | Allele Freq. | Genotype Freq. | Inversion Boundaries Included | Size (Mb, %) |
| ------ | ----- | ------- | --------- | ------------------------ | ------------ | -------------- | ----------------------------- | |
| Ag1000g | An. gambaie and coluzzii, B. Faso | 150 | 2La | Yes | 94.7% | | Yes | 21.6 Mb |
| Ag1000g | An. gambaie and coluzzii, B. Faso | 150 | 2Rb | Yes | 59.3% | | Yes | 7.55 Mb |
| Ag1000g | An. gambaie, B. Faso | 81 | 2La | Yes | 90.7% | | Yes | 21.6 Mb |
| Ag1000g | An. gambaie, B. Faso | 81 | 2Rb | Yes | 82.1% | | Yes | 7.55 Mb |
| Ag1000g | An. gambaie, B. Faso (No hetero) | 79 | 2Rb | Yes | | | Yes | 7.55 Mb |
| Ag1000g | An. coluzzii, B. Faso | 69 | 2Rb | Yes | 31.1% | | Yes | 7.55 Mb |
| Ag1000g | An. coluzzii, B. Faso | 69 | 2Rc | No | | | Yes | 4.7 Mb |
| Ag1000g | An. coluzzii, B. Faso | 69 | 2Rd | No | | | Yes | 10.9 Mb |
| DGRPv2  | D. melanogaster | 198 | In(2L)t | Yes | 14.4% | | Yes | 10.9 Mb |
| DGRPv2  | D. melanogaster | 198 | In(2R)ns | Yes | 12.1% | | Yes | 15.0 Mb |
| DGRPv2  | D. melanogaster | 198 | In(3R)Mo | Yes | 18.7% | | Yes | 7.6 Mb |
| DGRPv2  | D. melanogaster | 198 | In(3R)P | Yes | 7.1% | | Yes | 8.3 Mb |
| DGRPv2  | D. melanogaster | 198 | In(3R)K | Yes | 8.1% | | Yes | 7.6 Mb |
| Todesco | H. petiolaris (both varieties) | 475 | Ha412HOChr05.1 | Yes | | | No | |
| Todesco | H. petiolaris (both varieties) | 475 | Ha412HOChr09.1 | Yes | | | No | |
| Todesco | H. petiolaris (both varieties) | 475 | Ha412HOChr11.1 | Yes | | | No | |
| Todesco | H. petiolaris (both varieties) | 475 | Ha412HOChr17.3 | Yes | | | No | |
| Todesco | H. petiolaris petiolaris | 158 | Ha412HOChr05.1 | Yes | | | No | |
| Todesco | H. petiolaris petiolaris | 158 | Ha412HOChr09.1 | Yes | | | No | |
| Todesco | H. petiolaris petiolaris | 158 | Ha412HOChr11.1 | Yes | | | No | |
| Todesco | H. petiolaris fallax | 230 | Ha412HOChr05.1 | Yes | | | No | |
| Todesco | H. petiolaris fallax | 230 | Ha412HOChr09.1 | Yes | | | No | |
| Todesco | H. petiolaris fallax | 230 | Ha412HOChr11.1 | Yes | | | No | |
| Todesco | H. petiolaris fallax | 230 | Ha412HOChr17.3 | Yes | | | No | |
| Guan | Prunus persica and kansuensis | 186 | Pp06 | No | | | Yes | 1.67 Mb |
| Perrier | Cyanistes caeruleus | chromo.03 | No | | | Yes | 2.8 Mb |

Genotype labels are provided under the `sample_labels` directory, and inversion boundaries are provided under the `inversion_boundaries` directory.

### Notes

* Negatives: these data do not have any inversions
  * DGRP2 3L: Samples with no inversions (we removed any samples with inversions) and from a single population
  * Ag1000 3L: 150 _Anopheles gambiae_ and _coluzzii_ samples from a single geographic area (Burkina Faso)
* DGRP2 3R: 198 samples with three overlapping and mutually-exclusive inversions In(3R)Mo, In(3R)P, and In(3R)K
* Ag1000 2L _An. coluzzii_: 69 samples from a single geographic area (Burkina Faso); only one sample has a different genotype for 2La
* Ag1000 2R _An. gambiae_: 81 from a single geographic area (Burkina Faso) with the 2Rb inversion
* Ag1000 2R _An. coluzzii_: 69 from a single geographic area (Burkina Faso) with the 2Rbc inversion system and 2Rd inversion (no labels provided)
* Helianthus petiolaris (sunflowers): Todesco, et al. found inversions on chromosomes 5, 9, 11, and 17 (see extended figures 6 and 7). Analysis of the two varieties together is confounded by population structure.  The pet05.1, pet09.1, and pet11.1 inversions show the clear three-stripe patterns in PCA when analyzed for H. petiolaris petiolaris; pet17.3 is fixed in H. petiolaris petiolaris.
* Prunus persica and kansuensis (peach): Guan, et al. found a 1.67 Mb inversion on chromosome Pp06.
* Cyanistes caeruleus (Blue tit): Perrier, et al. found a 2.8 Mb inversion on chromosome 3.


### Evaluation Recommendations

1. Use balanced accuracy for genotype predictions since the genotypes are not balanced
1. Use the Sørensen–Dice coefficient, Jaccard Similarity, or precision / recall for inversion segmentation / localization
1. Use the An. gambiae 2Rb data set without heterozygous genotypes since there are only 2 heterozygous samples

## Setup Instructions
You will need to download:

* The `dgrp2.vcf` VCF file from the [Drosophila Genetics Reference Panel v2](http://dgrp2.gnets.ncsu.edu/data.html)
* The biallelic 3L, 2R, and 2L VCF files from the FTP site for the 1000 Anopheles Genomes project phase 1 AR3 data release (ftp://ngs.sanger.ac.uk/production/ag1000g/phase1/AR3/variation/main/vcf/).  These files are named: `ag1000g.phase1.ar3.pass.biallelic.{chrom}.vcf.gz` where chrom is 3L, 2R, or 2L.
* The `Petiolaris.pet_gwas.tranche90_snps_bi_AN50_AF99.vcf.gz` file from the [UBC Sunflower Genome project](https://rieseberglab.github.io/ubc-sunflower-genome/)
* The file `SNP.vcf.gz` (for Prunus) from [Figshare](https://figshare.com/articles/dataset/SNP_SV_and_scripts_for_RYP1_genome_paper/12937340/1)
* The file `BLUE2020VCF.vcf.gz` from [Dryad](https://datadryad.org/stash/dataset/doi:10.5061/dryad.x69p8czfg)

Place these files in the directory `input_files`.  The directory contains an empty file named `PLACE_INPUT_FILES_HERE`.

To run the pipeline, you will need to install:

* [VCFTools](https://vcftools.github.io/index.html)
* [Plink v1.9](https://www.cog-genomics.org/plink/1.9/)

## Running Pipeline to Generate Output Files
Once you've downloaded the data, you can process the individual data sets with the following commands:

```bash
$ snakemake prepare_ag1000g
$ snakemake prepare_dgrp2
$ snakemake prepare_petiolaris
$ snakemake prepare_cyanistes
$ snakameke prepare_prunus
```

Each task is assigned one thread.  If you want to run multiple tasks concurrently, use Snakemake's `--cores` flag:

```bash
$ snakemake --cores 4 prepare_ag1000g
```

## Output File Formats
The pipeline will convert the variants into three file formats:

* VCF (potentially gzipped): This file format can be read by Asaph
* Plink bed: This file format can be read by [pcadapt](https://bcm-uga.github.io/pcadapt/index.html)
* inveRsion: This text file format can be read by [inveRsion](https://bioconductor.org/packages/release/bioc/html/inveRsion.html)

## Citing

If you use this data set, please cite the original papers from which the data are derived:

* **Anopheles 1000 Genomes**: Miles, A., Harding, N., Bottà, G. et al. [Genetic diversity of the African malaria vector Anopheles gambiae.](https://doi.org/10.1038/nature24995) Nature 552, 96–100 (2017).
* **Anopheles 1000 Genomes**: Corbett-Detig, R. B., Said, I., Calzetta, M., et al. [Fine-Mapping Complex Inversion Breakpoints and Investigating Somatic Pairing in the Anopheles gambiae Species Complex Using Proximity-Ligation Sequencing](https://doi.org/10.1534/genetics.119.302385), Genetics, Volume 213, Issue 4, 1 December 2019, Pages 1495–1511
* **Drosophila Genetics Reference Panel**: Mackay, T., Richards, S., Stone, E., et al. [The Drosophila melanogaster Genetic Reference Panel.](https://doi.org/10.1038/nature10811) Nature 482, 173–178 (2012).
* **Drosophila Genetics Reference Panel**: Huang, W., Massouras, A., Inoue, Y., et al. [Natural variation in genome architecture among 205 Drosophila melanogaster Genetic Reference Panel lines.](https://doi.org/10.1101/gr.171546.113) Genome Research 24:1193-1208 (2014).
* **UBC Sunflower Genome project**: Todesco, et al. [Massive haplotypes underlie ecotypic differentiation in sunflowers](https://www.nature.com/articles/s41586-020-2467-6) Nature (2020).
* **Peach**: Guan, et al. [Genome structure variation analyses of peach reveal population dynamics and a 1.67 Mb causal inversion for fruit shape](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-020-02239-1) (2021)
* **Blue tit**: Perrier, et al. [Demographic history and genomics of local adaptation in blue tit populations](https://onlinelibrary.wiley.com/doi/10.1111/eva.13035) (2020).

and our paper describing the test set:

* Nowling, R.J., Manke, K.R., and Emrich, S.J. [Detection of Inversions with PCA in the Presence of Population Structure.](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0240429) PLOS One (2020).
