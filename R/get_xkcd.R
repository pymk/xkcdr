#' Get xkcd comic
#'
#' This is the main function to call for retrieving xkcd comics.
#'
#' @param x Optional: an integer, corresponding to the xkcd comic number. If
#' nothing is passed, the latest comic is returned.
#' Defaults to \code{400}.
#' @param ... Unused arguments, reserved for future expansion.
#'
#' @return An object of class \code{gt_tbl} from {gt} package.
#'
#' @examples
#' \dontrun{
#' get_xkcd(1)
#' }
#' @importFrom rlang is_missing abort
#' @importFrom httr modify_url GET http_type content http_error
#' @importFrom jsonlite fromJSON
#' @export
get_xkcd <- function(x = NA, ...) {
  params <- list(...)

  if (rlang::is_missing(x) | is.null(x) | is.na(x)) {
    x <- NA
  }

  xkcd_comic <- fxn_call_api(x) |>
    fxn_json_to_tibble() |>
    fxn_make_table()

  return(xkcd_comic)
}
