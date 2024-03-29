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

import yaml

with open("inversions.yaml", "r") as fl:
    inversions = yaml.safe_load(fl)

print(inversions)

# Parameters
MAF=0.01

## process Drosophila Genetics Reference Panel v2 VCFs
rule filter_dgrp2_vcf:
    input:
        vcf="input_files/dgrp2.vcf"
    params:
        maf=MAF
    output:
        filtered_vcf="data/dgrp2/dgrp2_{chrom}.biallelic.vcf.gz"
    threads:
        1
    shell:
        "vcftools --vcf {input.vcf} --min-alleles 2 --max-alleles 2 --remove-indels --maf {params.maf} --recode --stdout --remove-indv line_348 --remove-indv line_350 --remove-indv line_358 --remove-indv line_385 --remove-indv line_392 --remove-indv line_395 --remove-indv line_399 --chr {wildcards.chrom} | gzip -c > {output.filtered_vcf}"
        
rule generate_inversion_vcf_full:
    input:
        lambda w: inversions[w.dataset]["input"]
    params:
        chrom=lambda w: inversions[w.dataset]["chrom"],
        keep=lambda w: "" if "sample_ids" not in inversions[w.dataset] else "--keep {}".format(inversions[w.dataset]["sample_ids"]),
        exclude=lambda w: "" if "exclude" not in inversions[w.dataset] else " ".join("--remove-indv {}".format(indv) for indv in inversions[w.dataset]["exclude"]),
        # for some reason, the maf flag causes a "munmap_chunk(): invalid pointer" in VCFTools just for this data set
        maf=lambda w: "" if w.dataset.startswith("prunus") else "--maf {}".format(MAF)
    output:
        "output_files/{dataset}_full.vcf.gz"
    threads:
        1
    shell:
        "vcftools --gzvcf {input} --chr {params.chrom} {params.keep} {params.exclude} {params.maf} --recode --stdout | gzip -c > {output}"

rule generate_inversion_vcf_window:
    input:
        "output_files/{inversion}_full.vcf.gz"
    params:
        chrom=lambda w: inversions[w.inversion]["chrom"],
        keep=lambda w: "" if "sample_ids" not in inversions[w.inversion] else "--keep {}".format(inversions[w.inversion]["sample_ids"]),
        sites=lambda w: "--bed {}".format(inversions[w.inversion]["window"]),
        exclude=lambda w: "" if "exclude" not in inversions[w.inversion] else " ".join("--remove-indv {}".format(indv) for indv in inversions[w.inversion]["exclude"]),
        # for some reason, the maf flag causes a "munmap_chunk(): invalid pointer" in VCFTools just for this data set
        maf=lambda w: "" if w.dataset.startswith("prunus") else "--maf {}".format(MAF)
    output:
        "output_files/{inversion}_window.vcf.gz"
    threads:
        1
    shell:
        "vcftools --gzvcf {input} --chr {params.chrom} {params.keep} {params.sites} {params.exclude} {params.maf} --recode --stdout | gzip -c > {output}"

rule generate_inversion_npz:
    input:
        "output_files/{inversion}_full.vcf.gz"
    params:
        bed_files=lambda w: "--bed-fls " + " ".join(inversions[w.inversion]["inversions"].values()) if "inversions" in inversions[w.inversion] else ""
    output:
        "output_files/{inversion}_full.npz"
    threads:
        1
    shell:
        "./scripts/vcf_to_npz --vcf-fl {input} {params.bed_files} --npz-fl {output}"
        
# define data sets here so we can create rules that depend
# on individual data sets and the entire set
all_output_files = []
full_output_files = []
window_output_files = []
for dataset, params in inversions.items():
    flname = "output_files/{}_full.vcf.gz".format(dataset)
    all_output_files.append(flname)

    flname = "output_files/{}_full.npz".format(dataset)
    all_output_files.append(flname)

all_output_files.sort()

rule prepare_all:
    input:
        all_output_files
