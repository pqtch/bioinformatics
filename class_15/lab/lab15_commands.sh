#!/bin/bash

#######################################################
##### Lab 15: Retrieving Genomic Data from NCBI #######
##### Patch Shields — 2026-10-22 ######################
#######################################################

### run on erdos, in the conda env from lab 16
conda activate bioinformatics
conda install bioconda::entrez-direct conda-forge::ncbi-datasets-cli

mkdir -p ~/lab15
cd ~/lab15

### 1. 16S rRNA sequences for the genus Anopheles (the tutorial query with the genus swapped)
esearch -db nuccore -query \
  '"Anopheles"[Organism] AND ("16S ribosomal RNA"[Title] OR rrnL[Gene] OR 16S[Gene]) NOT ("12S"[Title] OR COI[Title] OR COIII[Title] OR cytb[Title] OR "complete genome"[Title] OR "whole genome"[Title] OR NADH[Title])' \
  | efetch -format fasta > Anopheles_16S_rRNA.fasta
grep -c '^>' Anopheles_16S_rRNA.fasta

### 2. Saccharomyces cerevisiae S288C reference genome (R64)
accession=GCF_000146045.2
datasets download genome accession "$accession" \
  --include gff3,rna,cds,protein,genome,seq-report --filename "${accession}.zip"
unzip -q ${accession}.zip -d $accession
d=$accession/ncbi_dataset/data/$accession
grep -c '^>' $d/rna.fna
grep -c '^>' $d/cds_from_genomic.fna
grep -c '^>' $d/protein.faa

### 3. raw reads for S. cerevisiae: SRR41062962, downloaded and counted in ../../class_16/lab/lab16_commands.sh

conda deactivate
