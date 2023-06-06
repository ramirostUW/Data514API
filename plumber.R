#
# This is a Plumber API. You can run the API by clicking
# the 'Run API' button above.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/
#

library(plumber)
library(RMySQL)

db_user <- 'adminUser'
db_password <- 'adminPass'
db_name <- 'info514'
db_host <- 'dbinfo514proj-instance-1.cienxzgfkjlg.us-east-2.rds.amazonaws.com' # for local access
db_port <- 3306

#* @filter cors
cors <- function(res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  plumber::forward()
}

#* @apiTitle Plumber Example API
#* @apiDescription Plumber example description.

#* Executes a query against the DB
#* @param query The query to execute
#* @get /getQuery
function(query) {
    mydb <-  dbConnect(MySQL(), user = db_user, password = db_password,
                       dbname = db_name, host = db_host, port = db_port)
    s <- query
    rs <- dbSendQuery(mydb, s)
    df <-  fetch(rs, n = -1)
    dbDisconnect(mydb)
    
    return(df)
}

#* Executes a sample query against the DB
#* @get /getSampleQuery
function() {
    mydb <-  dbConnect(MySQL(), user = db_user, password = db_password,
                       dbname = db_name, host = db_host, port = db_port)
    s <- "Select Distinct u1.screen_name as UserA, 
    u2.screen_name as UserB, u3.screen_name as UserC
    from Tweet t1
    inner join Tweet t2 on t1.in_reply_to_status_id = t2.id
    inner join Tweet t3 on t2.in_reply_to_status_id = t3.id
    inner join User u1 on t1.user_id = u1.user_id
    inner join User u2 on t2.user_id = u2.user_id
    inner join User u3 on t3.user_id = u3.user_id
    where u1.screen_name < u2.screen_name and u2.screen_name < u3.screen_name;
    "
    rs <- dbSendQuery(mydb, s)
    df <-  fetch(rs, n = -1)
    dbDisconnect(mydb)
    
    return(df)
}

#Landing page for API
#* @get /
#* @serializer html
function(){
    "<html>
    <body>
      <h1>DATA 514 Final Project API</h1>
      <p> This API is written in R using the plumber package. It was then 
      deployed using Heroku.</p>
    </body>
  </html>"
}
