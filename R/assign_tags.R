#' Assigns tags to deployed content in RStudio Connect.
#'
#' @param valid_rmd_tags  The output from \code{validate_rmd_tags}; a list with the tags available both in the Rmd and RSC.
#' @param rsc_tags The output from \code{get_all_rsc_tags}; an unordered list with the tags in RSC.
#' @param content_guid The unique identifier of the desired content item.
#'
#' @return NULL
#' @keywords internal

assign_tags <- function(valid_rmd_tags, rsc_tags, content_guid){
  tags_id <- purrr::map_chr(rsc_tags, ~ifelse(.x$name %in% valid_rmd_tags, ifelse(is.null(.x$parent_id), "0", .x$id), "0"))
  tags_id <- tags_id[tags_id != "0"]

  for (tag in tags_id){
    tag_data <- paste0('{"tag_id": "', tag,'" }')
    res <- httr::POST(paste0(Sys.getenv("CONNECT_SERVER"), '__api__/v1/content/', content_guid, '/tags'),
                      httr::add_headers(Authorization = paste("Key", Sys.getenv("CONNECT_API_KEY"))),
                      body = tag_data,
                      encode = 'raw')
  }
}
