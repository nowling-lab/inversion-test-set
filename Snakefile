# Copyright 2021 Ronald J. Nowling
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

configfile: "config.yaml"

## process Drosophila Genetics Reference Panel v2 VCFs
rule filter_dgrp2_vcf:
    input:
        vcf="data/raw_data/dgrp2.vcf"
    output:
        filtered_vcf="data/dgrp2/dgrp2.biallelic.vcf"
    threads:
        1
    shell:
        "vcftools --vcf {input.vcf} --min-alleles 2 --max-alleles 2 --remove-indels --maf 0.01 --recode --stdout --remove-indv line_348 --remove-indv line_350 --remove-indv line_358 --remove-indv line_385 --remove-indv line_392 --remove-indv line_395 --remove-indv line_399 > {output.filtered_vcf}"

rule split_dgrp2_by_chrom:
    input:
        vcf="data/dgrp2/dgrp2.biallelic.vcf"
    output:
        chrom_vcf="data/dgrp2/dgrp2_{chrom}.biallelic.vcf"
    threads:
        1
    shell:
        "vcftools --vcf {input.vcf} --chr {wildcards.chrom} --recode --stdout > {output.chrom_vcf}"

rule dgrp2_to_vcf_gz:
    input:
        vcf="data/dgrp2/dgrp2_{chrom}.biallelic.vcf"
    output:
        vcfgz="data/dgrp2/dgrp2_{chrom}.biallelic.vcf.gz"
    threads:
        1
    shell:
        "gzip -k {input.vcf}"

rule dgrp2_to_bed:
    input:
        vcf="data/dgrp2/dgrp2_{chrom}.biallelic.vcf"
    output:
        bed="data/dgrp2/dgrp2_{chrom}.biallelic.bed"
    threads:
        1
    shell:
        "plink1.9 --vcf {input.vcf} --make-bed --allow-extra-chr --out data/dgrp2/dgrp2_{wildcards.chrom}.biallelic"

rule dgrp2_to_raw:
    input:
        bed="data/dgrp2/dgrp2_{chrom}.biallelic.bed"
    output:
        raw="data/dgrp2/dgrp2_{chrom}.biallelic.raw"
    threads:
        1
    shell:
        "plink1.9 --bfile data/dgrp2/dgrp2_{wildcards.chrom}.biallelic --recode A --allow-extra-chr --out data/dgrp2/dgrp2_{wildcards.chrom}.biallelic"

rule dgrp2_to_inveRsion:
    input:
        raw="data/dgrp2/dgrp2_{chrom}.raw"
    output:
        inveRsion="data/dgrp2/dgrp2_{chrom}.inveRsion"
    threads:
        1
    shell:
        "scripts/raw_to_inveRsion --input-raw {input.raw} --output-txt {output.inveRsion}"
        
## Process 1000 Anopheles Genomes VCFs
rule select_ag1000g_samples:
    input:
        vcf="data/raw_data/ag1000g.phase1.ar3.pass.biallelic.{chrom}.vcf.gz"
    output:
        vcf="data/ag1000g/ag1000g_{chrom}_bfaso.vcf.gz"
    threads:
        1
    shell:
        "vcftools --gzvcf {input.vcf} --recode --stdout --keep sample_lists/ag1000g_bfm_bfs_ids.txt --remove-indels --maf 0.01 | gzip -c > {output.vcf}"

rule select_ag1000g_gambiae_samples:
    input:
        vcf="data/ag1000g/ag1000g_{chrom}_bfaso.vcf.gz"
    output:
        vcf="data/ag1000g/ag1000g_{chrom}_bfaso_gambiae.vcf.gz"
    threads:
        1
    shell:
        "vcftools --gzvcf {input.vcf} --recode --stdout --keep sample_lists/ag1000g_bfs_ids.txt --maf 0.01 | gzip -c > {output.vcf}"

rule select_ag1000g_coluzzii_samples:
    input:
        vcf="data/ag1000g/ag1000g_{chrom}_bfaso.vcf.gz"
    output:
        vcf="data/ag1000g/ag1000g_{chrom}_bfaso_coluzzii.vcf.gz"
    threads:
        1
    shell:
        "vcftools --gzvcf {input.vcf} --recode --stdout --keep sample_lists/ag1000g_bfm_ids.txt --maf 0.01 | gzip -c > {output.vcf}"

rule ag1000g_to_bed:
    input:
        vcf="data/ag1000g/ag1000g_{chrom}.vcf.gz"
    output:
        bed="data/ag1000g/ag1000g_{chrom}.bed"
    threads:
        1
    shell:
        "plink1.9 --vcf {input.vcf} --set-missing-var-ids '@_#_\$1_\$2' --make-bed --allow-extra-chr --out data/ag1000g/ag1000g_{wildcards.chrom}"

rule ag1000g_to_raw:
    input:
        bed="data/ag1000g/ag1000g_{chrom}.bed"
    output:
        raw="data/ag1000g/ag1000g_{chrom}.raw"
    threads:
        1
    shell:
        "plink1.9 --bfile data/ag1000g/ag1000g_{wildcards.chrom} --recode A --allow-extra-chr --out data/ag1000g/ag1000g_{wildcards.chrom}"

rule ag1000g_to_inveRsion:
    input:
        raw="data/ag1000g/ag1000g_{chrom}.raw"
    output:
        inveRsion="data/ag1000g/ag1000g_{chrom}.inveRsion"
    threads:
        1
    shell:
        "scripts/raw_to_inveRsion --input-raw {input.raw} --output-txt {output.inveRsion}"

## Process Helianthus annuus data

# chromosomes with identified inversions
# from https://github.com/owensgl/wild_gwas_2018/blob/master/MDS_outliers/Ha412HO/annuus/Ha412HO_inv.v3.pcasites.vcf
annuus_inv_chromosomes = ["Ha412HOChr01",
                          "Ha412HOChr05",
                          "Ha412HOChr11",
                          "Ha412HOChr13",
                          "Ha412HOChr14",
                          "Ha412HOChr15",
                          "Ha412HOChr16",
                          "Ha412HOChr17"]

# from https://github.com/owensgl/wild_gwas_2018/blob/master/MDS_outliers/Ha412HO/petiolaris/Ha412HO_inv.v3.pcasites.vcf
pet_inv_chromosomes = ["Ha412HOChr01",
                       "Ha412HOChr05",
                       "Ha412HOChr06",
                       "Ha412HOChr07",
                       "Ha412HOChr08",
                       "Ha412HOChr09",
                       "Ha412HOChr10",
                       "Ha412HOChr11",
                       "Ha412HOChr12",
                       "Ha412HOChr13",
                       "Ha412HOChr14",
                       "Ha412HOChr16",
                       "Ha412HOChr17"]


rule split_annuus_by_chrom:
    input:
        vcf="data/raw_data/Annuus.ann_env.tranche90_snps_bi_AN50_AF99.vcf.gz"
    output:
        chrom_vcf="data/annuus/annuus_env_{chrom}.vcf.gz"
    threads:
        1
    shell:
        "vcftools --gzvcf {input.vcf} --chr {wildcards.chrom} --recode --stdout | gzip -c > {output.chrom_vcf}"

rule split_pet_by_chrom:
    input:
        vcf="data/raw_data/Petiolaris.pet_gwas.tranche90_snps_bi_AN50_AF99.vcf.gz"
    output:
        chrom_vcf="data/petiolaris/petiolaris_gwas_{chrom}.vcf.gz"
    threads:
        1
    shell:
        "vcftools --gzvcf {input.vcf} --chr {wildcards.chrom} --recode --stdout | gzip -c > {output.chrom_vcf}"

## Process blue tit (Cyanistes caeruleus) data
cyanistes_inv_chromosomes = ["chromo.03"]

rule split_cyanistes_by_chrom:
    input:
        vcf="data/raw_data/BLUE2020VCF.vcf.gz"
    output:
        chrom_vcf="data/cyanistes/cyanistes_{chrom}.vcf.gz"
    threads:
        1
    shell:
        "vcftools --gzvcf {input.vcf} --chr {wildcards.chrom} --recode --stdout | gzip -c > {output.chrom_vcf}"

## Process peach (Prunus persica) data
prunus_inv_chromosomes = ["Pp06"]

rule split_prunus_by_chrom:
    input:
        vcf="data/raw_data/SNP.vcf.gz"
    output:
        chrom_vcf="data/prunus/prunus_{chrom}.vcf.gz"
    threads:
        1
    shell:
        "vcftools --gzvcf {input.vcf} --chr {wildcards.chrom} --recode --stdout | gzip -c > {output.chrom_vcf}"

        
## Top-level rules
rule prepare_dgrp2:
    input:
        dgrp=expand("data/dgrp2/dgrp2_{chrom}.biallelic.{format}",
                    chrom=["2L", "2R", "3R", "3L"],
                    format=config["formats"])

rule prepare_ag1000g:
    input:
        ag1000g_bfaso=expand("data/ag1000g/ag1000g_{chrom}_bfaso.{format}",
                             chrom=["2L", "2R", "3L"],
                             format=config["formats"]),
        ag1000g_bfaso_gambiae=expand("data/ag1000g/ag1000g_{chrom}_bfaso_gambiae.{format}",
                                     chrom=["2L", "2R", "3L"],
                                     format=config["formats"]),
        ag1000g_bfaso_coluzii=expand("data/ag1000g/ag1000g_{chrom}_bfaso_coluzzii.{format}",
                                     chrom=["2L", "2R", "3L"],
                                     format=config["formats"])

rule prepare_annuus:
    input:
        annuus_by_chrom=expand("data/annuus/annuus_env_{chrom}.vcf.gz",
                               chrom=annuus_inv_chromosomes)

rule prepare_petiolaris:
    input:
        pet_by_chrom=expand("data/petiolaris/petiolaris_gwas_{chrom}.vcf.gz",
                            chrom=pet_inv_chromosomes)

rule prepare_cyanistes:
    input:
        cyanistes_by_chrom=expand("data/cyanistes/cyanistes_{chrom}.vcf.gz",
                                  chrom=cyanistes_inv_chromosomes)

rule prepare_prunus:
    input:
        prunus_by_chrom=expand("data/prunus/prunus_{chrom}.vcf.gz",
                               chrom=prunus_inv_chromosomes)
