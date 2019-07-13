#Function to unpack response to a double vector
response_unpacker <- function(response_list) {
        if (is.null(response_list) | length(response_list) == 0 |
        length(response_list$results) == 0) {
                stop("response_unpacker: empty response_list")
        }
        if (length(response_list$results) < 5) {
                stop("response_unpacker: incomplete list of results")
        }
        if (length(response_list$results) > 5) {
                stop("response_unpacker: list of results larger than expected")
        }
        for (result in response_list$results) {
                if (!is.numeric(result)) {
                        stop("response_unpacker:non numeric value in response_list")
                }
        }
        
        emotion_vec <- flatten_dbl(response_list$results)
        
        names(emotion_vec) <- c("anger", "fear", "joy", "sadness", "surprise")
        
        return(emotion_vec)
}