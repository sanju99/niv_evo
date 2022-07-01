import os, subprocess, sys

_, fasta, phylip = sys.argv


fasttree = os.path.join("trees", os.path.basename(fasta).split(".")[0] + "_FT.nwk")
phyml = os.path.join("trees", os.path.basename(phylip).split(".")[0] + "_ML.nwk")
phylip_stats = os.path.join("trees", os.path.basename(phylip).split(".")[0] + "_ML_stats.txt")

# create fasttree tree
subprocess.run(f"fasttree -nt {fasta} > {fasttree}", shell=True)

# create phyml tree and compute SH-like branch support values, which is what FastTree computes
subprocess.run(f"phyml --input {phylip} --inputtree {fasttree} -o tlr --datatype nt --bootstrap -4",
               shell=True)

old_phyml_tree = phylip + "_phyml_tree.txt"
old_phyml_stats = phylip + "_phyml_stats.txt"

subprocess.run(f"mv {old_phyml_tree} {phyml}", shell=True)
subprocess.run(f"mv {old_phyml_stats} {phylip_stats}", shell=True)