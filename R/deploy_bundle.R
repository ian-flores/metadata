#' Function to deploy the bundle in RStudio Connect
#'
#' @param bundle_id Bundle identifier within RSC
#' @param content_guid The unique identifier of the desired content item
#'
#' @return httr response object
#' @keywords internal


deploy_bundle <- function(bundle_id, content_guid){
  bundle_data <- paste0('{"bundle_id": "', bundle_id,'" }')

  req <- httr::POST(paste0(Sys.getenv("CONNECT_SERVER"), '__api__/v1/content/', content_guid, '/deploy'),
                    httr::add_headers(Authorization = paste("Key", Sys.getenv("CONNECT_API_KEY"))),
                    body = bundle_data,
                    encode = 'raw')
  invisible(req)
}
