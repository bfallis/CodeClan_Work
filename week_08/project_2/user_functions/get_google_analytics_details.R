# Gets credentials from keyring and google analytics details for CodeClan

# Get google developer API details from keyring
options(googleAuthR.client_id =
        keyring::key_get(service = "google_client_id"))
options(googleAuthR.client_secret =
        keyring::key_get(service = "google_secret"))

#Reload package with new credentials
devtools::reload(pkg = devtools::inst("googleAnalyticsR"))

#Get CodeClan viewID and assign
account_list <- ga_account_list()
google_analytics_id <- 
        as.numeric(account_list[account_list$accountName == "CodeClan", ]$viewId)
