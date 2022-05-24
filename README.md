# Nipah Virus Evolutionary Analysis

Summer project at <a href="https://www.ecohealthalliance.org/program/ecohealthnet" target="_blank">EcoHealthNet</a>

# Project Goals

Perform evolutionary selection analysis of the glycoprotein and phosphoprotein of Nipah virus (NiV). 

# Workflow

## Sequence Gathering

Reference Nipah virus genomes (used coding DNA sequences only):

<ul>
  <li>Malaysian strain: <a href="https://www.ncbi.nlm.nih.gov/nuccore/NC_002728.1" target="_blank">NC_002728.1</a></li>
  <li>Bangladeshi strain: <a href="https://www.ncbi.nlm.nih.gov/nuccore/AY988601.1" target="_blank">AY988601.1</a></li>
</ul>

All publicly available sequences were gathered from the NCBI. This was done by searching one nucleotide sequence for each protein against all Henipaviruses. 83 glycoprotein and 80 phosphoprotein sequences were gathered in this way. Some of the G sequences especially contain a lot of ambiguous sites because of quality control issues. Several of these were isolated from bats.

<!-- After removing extremely low-quality sequences (too many ambiguous nucleotides due to quality control issues, prevents alignment to the reference sequences), there were 79 glycoprotein and 79 phosphoprotein sequences (76/79 are from the same isolates).
 -->
 
## Deduplication

For evolutionary selection analysis, we use only the unique sequences. After deduplication of the sequences, 50 glycoprotein (59.5%) and 51 phosphoprotein (63%) sequences remained. 

Sequences that may be of too low quality and could cause problems in analyses, so just watch out for them:

<ul>
  <li>MH891774 in <code>sequences/PG/P_seqs.fasta</code></li>
  <li>JF899340, MH891777, MN549407, and MN549410 in <code>sequences/PG/G_seqs.fasta</code></li>
</ul>

Many substitution models and evolutionary models analyze codons. When looking at dN and dS rates, these are of course done with a protein in mind. Therefore, we restrict our analyses to coding regiosn of the glyco- and phosphoprotein genes. The glycoprotein CDS is 1809 nucleotides long, and the phosphoprotein CDS is 2130 nucleotides. Most models use DNA, so the NiV (-) sense RNA has been converted to DNA (U-->T). 

## Construction of Trees using FastTree

FastTree was chosen because it's fast and probably sufficient for this project's needs. Because of the small number of sequences, Bayesian methods (i.e. BEAST) are probably not necessary. 

<code>
fasttree -nt sequences/PG/G_deduplicated.fasta > trees/G_dedup.nwk
</code>    


<code>
fasttree -nt sequences/PG/P_deduplicated.fasta > trees/P_dedup.nwk
</code>

## Evolutionary Selection Analysis

There are three primary classes of methods for inferring evolutionary selection:

1. <b>Counting-based methods:</b> Create an ancestral sequence reconstruction and compute dN and dS relative to this inferred ancestral sequence. Computationally fast, but have low power for small datasets with few substitutions. This can lead to underestimation of the true number of substitutions.
2. <b>Fixed effects model:</b> Fit substitution rates on a site-by-site basis without making assumptions about the distribution of rates across the sites. Can be slow on large datasets becuase of the large number of parameters. Use maximum likelhood estimation.
3. <b>Random effects model:</b> Fit a distribution of substitution rates across sites and then infer the rate at which each individual site evolves. Estimation of the rate distribution can have large errors for small datasets. This causes hierarchical Bayes to be very sensitive to the prior distribution, and empirical Bayes to be misleading. Maximum likelihood -> empirical, posterior distribution of rate parameters -> hierarchical. 

### HyPhy (Hypothesis Testing using Phylogenies)

Methods comparison <a href="https://academic.oup.com/mbe/article/22/5/1208/1066893" target="_blank">paper</a>. From this, it seems that we want a <b>fixed effects model that does NOT assume the same substitution rate across sites. </b> This method produces the fewest false positives for the small sample size we have (~50 sequences for each gene), is not as conservative as counting methods and is less likely to underestimate the substitution rate, and accounts for variation in substitution rate across sites. Even within a single gene, I expect variation in substitution rate across sites. 

<b>NOTE:</b> <a href="https://www.ncbi.nlm.nih.gov/nuccore/MK575063" target="_blank">MK575063</a> in the phosphoprotein sequence was modified to have deletion characters after the premature stop codon. Stop codons throw errors in HyPhy.

View results using this <a href="http://vision.hyphy.org" target="_blank">tool</a> to analyze the JSON files output by HyPhy.

## SNP Calling

### Perform ancestral sequence reconstruction with <a href="https://github.com/neherlab/treetime#metadata-and-date-format" target="_blank">TreeTime</a>. 

<code>
treetime ancestral --aln sequences/PG/G_deduplicated.fasta --tree trees/G_dedup.nwk
</code>


<code>
treetime ancestral --aln sequences/PG/P_deduplicated.fasta --tree trees/P_dedup.nwk
</code>
