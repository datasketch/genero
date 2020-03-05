#' Panel component for shiny panels layout
#'
#' @param names A vector or data.frame with names or full names
#' @param result_as A named vector with names c("male", "female")
#'   values can be used to override the results.
#' @param lang Use "es" for Spanish (default), "pt" for Portuguese.
#' @param col The name of the column with the names or full names.
#'   when the input is a data frame.
#' @param na String to be used when there is not match for gender
#' @param rev_weights Boolean to indicate if weights should be
#'   reversed when input names have the format Last Name First Name.
#'
#' @return A vector of data frame with the estimated gender for the
#'   input. When the input is data.frame a column is attached next
#'   to the column used for the input names with the result.
#'
#' @examples
#' genero(c("Juan", "Pablo", "Camila", "Mariana"))
#'
#'
#' @export
#' @importFrom utils read.csv
genero <- function(nms,
                   result_as = c(male = "male", female = "female"),
                   lang = "es",
                   col = NULL, na = NA,
                   rev_weights = FALSE
                   ){

  if(lang == "es"){
    nms_gender <-names_gender_es
  }
  if(lang == "pt"){
    nms_gender <- names_gender_pt
  }
  gender <- NULL
  if(class(nms) %in% c("factor", "character")) {
    nms <- remove_accents(tolower(nms))
    gender <- match_replace(nms, nms_gender, na = na)
    if(length(gender) == 1 && is.na(gender)) return(gender)
    if(na_proportion(gender) > 0.7 || many_words_proportion(nms) > 0.5){
      # Try splitting nms
      lnms <- strsplit(nms, " ")
      gender <- unlist(lapply(lnms, function(x){
        x <- na_to_chr(genero(x), "NA")
        # weight by position
        w <- length(x):1/sum(1:length(x))
        if(rev_weights) w <- rev(w)
        names(w) <- x
        ws <- c(female = sum(w[names(w) == "female"]),
                male = sum(w[names(w) == "male"]),
                na = sum(w[names(w) == "na"]))
        maxima <- which(ws == max(ws))
        if(length(maxima) > 1 || names(maxima) == "NA") return(NA)
        names(ws[maxima])
        #ws
      }))
    }

    if(any(names(result_as) != unname(result_as))){
      gender <- match_replace(gender, data.frame(match = names(result_as),
                                                 replace = result_as, stringsAsFactors = FALSE))
    }
  }

  if("data.frame" %in% class(nms)){
    if(is.null(col)){
      col <- which_name_column(names(nms))
      if(is.null(col)) stop("Please provide a column with the names to estimate gender to")
    } else{
      if(!col %in% names(nms)) stop("Provided col not found. Please provide a column with the names to estimate gender to")
    }
    gender <- genero(nms[,col[1]], result_as = result_as)
    target <- match(col, names(nms))
    gender <- insert_column(nms, gender, target, col_name = paste0(col,"_gender_guess"))
  }
  gender

}

#' Which name column
#'
#' @param colnames A vector of data.frame names.
#' @param colname_variations A vector of custom names to append to the vector
#'   of frequent colnames for first names.
#' @param show_guess Show message with the guessed column.
#' @return A single colname with the match of common first name columns.
#'
#' @examples
#' which_name_column(c("Name", "Age", "City"))
#'
#' @export
which_name_column <- function(colnames, colname_variations = NULL, show_guess = FALSE){
  name_cols <- c(c("name", "names", "first_name", "first name", "nombre", "nombres",
                 "nombres y apellidos", "nombres_apellidos", "nombre_apellidos", "nome",
                 "prenom"), colname_variations)
  names(colnames) <- tolower(colnames)
  col <- which_in(name_cols, names(colnames))
  col <- unname(colnames[col])
  if(show_guess) message("Guessed names column: ", col)
  if(length(col) == 0) return()
  if(length(col) > 1) warning("Found multiple gender column candidates: ",paste(col, collapse = ", "),
                              ". Using column",col[1])
  col
}
