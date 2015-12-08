library(gemtraits)

con = connect_gemtraits_db()
photosyn = get_photosyn(con)

library(plyr)

per_tree_chem = ddply(photosyn, .(tree_id), summarize, mean_c_percent = mean(c_percent, na.rm = T),
                                                       mean_n_percent = mean(n_percent, na.rm = T),
                                                       dbh = dbh[1])

all_trees = get_trees(con)
all_fp_trees = subset(all_trees, ! grepl("^I", all_trees$tree_code))
all_trees_with_chem = join(all_fp_trees[,c("tree_id","plot_code","tree_code","fp_species_name","dbh")], per_tree_chem, by = "tree_id", type = "left")
