#' Function to validate the tags in the Rmd document with the tags in RStudio Connect.
#'
#' @param raw_rmd_tags The output from \code{get_rmd_tags}; a hierarchical list with the tags in the Rmd.
#' @param rsc_tags The output from \code{get_all_rsc_tags}; an unordered list with the tags in RSC.
#'
#' @return a list containing two more lists; one with tags available in RSC and one with tags unavailable in RSC.
#' @keywords internal


validate_rmd_tags <- function(raw_rmd_tags, rsc_tags){
  flat_rmd_tags <- purrr::flatten(raw_rmd_tags)
  unlist_rmd_tags <- unlist(flat_rmd_tags, use.names = T)

  named_rmd_tags <- unlist(stringr::str_split(names(unlist_rmd_tags), pattern = '\\.'))
  children_rmd_tags <- unname(unlist_rmd_tags)

  rmd_tags_names <- c(named_rmd_tags, children_rmd_tags)
  rmd_tags_names <- rmd_tags_names[rmd_tags_names != ""]

  rsc_tags_names <- purrr::map_chr(rsc_tags, ~.x$name)

  tags_not_rsc <- rmd_tags_names[!rmd_tags_names %in% rsc_tags_names]

  valid_rmd_tags <- rmd_tags_names[rmd_tags_names %in% rsc_tags_names]

  invisible(list(valid_rmd_tags, tags_not_rsc))
}
