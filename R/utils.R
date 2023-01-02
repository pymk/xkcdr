#' Convert xkcd JSON to a tibble
#'
#' This function converts the returned JSON file from xkcd into a tibble.
#'
#' @param x The returned response JSON object.
#'
#' @return tibble
#'
#' @examples
#' \dontrun{
#' resp <- httr::GET(endpoint)
#' fxn_json_to_tibble(resp)
#' }
#' @importFrom httr content
#' @importFrom tibble enframe as_tibble
#' @importFrom janitor row_to_names
#' @importFrom dplyr mutate
#' @importFrom rlang .data
fxn_json_to_tibble <- function(x) {
  table_raw <- httr::content(x) |>
    tibble::enframe()

  table_raw <- dplyr::mutate(table_raw, value = as.character(table_raw$value))

  table_raw <- table_raw |>
    t() |>
    janitor::row_to_names(1) |>
    tibble::as_tibble()
}

#' Get the number of the latest xkcd comic
#'
#' This function gets the comic number for the latest xkcd
#'
#' @return string
#'
#' @examples
#' \dontrun{
#' fxn_latest_comic_number()
#' }
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
fxn_latest_comic_number <- function() {
  endpoint <- "https://xkcd.com/info.0.json"
  resp <- httr::GET(endpoint)
  parsed <- jsonlite::fromJSON(
    txt = httr::content(resp, "text", encoding = "utf-8"),
    simplifyVector = TRUE
  )
  return(parsed$num)
}

#' Call the xkcd API
#'
#' This is a helper function to call the xkcd API
#'
#' @param x Optional: an integer, corresponding to the xkcd comic number. If
#' nothing is passed, the latest comic is returned.
#'
#' @return An object of class \code{gt_tbl} from {gt} package.
#'
#' @examples
#' \dontrun{
#' fxn_call_api(1)
#' }
#' @importFrom rlang is_missing abort
#' @importFrom httr modify_url GET http_type content http_error
#' @importFrom jsonlite fromJSON
fxn_call_api <- function(x) {
  # Get latest xkcd number
  latest_num <- fxn_latest_comic_number()

  # Create endpoint ------------------------------------------------------------
  url <- "https://xkcd.com"

  if (rlang::is_missing(x) | is.null(x) | is.na(x)) {
    path <- paste("info.0.json", sep = "/")
  } else if (is.numeric(x) && as.numeric(x) %% 1 == 0) {
    if (x > latest_num) {
      rlang::inform(
        message = "Incorrect Comic Number",
        body = "Showing latest xkcd comic instead."
      )
      x <- latest_num
    }
    path <- paste(x, "info.0.json", sep = "/")
  } else {
    rlang::abort(
      message = "Input Error",
      body = "`x` can only be an integer, NULL, or NA."
    )
  }

  endpoint <- httr::modify_url(
    url = url,
    path = path
  )

  # GET response ---------------------------------------------------------------
  resp <- httr::GET(endpoint)

  # Verify response
  if (httr::http_type(resp) != "application/json") {
    rlang::abort(
      message = "API Error",
      body = "API did not return JSON"
    )
  }

  # Parse result ---------------------------------------------------------------
  parsed <- jsonlite::fromJSON(
    txt = httr::content(resp, "text", encoding = "utf-8"),
    simplifyVector = TRUE
  )

  # Return the error if API call fails
  if (httr::http_error(resp)) {
    rlang::abort(
      message = "API Error",
      body = sprintf("API request failed [%s]: <%s>", resp$status_code, resp$url)
    )
  }

  return(resp)
}

#' Make xkcd table
#'
#' This is the main function to create the xkcd comic panel.
#'
#' @param x The dataframe obtained.
#'
#' @return An object of class \code{gt_tbl} from {gt} package.
#'
#' @examples
#' \dontrun{
#' fxn_call_api(1) |>
#'   fxn_json_to_tibble() |>
#'   fxn_make_table()
#' }
#' @importFrom dplyr mutate rename
#' @importFrom tibble tibble
#' @importFrom stats setNames
#' @importFrom gt gt tab_header tab_footnote md
#' @importFrom gtExtras gt_img_rows gt_theme_espn
#' @importFrom rlang .data
#' @importFrom magick image_read
fxn_make_table <- function(x) {
  comic_date <- as.Date(paste(x$year, x$month, x$day, sep = "-"))
  col_name <- paste0("xkcd", " #", x$num)
  img_info <- magick::image_read(x$img)
  img_width <- magick::image_info(img_info)$width
  img_height <- magick::image_info(img_info)$height

  x <- dplyr::mutate(x, date = comic_date)

  tibble::tibble(img = x$img) |>
    dplyr::rename(setNames("img", col_name)) |>
    gt::gt() |>
    gt::tab_header(
      title = x$title,
      subtitle = format(x$date, "%b %d, %Y")
    ) |>
    gtExtras::gt_img_rows(col_name, height = gt::px(img_height)) |>
    gt::tab_footnote(gt::md(paste0("*", x$alt, "*"))) |>
    gt::tab_source_note(source_note = paste0("https://xkcd.com/", x$num, "/")) |>
    gt::tab_options(
      table.width = gt::px(img_width)
    ) |>
    gtExtras::gt_theme_espn()
}
