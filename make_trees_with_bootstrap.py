import os, subprocess, sys

_, fasta, phylip, num_bootstrap = sys.argv

num_bootstrap = int(num_bootstrap)

fasttree = os.path.join("trees", os.path.basename(fasta).split(".")[0] + "_FT.nwk")
phyml = os.path.join("trees", os.path.basename(phylip).split(".")[0] + "_ML.nwk")
phylip_stats = os.path.join("trees", os.path.basename(phylip).split(".")[0] + "_ML_stats.txt")
bs_trees = os.path.join("trees", os.path.basename(phylip).split(".")[0] + "_ML_boot_trees.txt")
bs_stats = os.path.join("trees", os.path.basename(phylip).split(".")[0] + "_ML_boot_stats.txt")

# create fasttree tree
subprocess.run(f"fasttree -nt {fasta} > {fasttree}", shell=True)

# create phyml tree and compute SH-like branch support values, which is what FastTree computes
subprocess.run(f"phyml --input {phylip} --inputtree {fasttree} -o tlr --datatype nt --bootstrap {num_bootstrap}",
               shell=True)

old_phyml_tree = phylip + "_phyml_tree.txt"
old_phyml_stats = phylip + "_phyml_stats.txt"
old_phyml_bs_trees = phylip + "_phyml_boot_trees.txt"
old_phyml_bs_stats = phylip + "_phyml_boot_stats.txt"

subprocess.run(f"mv {old_phyml_tree} {phyml}", shell=True)
subprocess.run(f"mv {old_phyml_stats} {phylip_stats}", shell=True)
subprocess.run(f"mv {old_phyml_bs_trees} {bs_trees}", shell=True)
subprocess.run(f"mv {old_phyml_bs_stats} {bs_stats}", shell=True)

# convert PhyML bootstrap numbers to proportion (proportion of bootstrap replicates that support a split)
with open(phyml, "r") as file:
    lines = file.readlines()
    lines = [line.strip("\n") for line in lines]
    
if len(lines) == 1:
    lines = lines[0]
else:
    raise ValueError(f"More than one line in {phylip}!")
    
oldlines_list = lines.split(":")
newlines = []

for i, line in enumerate(oldlines_list):
    
    if ")" in line:
        sep = line.split(")")
        for k, string in enumerate(sep):
            # excludes decimals and negative numbers. 
            # Put parentheses back in because the split function removes them
            if string.isnumeric():
                sep[k] = ")" + str(int(string) / num_bootstrap)
        if i == 0:
            newlines.append("".join(sep))
        else:
            newlines.append(":" + "".join(sep))
    else:
        if i == 0:
            newlines.append(line)
        else:
            newlines.append(":" + line)
    
assert len(newlines) == len(oldlines_list)
    
with open(phyml, "w+") as file:
    file.write("".join(newlines)[:-1] + ");")