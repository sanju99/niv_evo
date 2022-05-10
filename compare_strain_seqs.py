import numpy as np
import pandas as pd

import Bio
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
from Bio.Seq import Seq


bgd_ref_seqs = []
mys_ref_seqs = []

for seq_record in SeqIO.parse("sequences/genome/AY988601.1_BGD_CDS.fna", "fasta"):
    
    if "glycoprotein" in seq_record.id or "phosphoprotein" in seq_record.id:
        bgd_ref_seqs.append([seq_record.id, seq_record.seq])
        
for seq_record in SeqIO.parse("sequences/genome/NC_00278.1_MYS_CDS.fna", "fasta"):
    
    if "glycoprotein" in seq_record.id or "phosphoprotein" in seq_record.id:
        mys_ref_seqs.append([seq_record.id, seq_record.seq])
        
        
def compare_strings(str1, str2):
    '''
    Compare two strings by character. Both strings must be the same length (no indels), so only looks for SNVs.
    '''
    if type(str1) != str:
        str1 = str(str1)
    if type(str2) != str:
        str2 = str(str2)
        
    assert len(str1) == len(str2)
        
    diff_ind = [i for i in range(len(str1)) if str1[i] != str2[i]]
    
    print(f"{len(diff_ind)} out of {len(str1)} sites differ!")
    return diff_ind


def record_strain_diffs(str1, str2, name1, name2):
    '''
    Record the positions and nucleotides that differ between two strings.
    '''
    diff_ind = compare_strings(str1, str2)
    
    # arrays of nucleotides differing between strings 1 and 2
    diff_1 = np.array(list(str(str1)))[np.array(diff_ind)]
    diff_2 = np.array(list(str(str2)))[np.array(diff_ind)]
    
    # convert positions to 1-indexing
    res = pd.DataFrame({"Position": np.array(diff_ind)+1, name1: diff_1, name2: diff_2})
    assert sum(res[name1] == res[name2]) == 0
    return res


# identify differences in the phospho and glycoproteins
diff_P = record_strain_diffs(bgd_ref_seqs[0][1], mys_ref_seqs[0][1], "BGD", "MYS")
diff_G = record_strain_diffs(bgd_ref_seqs[1][1], mys_ref_seqs[1][1], "BGD", "MYS")

# create a dataframe with all the results and save it to a CSV
diff_P["Protein"] = ["P"]*len(diff_P)
diff_G["Protein"] = ["G"]*len(diff_G)
strain_diffs = pd.concat([diff_P, diff_G])
strain_diffs.to_csv("sequences/strain_differences.csv", index=False)