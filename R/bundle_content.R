#' Creates the bundle to be pushed to RStudio Connect.
#'
#' @param rmd_file_path File path to the RMarkdown document
#' @param content_guid The unique identifier of the desired content item
#' @param files_to_exclude Files you don't want inside of the bundle
#'
#' @return bundle_id
#' @keywords internal


bundle_content <- function(rmd_file_path, content_guid, files_to_exclude = NULL){
  rsconnect::writeManifest(contentCategory = "rmarkdown")

  bundle_files <- rsconnect::listBundleFiles(appDir = getwd())$contents
  bundle_files <- bundle_files[bundle_files != rmd_file_path]
  bundle_files <- bundle_files[!stringr::str_detect(bundle_files, '.tar')]
  bundle_files <- bundle_files[!bundle_files %in% files_to_exclude]
  bundle_files <- paste(bundle_files, collapse = " ")

  system("rm -f metadata_bundle.tar.gz")
  system(paste("tar czf metadata_bundle.tar.gz manifest.json", rmd_file_path, bundle_files, ">/dev/null 2>&1"))


  bundle_upload_request <- httr::POST(paste0(Sys.getenv("CONNECT_SERVER"), '__api__/v1/experimental/content/', content_guid, '/upload'),
                                      httr::add_headers(Authorization = paste("Key", Sys.getenv("CONNECT_API_KEY"))),
                                      body = httr::upload_file('metadata_bundle.tar.gz'))

  bundle_id <- httr::content(bundle_upload_request)$bundle_id

  system("rm -f metadata_bundle.tar.gz")

  return(bundle_id)
}
