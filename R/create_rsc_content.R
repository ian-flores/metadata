#' Function to create the content in RStudio Connect
#'
#' @param name Name of the application to be used as an identifier
#' @param description A rich description of the content
#' @param title The title of the content
#' @param access_type Access controls for the content. Allowed options are: "acl" (default), "logged_in", "all"
#' @param connection_timeout Maximum number of seconds allowed without data sent or received across a client connection
#' @param idle_timeout The maximum number of seconds a worker process for an interactive application to remain alive after it goes idle
#' @param init_timeout The maximum number of seconds allowed for an interactive application to start
#' @param load_factor Controls how aggressively new processes are spawned
#' @param max_conns_per_process Specifies the maximum number of client connections allowed to an individual process.
#' @param max_processes Specifies the total number of concurrent processes allowed for a single interactive application
#' @param min_processes Specifies the minimum number of concurrent processes allowed for a single interactive application
#' @param read_timeout Maximum number of seconds allowed without data received from a client connection
#'
#' @details  You can take a look at the options here: https://docs.rstudio.com/connect/1.8.6/api/#post-/v1/content
#' @return content_guid
#' @keywords internal


create_rsc_content <- function(name,
                               description,
                               title,
                               access_type = "acl",
                               connection_timeout = NULL,
                               idle_timeout = NULL,
                               init_timeout = NULL,
                               load_factor = NULL,
                               max_conns_per_process = NULL,
                               max_processes = NULL,
                               min_processes = NULL,
                               read_timeout = NULL){

  content_request_data <- glue::glue('{{
                                      "access_type": "{access_type}",
                                      "connection_timeout": {connection_timeout},
                                      "description": "{description}",
                                      "idle_timeout": {idle_timeout},
                                      "init_timeout": {init_timeout},
                                      "load_factor": {load_factor},
                                      "max_conns_per_process": {max_conns_per_process},
                                      "max_processes": {max_processes},
                                      "min_processes": {min_processes},
                                      "name": "{name}",
                                      "read_timeout": {read_timeout},
                                      "title": "{title}"
                                      }}',
                                     .transformer = null_transformer("null"))

  get_content_request <- httr::POST(
    url = paste0(Sys.getenv("CONNECT_SERVER"), '__api__/v1/content'),
    httr::add_headers(Authorization = paste("Key", Sys.getenv("CONNECT_API_KEY"))),
    body = content_request_data,
    encode = 'raw')

  content_info <- httr::content(get_content_request)

  content_guid <- content_info$guid

  return(content_guid)

}
