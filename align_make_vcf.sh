# command line arguments: genome_file, fasta_to_be_aligned, output_dir, output_name

# Index the genome file (broken up by CDS)
bwa index $1

# Perform the alignment
bwa aln $1 $2 > "$3/$4_aln.sai"

# Convert to SAM file format, which is human-readable
bwa samse $1 "$3/$4_aln.sai" $2 > "$3/$4_aln.sam"

# Convert SAM to BAM and sort the BAM file
samtools view -b "$3/$4_aln.sam" > "$3/$4_aln.bam"
samtools sort "$3/$4_aln.bam" -o "$3/$4_aln_sorted.bam"

# Index the genome file again with samtools
samtools faidx $1

# Run 'mpileup' to generate VCF format
bcftools mpileup -f $1 "$3/$4_aln_sorted.bam" > "$3/$4_aln.bcf"

# Call SNPs
bcftools view -v snps "$3/$4_aln.bcf" > "$3/$4_SNPs.vcf"