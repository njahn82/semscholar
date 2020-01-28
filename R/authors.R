#' Semantic Scholar Author Lookup
#'
#' Obtain metadata relative to authors from Semantic Scholar including
#' links to papers, citation profile and name variants.
#' Please play nice with the API. If you need to access
#' more data, there is also a data dump available.
#' For more info see \url{https://api.semanticscholar.org/corpus/}.
#'
#' @param s2_author_id character, Semantic Scholar Author ID.
#' @param .progress Shows the \code{plyr}-style progress bar.
#'   Options are "none", "text", "tk", "win", and "time".
#'   See \code{\link[plyr]{create_progress_bar}} for details
#'   of each. By default, no progress bar is displayed.
#'
#' @return The result is a tibble with each row representing a publication.
#'   Here are the returned columns and descriptions according to the API docu:
#'
#' \tabular{ll}{
#'   \code{aliases} \tab Names variants
#'   \code{author_id} \tab Semantic Scholar Author ID
#'   \code{author_name} \tab Normalized Author Name
#'   \code{author_url} \tab Link to Semantic Scholar Author Profile
#'   \code{influential_citation_counts} \tab Number of Highly
#'     Influential Citations
#'   \code{papers} \tab List-column with metadata relative to papers from the
#'     author. This variable contains the following information \code{paper_id},
#'     \code{title}, \code{url}, \code{year}
#'
#' @importFrom plyr llply
#' @importFrom dplyr bind_rows mutate rename
#' @importFrom tibble tibble
#' @importFrom purrr map_if
#'
#' @export
#'
#' @examples \dontrun{
#' # one author
#' s2_authors("2204561")
#'
#' # multiple authors at once with progress bar
#' s2_authors(c("2204561", "144128278", "49930593"), .progress = "text")
#' }

s2_authors <- function(s2_author_id = NULL, .progress = "none") {
  # input validation
  stopifnot(!is.null(s2_author_id), is.character(s2_author_id))
  # remove empty characters
  if (any(s2_author_id %in% "")) {
    s2_author_id <- s2_author_id[s2_author_id != ""]
    warning("Removed empty characters from IDs vector")
  }
  # Call API for every ID, and return a tibble with results
  tt_out <- plyr::llply(s2_author_id, s2_authors_, .progress = .progress)
  dplyr::bind_rows(tt_out)
}


s2_authors_ <- function(s2_author_id) {
  req <- call_s2(id = s2_author_id, method = "author")
  if(is.null(req)) {
    return(NULL)
  } else {
    s2_authors_parser(req)
  }
}

s2_authors_parser <- function(out) {
  if(!is.list(out)) {
    return(NULL)
  } else {
    # some persons don't have aliases
    out <- purrr::map_if(out, function(x) length(x) == 0, ~ NA_character_)
    out_df <- tibble::tibble(
      aliases = list(out[["aliases"]]),
      author_id = out[["authorId"]],
      author_name = out[["name"]],
      author_url = out[["url"]],
      influential_citation_count = out[["influentialCitationCount"]],
      papers = list(out[["papers"]])
    )
    # manipulate colnames in nested column
    dplyr::mutate(out_df, papers =  lapply(papers, s2_author_col_rename))
  }
}

s2_author_col_rename <- function(s2_author_parsed) {
  dplyr::rename(s2_author_parsed,
                paper_id = .data$paperId
  )
}
