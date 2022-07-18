import os, subprocess, sys

_, phylip_file, num_bootstrap = sys.argv
   
# perform model selection
subprocess.run(f"iqtree -s {phylip_file} -m MFP -redo", shell=True)

# get the best fit model, which is on the 37th line of the output file. Default selection is minimizing the Bayesian information criterion
with open(f"{phylip_file}.iqtree") as file:
    lines = file.readlines()

best_model = "".join(lines[36].split()).split(":")[1]
print(f"Selected codon substitution model: {best_model}\n")

# construct the tress using the best model, with bootstrapping
subprocess.run(f"iqtree -s {phylip_file} -m {best_model} -B {num_bootstrap} -redo", shell=True)

# convert bootstrap numbers (95 vs. 0.95) to proportion (proportion of bootstrap replicates that support a split)
with open(f"{phylip_file}.treefile", "r") as file:
    lines = file.readlines()
    lines = [line.strip("\n") for line in lines]
    
if len(lines) == 1:
    lines = lines[0]
else:
    raise ValueError(f"More than one line in {phylip_file}.treefile!")
    
oldlines_list = lines.split(":")
newlines = []

for i, line in enumerate(oldlines_list):
    if ")" in line:
        sep = line.split(")")
        for k, string in enumerate(sep):
            # excludes decimals and negative numbers. 
            # Put parentheses back in because the split function removes them
            if string.isnumeric():
                sep[k] = ")" + str(int(string) / 100)
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
    
with open(f"{phylip_file}.treefile", "w+") as file:
    file.write("".join(newlines)[:-1] + ");")
    
# move the iqtree and actual tree files to the trees folder, then delete all the remaining files. Contree is the consensus tree file that contains BS support values
new_phylip_name = os.path.join("niv_evo/trees", os.path.basename(f"{phylip_file}.iqtree".split(".")[0] + "_iqtree.txt"))
new_tree_name = os.path.join("niv_evo/trees", os.path.basename(f"{phylip_file}.treefile").split(".")[0] + "_iqtree.nwk")
    
subprocess.run(f"mv {phylip_file}.iqtree {new_phylip_name}", shell=True)
subprocess.run(f"mv {phylip_file}.treefile {new_tree_name}", shell=True)

# delete all the resulting files except the .iqtree file
subprocess.run(f"rm {phylip_file}.*", shell=True)