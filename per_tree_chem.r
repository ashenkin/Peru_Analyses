library(gemtraits)

con = connect_gemtraits_db()
photosyn = get_photosyn(con)

library(plyr)

# this gives you a dataframe of trees with chemistry
per_tree_chem = ddply(photosyn, .(tree_id), summarize, mean_c_percent = mean(c_percent, na.rm = T),
                                                       mean_n_percent = mean(n_percent, na.rm = T),
                                                       dbh = dbh[1])

# this gives you a dataframe of all trees, but no chem
all_trees = get_trees(con)
# this gives you a data frame of just forestplot trees, but no chem
all_fp_trees = subset(all_trees, ! grepl("^I", all_trees$tree_code))
# this gives you a data frame of just forestplot trees, and chem for those which were measured
all_trees_with_chem = join(all_fp_trees[,c("tree_id","plot_code","tree_code","fp_species_name","dbh")], per_tree_chem, by = "tree_id", type = "left")
