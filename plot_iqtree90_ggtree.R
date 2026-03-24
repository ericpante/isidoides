# Read, edit and plot the IQTREE tree with ggtree + a "broken" long root→ingroup branch
# EP, 27-feb-2026 (converted to ggtree)

library(ape)
library(ggtree)
library(ggplot2)
library(dplyr)
library(phytools)
# -----------------------
# Inputs
# -----------------------

tree_file <- "/Users/epante/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/soda/out_trees/uce90p_supermatrix/mafft-internal-trimmed-gblocks-clean-90p-raxml.charsets.treefile"
map_file  <- "/Users/epante/ownCloud/Xu_etal_2026_Isidoididae/PCI_Zoology/analyses/soda/out_trees/uce100p_astral/tip_labels.txt"
outgroup_tips <- c("Keratoisididae_clade_S1_OCT090", "Jasonisis_thresheri_OCT052", "Orstomisis_crosnieri_OCT053")

# how much of the (potentially very long) root→ingroup edge you want to keep before breaking
break_cap <- 1.0   # in branch-length units (tune)
break_label <- "//"

# -----------------------
# 1) Read & root
# -----------------------
tr <- read.tree(tree_file)

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
tr_root <- ladderize(tr_root, right = FALSE)

# -----------------------
# 2) Apply custom tip labels from a 2-column mapping table (optional)
# -----------------------
if (!is.null(map_file) && file.exists(map_file)) {
  map <- read.table(map_file, header = FALSE, sep = "\t",
                    stringsAsFactors = FALSE, quote = "", comment.char = "")
  old <- map[[1]]
  new <- map[[2]]

  idx <- match(tr_root$tip.label, old)
  has_match <- !is.na(idx)
  tr_root$tip.label[has_match] <- new[idx[has_match]]

  unmapped <- tr_root$tip.label[!has_match]
  message("Unmapped tips (kept as-is): ", paste(unmapped, collapse = ", "))
} else {
  message("map_file not found/readable -> skipping tip relabeling.")
}

# -----------------------
# 3) Identify the root→ingroup edge (the root child NOT containing outgroup tips)
# -----------------------
Ntip  <- length(tr_root$tip.label)
root_node <- Ntip + 1L

children <- tr_root$edge[tr_root$edge[,1] == root_node, 2]
if (length(children) < 2) stop("Root has <2 children after rooting; unexpected.")

is_outgroup_child <- vapply(children, function(ch) {
  desc <- getDescendants(tr_root, ch)
  tips <- desc[desc <= Ntip]
  any(tr_root$tip.label[tips] %in% outgroup_tips)
}, logical(1))

ingroup_children <- children[!is_outgroup_child]
if (length(ingroup_children) == 0) {
  stop("Could not find an ingroup child at the root (outgroup tips seem to be everywhere).")
}
# If there are >1 ingroup children (possible after resolve.root), break them all:
edges_to_break <- ingroup_children

# Edge lengths for those root→ingroup edges:
edge_idx <- which(tr_root$edge[,1] == root_node & tr_root$edge[,2] %in% edges_to_break)

# Keep originals, then cap the displayed length (so the tree fits nicely)
orig_el <- tr_root$edge.length[edge_idx]
tr_disp <- tr_root
tr_disp$edge.length[edge_idx] <- pmin(tr_disp$edge.length[edge_idx], break_cap)

# -----------------------
# 4) Build ggtree plot
# -----------------------
# Clean node labels like you did:
if (!is.null(tr_disp$node.label)) {
  tr_disp$node.label[tr_disp$node.label == "100/100"] <- ""
}

p <- ggtree(tr_disp, layout = "rectangular", branch.length = "branch.length") +
  theme_tree2()  # gives x-axis for branch lengths

# Align tip labels:
p <- p + geom_tiplab(align = TRUE, linetype = "dotted", size = 2.5)

# Node labels (internal nodes)
# (geom_text2 uses the ggtree data; subset to internal nodes and non-empty labels)
p <- p + geom_text2(
  aes(subset = !isTip & !is.na(label) & label != "", label = label),
  hjust = -0.15, vjust = -0.4, size = 2.5
)

# Scale bar (ggtree): use theme_tree2() axis OR add a scalebar
p <- p + geom_treescale(x = 0, y = 0, width = 0.5, fontsize = 2.5)

# -----------------------
# 5) Add the visual "break" mark(s) on the root→ingroup edge(s)
# -----------------------
pd <- p$data

# rows corresponding to the root->ingroup child nodes
break_rows <- pd %>%
  filter(node %in% edges_to_break, parent == root_node) %>%
  left_join(pd %>% select(node, y) %>% rename(parent = node, y_parent = y),
            by = "parent") %>%
  mutate(
    y_mid = (y + y_parent) / 2,
    x_pos = x - 0.02 * max(pd$x, na.rm = TRUE)  # small left shift; tweak if needed
  )

if (nrow(break_rows) > 0) {
  p <- p + geom_text(
    data = break_rows,
    aes(x = x_pos, y = y_mid, label = "//"),
    size = 4
  )
}
# Optional: if you want to *also* indicate how much was cut, print it:
if (any(orig_el > break_cap)) {
  message("Broken root→ingroup edge(s) original length(s): ",
          paste(round(orig_el, 5), collapse = ", "),
          " ; capped at ", break_cap)
}

# -----------------------
# 6) Draw
# -----------------------
print(p)