# meta
semscholar_baseurl <- function()
  "https://api.semanticscholar.org/"
# API version
semscholar_api_version <- function()
  "v1"
ua <- httr::user_agent("https://github.com/njahn82")

#' Interface to the Semantic Scholar API
#'
#' @param id character vector, representing a publication record id
#' @param method character vector, supports "paper" to get publication records
#'
#' @importFrom httr modify_url RETRY http_type
#' @importFrom httr modify_url RETRY http_type
#' @importFrom jsonlite fromJSON
#'
#' @noRd

call_s2 <- function(id, method) {
  u <- httr::modify_url(
    semscholar_baseurl(),
    path = c(semscholar_api_version(), method, trimws(id))
  )
  # Call S2 Data API
  resp <- httr::RETRY("GET", u, ua)

  # test for valid json
  if (httr::http_type(resp) != "application/json") {
    stop(
      sprintf(
        "Oops, API did not return json after calling '%s':
        check your query - or semscholar_api_version may experience problems",
        id
      ),
      call. = FALSE
    )
  }

  out <- jsonlite::fromJSON(httr::content(resp, "text", encoding = "UTF-8"),
                            flatten = TRUE)
  if(length(out$error) != 0) {
    warning(
      paste("Paper with ID", id, "was not found"), call. = FALSE)
    NULL
  } else {
    out
  }
}
