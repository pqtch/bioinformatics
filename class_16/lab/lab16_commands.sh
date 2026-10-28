#!/bin/bash

#####################################################
##### Lab 16: QC of NGS Reads with fastp (erdos) ####
##### Patch Shields — 2026-10-22 ####################
#####################################################

### run on erdos: ssh pshields@erdos.dsm.fordham.edu

### conda environment with fastp and the SRA Toolkit (no root on erdos, so install into an env)
conda create -n bioinformatics python=3.14.7
conda activate bioinformatics
conda install bioconda::fastp
conda install bioconda::sra-tools
fastp --version        # fastp 1.4.0

### download the reads: Saccharomyces cerevisiae WGS, Illumina NovaSeq X, paired-end
mkdir ~/qc_ngs_reads
cd ~/qc_ngs_reads
fasterq-dump SRR41062962

### compress both files in parallel
gzip SRR41062962_1.fastq &
gzip SRR41062962_2.fastq &
wait

### count reads (4 lines per FASTQ record): 4,049,454 in each file
gzip -dc SRR41062962_1.fastq.gz | wc -l | awk '{print $1/4}'
gzip -dc SRR41062962_2.fastq.gz | wc -l | awk '{print $1/4}'

### run fastp: 3,978,033 pairs passed the filter
fastp -i SRR41062962_1.fastq.gz -I SRR41062962_2.fastq.gz \
      -o SRR41062962_1_trimmed.fastq.gz -O SRR41062962_2_trimmed.fastq.gz \
      --detect_adapter_for_pe \
      -h paired_fastp_report_SRR41062962.html

conda deactivate
exit

### on the laptop: copy the report into this repo
scp pshields@erdos.dsm.fordham.edu:~/qc_ngs_reads/paired_fastp_report_SRR41062962.html class_16/lab/
scp pshields@erdos.dsm.fordham.edu:~/qc_ngs_reads/fastp.json class_16/lab/
