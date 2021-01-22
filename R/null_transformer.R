#' Function to deal with nulls inside of glue
#'
#' @param str The string to treat as NULL
#'
#' @return The new string
#' @keywords internal

null_transformer <- function(str = "null") {
  function(text, envir) {
    out <- glue::identity_transformer(text, envir)
    if (is.null(out)) {
      return(str)
    }

    out
  }
}
