#' Function to fetch all the tags in RStudio Connect
#'
#' @return All the tags available in RStudio Connect
#' @keywords internal


get_all_rsc_tags <- function(){

  get_tags_request <- httr::GET(
    url = paste0(Sys.getenv("CONNECT_SERVER"), '__api__/v1/tags'),
    httr::add_headers(Authorization = paste("Key",
                                            Sys.getenv("CONNECT_API_KEY")))
  )

  rsc_tags <- httr::content(get_tags_request)

  return(rsc_tags)
}
