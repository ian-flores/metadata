#' Function to publish an Rmd document with tags to RStudio Connect
#'
#' @param rmd_file_path File path to the RMarkdown document
#' @param name Name of the application to be used as an identifier
#' @param description A rich description of the content
#' @param title The title of the content
#' @param ... All other parameters option to creating content in RStudio Connect. You can take a look at the options here: https://docs.rstudio.com/connect/1.8.6/api/#post-/v1/content
#'
#' @export
meta_publish_rmd <- function(rmd_file_path, name, description, title, ...){
  cli::cli_h1("Deploying {rmd_file_path} as {name} to RStudio Connect")

  #### Handle tags ####
  rmd_tags <- get_rmd_tags(rmd_file_path)
  rsc_tags <- get_all_rsc_tags()

  validated_tags <- validate_rmd_tags(rmd_tags, rsc_tags)
  valid_rmd_tags <- validated_tags[[1]]
  tags_not_rsc <- validated_tags[[2]]

  cli::cli_alert_info("Discovered {length(valid_rmd_tags)} tags defined in the RMarkdown document", wrap = T)
  cli::cli_alert_info("Discovered {length(rsc_tags)} tags defined in the RStudio Connect server", wrap = T)

  cli::cli_rule()
  cli::cli_alert_danger("These tags don't exist in RStudio Connect so they won't be assigned to the document: {tags_not_rsc}",
                        wrap = TRUE)
  cli::cli_alert_success("These tags exist in RStudio Connect so they will be assigned to the document: {valid_rmd_tags}",
                         wrap = TRUE)
  cli::cli_rule()

  #### Create content ####
  content_guid <- create_rsc_content(name = name,
                                     description = description,
                                     title = title,
                                     ...)
  cli::cli_alert_success("Succesfully created content in RStudio Connect with content ID: {content_guid}", wrap = T)

  #### Create bundle ####
  bundle_id <- bundle_content(rmd_file_path, content_guid)

  #### Deploy bundle ####
  deploy_bundle(bundle_id, content_guid)

  cli::cli_alert_success("Succesfully deployed content to RStudio Connect with bundle ID: {bundle_id}", wrap = T)

  #### Assign tags ####
  assign_tags(valid_rmd_tags, rsc_tags, content_guid)

  cli::cli_alert_success("Succesfully assigned tags to content in RStudio Connect", wrap = T)

  cli::cli_h1("Deployment succesfull. Bye now!")
}
