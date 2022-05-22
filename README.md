# Inversion Benchmark Data Set

We composed a benchmark data set for evaluating SNP-based inversion detection methods.  We collected variant data from three insect data sets.  We provide links to the original data sources, a pipeline for processing the raw data into the final usable product for the benchmark, and labels of samples' inversion genotypes.

## Overview of Data Sets

Genotype labels are provided under the `inversion_genotypes` directory, and inversion boundaries are provided under the `inversion_boundaries` directory.

| Inversion ID | Data Set                               |
| ------------ | -------------------------------------- |
| ag1000g-2La  | 1000 Anopheles genomes                 |
| ag1000g-2Rb  | 1000 Anopheles genomes                 |
| ag1000g-2Rc  | 1000 Anopheles genomes                 |
| ag1000g-2Rd  | 1000 Anopheles genomes                 |
| dgrp2-In2Lt  | DGRPv2                                 |
| dgrp2-In2Rns | DGRPv2                                 |
| dgrp2-In3Rp  | DGRPv2                                 |
| dgrp2-In3Rmo | DGRPv2                                 |
| dgrp2-In3Rk  | DGRPv2                                 |
| pet05.01     | UBC Sunflower Genome Project           |
| pet09.01     | UBC Sunflower Genome Project           |
| pet11.01     | UBC Sunflower Genome Project           |
| pet17.01     | UBC Sunflower Genome Project           |
| pet17.02     | UBC Sunflower Genome Project           |
| pet17.03     | UBC Sunflower Genome Project           |
| pet17.04     | UBC Sunflower Genome Project           |
| prunus06     | Guan, et al. (2021)                    |
| cyan03       | Perrier, et al. (2020)                 |


### Positives

| Inversion ID | Groups (Samples)                       | Genotypes Available |
| ------------ | -------------------------------------- | ------------------- |
| ag1000g-2La  | gambiae (81)                           | Yes                 |
| ag1000g-2Rb  | gambiae (81), gambiae-nohomostd (79), coluzzii (69) | Yes    |
| ag1000g-2Rc  | coluzzii (69), coluzzii-nohomo1 (68)   | Predicted           |
| ag1000g-2Rd  | coluzzii (69)                          | No                  |
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

### Negatives

| Inversion ID | Groups (Samples)                       |
| ------------ | -------------------------------------- |
| ag1000g-3L   | gambiae (81), coluzzii (69)            |
| pet05.01     | niveus (86)                            |
| pet11.01     | niveus (86)                            |
| pet17.02     | niveus (86), fallax (230)              |
| prunus06     | kansuensis (37)                        |
| cyan03       | corsica (343)                          |

### Complicated
| Inversion ID | Groups (Samples)                       | Comments
| ------------ | -------------------------------------- | ---------------------------- |
| ag1000g-2Rc  | gambiae (81)                           | There are associated SNPs in the 2Rc region but not a clear three-stripe pattern. Either a small inversion or other something else. |
| ag1000g-2Rd  | gambiae (81)                           | There are associated SNPs in the 2Rd region but not a clear three-stripe pattern. Either a small inversion or something else. |
| pet05.01     | fallax (230)                           | Todesco, et al. (2020) provides genotype labels, but we do not see evidence of associated SNPs in the inversion region. |
| pet09.01     | niveus (86)                            | Todesco, et al. (2020) genotype labels suggest that one sample is heterozygous, but we do not see evidence of associated SNPs in the inversion region. |
| pet17.01     | niveus (86)                            | Todesco, et al. (2020) genotype labels do not suggest any inversions, but we there are some stripe patterns in the PCA and associated SNPs in the region. |
| pet17.03, pet17.04 |  | The pet17.03 region includes pet17.04.  Petiolaris have the associated SNPs only in the pet17.04 region, while fallax and niveus have associated SNPs in the larger pet17.03 region. |


### Evaluation Recommendations

1. Use balanced accuracy for genotype predictions since the genotypes are not balanced
1. Use the Sørensen–Dice coefficient, Jaccard Similarity, or precision / recall for inversion segmentation / localization
1. Use the An. gambiae 2Rb data set without heterozygous genotypes since there are only 2 heterozygous samples

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

## Citing

If you use this data set, please cite the original papers from which the data are derived:

* **Anopheles 1000 Genomes**: Miles, A., Harding, N., Bottà, G. et al. [Genetic diversity of the African malaria vector Anopheles gambiae.](https://doi.org/10.1038/nature24995) Nature 552, 96–100 (2017).
* **Anopheles 1000 Genomes**: Corbett-Detig, R. B., Said, I., Calzetta, M., et al. [Fine-Mapping Complex Inversion Breakpoints and Investigating Somatic Pairing in the Anopheles gambiae Species Complex Using Proximity-Ligation Sequencing](https://doi.org/10.1534/genetics.119.302385), Genetics, Volume 213, Issue 4, 1 December 2019, Pages 1495–1511
* **Drosophila Genetics Reference Panel**: Mackay, T., Richards, S., Stone, E., et al. [The Drosophila melanogaster Genetic Reference Panel.](https://doi.org/10.1038/nature10811) Nature 482, 173–178 (2012).
* **Drosophila Genetics Reference Panel**: Huang, W., Massouras, A., Inoue, Y., et al. [Natural variation in genome architecture among 205 Drosophila melanogaster Genetic Reference Panel lines.](https://doi.org/10.1101/gr.171546.113) Genome Research 24:1193-1208 (2014).
* **UBC Sunflower Genome project**: Todesco, et al. [Massive haplotypes underlie ecotypic differentiation in sunflowers](https://www.nature.com/articles/s41586-020-2467-6) Nature (2020).
* **Peach**: Guan, et al. [Genome structure variation analyses of peach reveal population dynamics and a 1.67 Mb causal inversion for fruit shape](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-020-02239-1). Genome Biology. (2021)
* **Blue tit**: Perrier, et al. [Demographic history and genomics of local adaptation in blue tit populations](https://onlinelibrary.wiley.com/doi/10.1111/eva.13035). Evolutionary Applications. 2020.

and our paper describing the test set:

* Nowling, R.J., Manke, K.R., and Emrich, S.J. [Detection of Inversions with PCA in the Presence of Population Structure.](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0240429) PLOS One (2020).
