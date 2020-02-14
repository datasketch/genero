

remove_accents <- function(string){
  accents <- "àèìòùÀÈÌÒÙáéíóúýÁÉÍÓÚÝäëïöüÄËÏÖÜâêîôûÂÊÎÔÛñÑç"
  translation <- "aeiouAEIOUaeiouyAEIOUYaeiouAEIOUaeiouAEIOUnNc"
  chartr(accents, translation, string)
}

match_replace <- function (v, dic, na = NA, force = TRUE){
  matches <- dic[[2]][match(v, dic[[1]])]
  out <- matches
  if(!is.na(na)){
    na_to_chr(out, na)
  }
  if (!force)
    out[is.na(matches)] <- v[is.na(matches)]
  out
}

which_in <- function (x, y) x[x %in% y]

na_proportion <- function(x) sum(is.na(x))/length(x)

many_words_proportion <- function(x) sum(grepl("^.* .*$",x))/length(x)

na_to_chr <- function(x, na){
  x[is.na(x)] <- na
  x
}

insert_column <- function(d, vector, target, col_name){
  if(ncol(d) == 1){
    d[[col_name]] <- vector
    return(d)
  }
  new_col <- data.frame(vector, stringsAsFactors = FALSE)
  names(new_col) <- col_name
  cbind(d[,1:target,drop=FALSE], new_col, d[,(target+1):length(d),drop=FALSE])
}



