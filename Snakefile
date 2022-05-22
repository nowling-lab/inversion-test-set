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

import yaml

with open("inversions.yaml", "r") as fl:
    inversions = yaml.safe_load(fl)

print(inversions)

## process Drosophila Genetics Reference Panel v2 VCFs
rule filter_dgrp2_vcf:
    input:
        vcf="input_files/dgrp2.vcf"
    output:
        filtered_vcf="data/dgrp2/dgrp2_{chrom}.biallelic.vcf.gz"
    threads:
        1
    shell:
        "vcftools --vcf {input.vcf} --min-alleles 2 --max-alleles 2 --remove-indels --maf 0.01 --recode --stdout --remove-indv line_348 --remove-indv line_350 --remove-indv line_358 --remove-indv line_385 --remove-indv line_392 --remove-indv line_395 --remove-indv line_399 --chr {wildcards.chrom} | gzip -c > {output.filtered_vcf}"
        
rule generate_inversion_vcf_full:
    input:
        lambda w: inversions[w.inversion]["input"]
    params:
        chrom=lambda w: inversions[w.inversion]["chrom"],
        keep=lambda w: "" if "sample_ids" not in inversions[w.inversion] else "--keep {}".format(inversions[w.inversion]["sample_ids"]),
        exclude=lambda w: "" if "exclude" not in inversions[w.inversion] else " ".join("--remove-indv {}".format(indv) for indv in inversions[w.inversion]["exclude"])
    output:
        "data/output_files/{inversion}_full.vcf.gz"
    threads:
        1
    shell:
        "vcftools --gzvcf {input} --chr {params.chrom} {params.keep} {params.exclude} --maf 0.05 --recode --stdout | gzip -c > {output}"

rule generate_inversion_vcf_window:
    input:
        "data/output_files/{inversion}_full.vcf.gz"
    params:
        chrom=lambda w: inversions[w.inversion]["chrom"],
        keep=lambda w: "" if "sample_ids" not in inversions[w.inversion] else "--keep {}".format(inversions[w.inversion]["sample_ids"]),
        sites=lambda w: "--bed {}".format(inversions[w.inversion]["window"]),
        exclude=lambda w: "" if "exclude" not in inversions[w.inversion] else " ".join("--remove-indv {}".format(indv) for indv in inversions[w.inversion]["exclude"])
    output:
        "data/output_files/{inversion}_window.vcf.gz"
    threads:
        1
    shell:
        "vcftools --gzvcf {input} --chr {params.chrom} {params.keep} {params.sites} {params.exclude} --maf 0.05 --recode --stdout | gzip -c > {output}"
        
# define data sets here so we can create rules that depend
# on individual data sets and the entire set
output_files = []
for name, params in inversions.items():
    flname = "data/output_files/{}_full.vcf.gz".format(name)
    output_files.append(flname)

    if "window" in params:
        flname = "data/output_files/{}_window.vcf.gz".format(name)
        output_files.append(flname)

output_files.sort()

rule prepare_all:
    input:
        output_files
