# Nipah Virus Evolutionary Analysis

Summer project at <a href="https://www.ecohealthalliance.org/program/ecohealthnet" target="_blank">EcoHealthNet</a>

## Project Goals

## Workflow

Reference Nipah virus genomes (used coding DNA sequences only):

<ul>
  <li>Malaysian strain: <a href="https://www.ncbi.nlm.nih.gov/nuccore/NC_002728.1" target="_blank">NC_002728.1</a></li>
  <li>Bangladeshi strain: <a href="https://www.ncbi.nlm.nih.gov/nuccore/AY988601.1" target="_blank">AY988601.1</a></li>
</ul>

All publicly available sequences were gathered from the NCBI. This was done by searching one nucleotide sequence for each protein against all Henipaviruses. 83 glycoprotein and 80 phosphoprotein sequences were gathered in this way. Some of the G sequences especially contain a lot of ambiguous sites because of quality control issues. Several of these were isolated from bats.

<!-- After removing extremely low-quality sequences (too many ambiguous nucleotides due to quality control issues, prevents alignment to the reference sequences), there were 79 glycoprotein and 79 phosphoprotein sequences (76/79 are from the same isolates).
 -->
 
### Deduplication

After deduplication of the sequences, 50 glycoprotein (60%) and 51 phosphoprotein (64%) sequences remained. 

Sequences that may be of too low quality and could cause problems in analyses, so just watch out for them:

<ul>
  <li>MH891774 in <code>sequences/PG/P_seqs.fasta</code></li>
  <li>JF899340, MH891777, MN549407, and MN549410 in <code>sequences/PG/G_seqs.fasta</code></li>
</ul>
