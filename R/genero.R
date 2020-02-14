
#' @export
genero <- function(names, col = NULL, na = NA,
                   rev_weights = FALSE,
                   lang = "es",
                   result_as = c(male = "male", female = "female")){

  file <- paste0("names-gender-",lang,".csv")
  nms_gender <- read.csv(system.file(file, package = "genero"),
                         stringsAsFactors = FALSE)
  nms_gender <- nms_gender %>%
    dplyr::mutate(gender = remove_accents(tolower(gender))) %>%
    dplyr::distinct()

  if(class(names) %in% c("factor", "character")) {
    names <- remove_accents(tolower(names))
    gender <- match_replace(names, nms_gender, na = na)

    if(na_proportion(gender) > 0.7 || many_words_proportion(names) > 0.5){
      # Try splitting names
      lnames <- strsplit(names, " ")
      gender <- unlist(lapply(lnames, function(x){
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

  if("data.frame" %in% class(names)){
    if(is.null(col)){
      name_cols <- read.csv(system.file("name-columns.csv", package = "genero"),
                            stringsAsFactors = FALSE)[[1]]
      col <- which_in(name_cols, names(names))
      message("Guessed names column: ", col)
      if(length(col) == 0) stop("Please provide a column with the names to estimate gender to")
      if(length(col) > 1) warning("Using first names column found: ", col[1])
    } else{
      if(!col %in% names(names)) stop("Provided col not found. Please provide a column with the names to estimate gender to")
    }
    gender <- genero(names[,col[1]], result_as = result_as)
    target <- match(col, names(names))
    gender <- insert_column(names, gender, target, col_name = paste0(col,"_gender_guess")
    )
  }
  gender

}
