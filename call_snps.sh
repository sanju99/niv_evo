# command line arguments: genome_file, in_fasta_file, out_file_prefix

source activate sambcftools

# Index the genome file (broken up by CDS)
bwa index $1

# Perform the alignment
bwa aln $1 $2 > "$3_aln.sai"

# Convert to SAM file format, which is human-readable
bwa samse $1 "$3_aln.sai" $2 > "$3_aln.sam"

# Convert SAM to BAM and sort the BAM file
samtools view -S -b "$3_aln.sam" > "$3_aln.bam"
samtools sort "$3_aln.bam" -o "$3_aln_sorted.bam"

# Index the genome file again with samtools
samtools faidx $1

# Run 'mpileup' to generate BCF format
bcftools mpileup -f $1 "$3_aln_sorted.bam" > "$3_aln.bcf"

# Call SNPs
bcftools view -v snps "$3_aln.bcf" > "$3_SNPs.vcf"