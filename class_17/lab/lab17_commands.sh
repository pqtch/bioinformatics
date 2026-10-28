#!/bin/bash

#######################################################
##### Lab 17: 16S rRNA MSA with MAFFT (erdos) #########
##### Patch Shields — 2026-10-26 ######################
#######################################################

### run on erdos: ssh pshields@erdos.dsm.fordham.edu
### a new login forgets the env, so efetch is "command not found" until this runs
conda activate bioinformatics
cd ~/mafft_16s_rrna_gene_msa

### lineage: Pelecaniformes (herons, pelicans, ibises)
### Butorides (green heron) returned 0 records and Ardeidae 4: bird 16S is mostly in complete mitogenomes, which this query excludes
esearch -db nuccore -query \
  '"Pelecaniformes"[Organism] AND ("16S ribosomal RNA"[Title] OR rrnL[Gene] OR 16S[Gene]) NOT ("12S"[Title] OR COI[Title] OR COIII[Title] OR cytb[Title] OR "complete genome"[Title] OR "whole genome"[Title] OR NADH[Title])' \
  | efetch -format fasta > 16s_rrna_msa.fasta
grep -c '^>' 16s_rrna_msa.fasta        # 49
### curl (56) "unexpected eof" errors on erdos are noise: HTTP 200, all 49 records arrived

### align
~/mafft-linux64/mafft.bat --auto 16s_rrna_msa.fasta > pelecaniformes_16s_mafft.fasta
grep -c '^>' pelecaniformes_16s_mafft.fasta        # 49

### copy to the laptop (run there, one scp per file)
scp pshields@erdos.dsm.fordham.edu:mafft_16s_rrna_gene_msa/pelecaniformes_16s_mafft.fasta /mnt/c/Users/patch_khnh06k/Downloads/
