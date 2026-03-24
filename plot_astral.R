# Read, edit and plot the ASTRAL tree
# EP, 27-feb-2026

setwd("/Users/epante/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/soda/out_trees/uce100p_astral")
list.files()

library(ape)

# Inputs

tree_file <- "/Users/epante/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/soda/out_trees/uce100p_astral/mafft-internal-trimmed-gblocks-clean-100p-raxml_pp1.charsets.tree"
map_file  <- "/Users/epante/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/soda/out_trees/uce100p_astral/tip_labels.txt"
outgroup_tips <- c("Keratoisididae_clade_S1_OCT090", "Jasonisis_thresheri_OCT052", "Orstomisis_crosnieri_OCT053")

# -----------------------
# 1) Read & edit the tree
# -----------------------
tr <- read.tree(tree_file)

# -----------------------
# first deal with terminal branch lengths: 
# -----------------------

# replace NaN with NA first
tr$edge.length[is.nan(tr$edge.length)] <- NA

# identify terminal edges
tip_edges <- which(tr$edge[,2] <= Ntip(tr))

# terminal branches length
x=0.5
# set terminal branches to length = x
tr$edge.length[tip_edges] <- x

# if any remaining NA (rare internal issues), set to 0
tr$edge.length[is.na(tr$edge.length)] <- 0

# -----------------------
# remove quotes from node lablels
# -----------------------

# remove both single and double quotes from node labels
tr$node.label <- gsub("[\"']", "", tr$node.label)

# convert to numeric
nl <- suppressWarnings(as.numeric(tr$node.label))

# format for plotting
tr$node.label <- ifelse(
  is.na(nl), tr$node.label,
formatC(round(nl, 2), digits = 2, format = "f")  # 2 decimals
)

# -----------------------
# 2) Root the tree to the OUTGROUP CLADE
# -----------------------
missing_og <- setdiff(outgroup_tips, tr$tip.label)
if (length(missing_og) > 0) {
  stop("These outgroup tip labels are not found in the tree:\n  ",
       paste(missing_og, collapse = ", "))
}

mrca_node <- getMRCA(tr, outgroup_tips)
if (is.null(mrca_node) || is.na(mrca_node)) {
  stop("Could not compute MRCA for the outgroup tips. Double-check tip labels.")
}

tr_root <- root(tr, node = mrca_node, resolve.root = TRUE)

# ladderize to make it prettier
tr_root <- ladderize(tr_root, right = FALSE)

# -----------------------
# 3) Apply custom tip labels from the 2-column mapping table
# -----------------------

map <- read.table(map_file, header = FALSE, sep = "\t",
                  stringsAsFactors = FALSE, quote = "", comment.char = "")

old <- map[[1]]
new <- map[[2]]

# Replace only those that match
idx <- match(tr_root$tip.label, old)
has_match <- !is.na(idx)
tr_root$tip.label[has_match] <- new[idx[has_match]]

# warnings about unmapped tips:
unmapped <- tr_root$tip.label[!has_match]
message("Unmapped tips (kept as-is): ", paste(unmapped, collapse = ", "))

# -----------------------
# 4) Plot WITH branch lengths and numeric node labels
# -----------------------

# Basic plot (phylogram uses edge lengths)
plot(tr_root,
     type = "phylogram",
     use.edge.length = TRUE,
     show.tip.label = TRUE,
     cex = 0.7,
     no.margin = TRUE, 
     align.tip.label= TRUE)

# Add a scale bar (helps verify branch lengths are being used)
#add.scale.bar(5,1, col="blue")
add.scale.bar(5,1)

# -----------------------
# 5) Node labels
# -----------------------

if (!is.null(tr_root$node.label)) {
  nodelabels(text = tr_root$node.label,
             frame = "none",
             cex = 0.6,
             adj = c(1.2, -0.2))
}

# -----------------------
# 6) Branch lengths as numbers below edges
# -----------------------

# identify internal edges
internal_edges <- which(tr_root$edge[,2] > Ntip(tr_root))

# edgelabels(
  # text  = signif(tr_root$edge.length[internal_edges], 3),
  # edge  = internal_edges,
  # frame = "none",
  # cex   = 0.5,
  # col   = "blue",
  # adj   = c(0,1.5)
# )
