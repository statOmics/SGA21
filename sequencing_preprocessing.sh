#!/bin/sh

## Here, we will download and quantify the data from the parathyroid study,
## deposited at GEO: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE37211

### PRELIMINARIES

## Browse to desired working directory
cd /Users/koenvandenberge/tmp/

## Download reference genome
wget http://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_38/GRCh38.p13.genome.fa.gz 

## Download GTF file
wget http://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_38/gencode.v38.annotation.gtf.gz

## Download reference transcriptome
wget http://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_38/gencode.v38.transcripts.fa.gz

## Download FASTQ-files (we'll only download the first sample)
### Downloading manually (needs sra toolkit for fasterq-dump)
wget https://sra-pub-run-odp.s3.amazonaws.com/sra/SRR479052/SRR479052
fasterq-dump SRR479052

## Downloading using custom software: kingfisher (https://github.com/wwood/kingfisher-download)
kingfisher get -r SRR479052 -m ena-ascp aws-http prefetch

## QC of FASTQ-files using FastQC
fastqc SRR479052_1.fastq
fastqc SRR479052_2.fastq

### GENOME ALIGNMENT (STAR)
## Download and install STAR: https://github.com/alexdobin/STAR

## Index reference genome (takes a while!)
gunzip GRCh38.p13.genome.fa.gz
gunzip gencode.v38.annotation.gtf.gz
STAR --runThreadN 2 \
  --runMode genomeGenerate \
  --genomeDir . \
  --genomeFastaFiles GRCh38.p13.genome.fa \
  --sjdbGTFfile gencode.v38.annotation.gtf \
  --sjdbOverhang 99 #read length -1

## Alignment of FASTQ-files
STAR --runThreadN 2 \
--runMode alignReads \
--genomeDir my_genome \
--readFilesIn SRR479052_1.fastq \
  SRR479052_1.fastq \
--readFilesCommand zcat \
--outFileNamePrefix output/SRR479052 \
--outSAMtype BAM SortedByCoordinate \
--quantMode GeneCounts

### TRANSCRIPTOME ALIGNMENT (kallisto/salmon)

## Index reference transcriptome
### using salmon (https://combine-lab.github.io/salmon/)
salmon index -i gencode.v38.transcriptsIndex.idx \
         -t gencode.v38.transcripts.fa.gz

### using kallisto (https://pachterlab.github.io/kallisto/about)
kallisto index -i gencode.v38.transcriptsIndex.idx \
           gencode.v38.transcripts.fa.gz

## Alignment of FASTQ-files
### using salmon
salmon quant -i gencode.v38.transcriptsIndex.idx -l A \
         -1 SRR479052_1.fastq -2 SRR479052_2.fastq \
         -p 2 -o output/SRR479052 --validateMappings \
        --seqBias --gcBias

### using kallisto
kallisto quant -i gencode.v38.transcriptsIndex.idx \
           -o output/SRR479052 -t 2 \
           SRR479052_1.fastq SRR479052_2.fastq
           
#  sequencing_preprocessing.sh
#  
#
#  Created by Koen Van den Berge on 11/2/21.