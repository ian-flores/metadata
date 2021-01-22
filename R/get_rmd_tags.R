#' Function to extract all tags from the RMarkdown document
#'
#' @param rmd_file_path File path to the RMarkdown document
#' @return The tags present in the RMarkdown document.
#' @keywords internal


get_rmd_tags <- function(rmd_file_path){
  yaml_header <- rmarkdown::yaml_front_matter(rmd_file_path)
  raw_rmd_tags <- yaml_header$metadata$tags
  return(raw_rmd_tags)
}
