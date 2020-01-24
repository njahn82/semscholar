#' Lookup metadata about an article in Semantic Scholar
#'
#' Obtain information about individual scholarly articles indexed in Semantic
#' Scholar. Please play nice with the API. If you need to access
#' more data, there is also a data dump available.
#' For more info see \url{https://api.semanticscholar.org/corpus/}.
#'
#' @param ids character vector, get metadata by a single identifier or many
#'   identifiers. Besides its own id scheme, Semantic Scholar supports
#'   DOIs and arXiv IDs.
#' @param .progress Shows the \code{plyr}-style progress bar.
#'   Options are "none", "text", "tk", "win", and "time".
#'   See \code{\link[plyr]{create_progress_bar}} for details
#'   of each. By default, no progress bar is displayed.
#'
#'
#' @return The result is a tibble with each row representing a publication.
#'   Here are the returned columns and descriptions according to the API docu:
#'   # nolint start
#'
#' \tabular{ll}{
#'  \code{abstract} \tab Extracted abstract of the paper. \cr
#'  \code{arxiv_id} \tab arXiv ID \cr
#'  \code{authors}  \tab List-column of detailed author infos \cr
#'  \code{citation_velocity} \tab A weighted average of the publication's citations
#'  for the last 3 years and fewer for publications published in the last year
#'  or two, which indicates how popular and lasting the publication is. \cr
#'  \code{citations} \tab lList-column  of Semantic Scholar papers which cited this paper. \cr
#'  \code{doi} \tab Digital Object Identifier \cr
#'  \code{influential_citation_count} \tab Sum of the highly influential citations \cr
#'  \code{paper_id} \tab Semantic Scholar paper ID \cr
#'  \code{reference} \tab List-column of Semantic Scholar papers the paper cited \cr
#'  \code{title} \tab Article Title \cr
#'  \code{topics} \tab List-column of the fields of study this paper addresses. \cr
#'  \code{venue} \tab Extracted publication venue for this paper. \cr
#'  \code{year} \tab Publication year \cr
#'
#' @importFrom plyr llply
#' @importFrom dplyr bind_rows
#'
#' @export
#'
#' @examples \dontrun{
#' get_papers("10.1186/1471-2164-11-245")
#' # call many papers with different id types at once
#' get_papers(ids = c("10.1093/nar/gkr1047",
#' "bbc25a6a340365832d4d27f683646c39f2661c88",
#' "10.7717/peerj.2323",
#' "arXiv:0711.0914"))
#' }
#'
s2_papers <- function(ids = NULL, .progress = "none") {
  # input validation
  stopifnot(!is.null(ids))
  # remove empty characters
  if (any(ids %in% "")) {
    ids <- ids[ids != ""]
    warning("Removed empty characters from IDs vector")
  }
  # Call API for every ID, and return a tibble with results
  tt_out <- plyr::llply(ids, s2_paper_md, .progress = .progress)
  dplyr::bind_rows(tt_out)
}


#' Get one publication record from Semantic Scholar
#'
#' @param id character vector, get metadata by a single identifier or many
#'   identifiers. Besides its own id scheme, Semantic Scholar supports
#'   DOIs and arXiv IDs
#'
#' @noRd
s2_paper_md <- function(id) {
  req <- call_s2(id, method = "paper")
  # prevent parsing of empty records
  if(is.null(req)) {
    return(NULL)
  } else {
    parse_s2_paper_md(req)
  }
}

# API calls ---------------------------------------------------------------

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
  # Call Unpaywall Data API
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

# parse metadata ----------------------------------------------------------

#' Parse Semantic Scholar metadata
#'
#' @param out list representing Semantic Scholar json output
#'
#' @importFrom purrr map_if
#' @importFrom tibble tibble as_tibble
#'
#' @noRd
parse_s2_paper_md <- function(out) {
  out <- purrr::map_if(out, is.null, ~ NA_character_)
  tibble::tibble(
    abstract = out[["abstract"]],
    arxiv_id = out[["arxivId"]],
    authors = list(parse_s2_authors(out[["authors"]])),
    citation_velocity = out[["citationVelocity"]],
    citations = list(parse_s2_citations(out, "citations")),
    doi = out[["doi"]],
    influential_citation_count = out[["influentialCitationCount"]],
    paper_id = out[["paperId"]],
    references = list(parse_s2_citations(out, "references")),
    title = out[["title"]],
    topics = list(parse_s2_topics(out[["topics"]])),
    url = out[["url"]],
    venue = out[["venue"]],
    year = out[["year"]]
  )
}


# parse citations and references ------------------------------------------

#' Parse information about citations or references
#'
#' @param out_parsed list with metadata
#' @param method character vector,
#'   can be either "citations" or "references"
#' @importFrom janitor clean_names
#' @importFrom tibble tibble as_tibble
#' @importFrom dplyr rename
#' @noRd
parse_s2_citations <- function(out_parsed, method) {
  if (!is.list(out_parsed))
    stop("Something went wrong")
  stopifnot(method %in% c("references", "citations"))
  if (length(out_parsed[[method]]) == 0)
    return(tibble::tibble())
  tt_df <- tibble::as_tibble(out_parsed[[method]])
  janitor::clean_names(dplyr::rename_all(tt_df,
                                         function(x)
                                           paste(method, x, sep = "_")))
}


# parse topics ------------------------------------------------------------

#' Parse author metadata
#'
#' @param topics ist containing subject information
#'
#' @importFrom tibble tibble as_tibble
#' @noRd
parse_s2_topics <- function(topics) {
  if (!is.list(topics))
    stop("Something went wrong")
  if (length(topics) == 0)
    tibble::tibble()
  colnames(topics) <- c("topic", "topic_id", "topic_url")
  return(tibble::as_tibble(topics))
}

# parse author info -------------------------------------------------------

#' Parse author metadata
#'
#' @param authors list containing author metadata
#'
#' @importFrom rlang .data
#' @importFrom dplyr rename
#' @importFrom tibble tibble as_tibble
#' @noRd
parse_s2_authors <- function(authors) {
  if (!is.list(authors))
    stop("Something went wrong")
  if (length(authors) == 0)
    tibble::tibble()
  authors <-
    dplyr::rename(
      authors,
      author_id = .data$authorId,
      author_name = .data$name,
      author_url = .data$url
    )
  tibble::as_tibble(authors)
}
