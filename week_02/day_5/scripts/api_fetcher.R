#Function to get message emotion from indico
api_fetcher <- function(url, api_key, message) {
        params <- list(api_key = api_key, data = message)
        
        response <- POST(url, query = params)
        
        return(content(response))
}

