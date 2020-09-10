library(DBI)
library(odbc)
library(RPostgres)
library(RPostgreSQL)


#connect to db
###################################################################################################################

db <- "postgres"  #provide the name of your db

host_db <- "localhost" #i.e. # i.e. 'ec2-54-83-201-96.compute-1.amazonaws.com'  

db_port <- "5433"  # or any other port specified by the DBA

db_user <- "postgres" 

db_password <- "airqteam"

con <- dbConnect(RPostgres::Postgres(), dbname = db, host=host_db, port=db_port, user=db_user, password=db_password) 

###################################################################################################################
## ----connection summary--------------------------------------------------
summary(con)

## ----list tables---------------------------------------------------------
DBI::dbListTables(con)

## ----list table fields---------------------------------------------------
DBI::dbListFields(con, "Data")

## ----query entire table--------------------------------------------------
DBI::dbReadTable(con, "Data")

## ----query few rows------------------------------------------------------
DBI::dbGetQuery(con, 'select * from "Data" limit 10')

## ----query data in batches-----------------------------------------------
query  <- DBI::dbSendQuery(con, 'select * from "Data"')
result <- DBI::dbFetch(query, n = 15)
result

## ----query status--------------------------------------------------------
DBI::dbHasCompleted(query)

## ----query info----------------------------------------------------------
DBI::dbGetInfo(query)

## ----get latest query----------------------------------------------------
DBI::dbGetStatement(query)

## ----rows fetched--------------------------------------------------------
DBI::dbGetRowCount(query)

## ----rows affected-------------------------------------------------------
DBI::dbGetRowsAffected(query)

## ----column info---------------------------------------------------------
DBI::dbColumnInfo(query)

## ----clear query result--------------------------------------------------
DBI::dbClearResult(query)

## ----check if table exists-----------------------------------------------
DBI::dbExistsTable(con, "trial_db")

####################################################################################
## ----create table--------------------------------------------------------
# sample data
x          <- 1:10
y          <- letters[1:10]
trial_data <- tibble::tibble(x, y)

# write table to database
DBI::dbWriteTable(con, "trial_db", trial_data)

## ----list tables---------------------------------------------------------
DBI::dbListTables(con)

## ----create query--------------------------------------------------------
DBI::dbGetQuery(con, "select * from trial limit 5")

## ----overwrite table-----------------------------------------------------
# sample data
x           <- sample(100, 10)
y           <- letters[11:20]
trial2_data <- tibble::tibble(x, y)

# overwrite table trial
DBI::dbWriteTable(con, "trial_db", trial2_data, overwrite = TRUE)

## ----append data---------------------------------------------------------
# sample data
x           <- sample(100, 10)
y           <- letters[5:14]
trial3_data <- tibble::tibble(x, y)

# append data
DBI::dbWriteTable(con, "trial_db", trial3_data, append = TRUE)

## ----insert rows---------------------------------------------------------
DBI::dbExecute(con,
               "INSERT into trial_db (x, y) VALUES (32, 'c'), (45, 'k'), (61, 'h')"
)

## ----insert rows---------------------------------------------------------
DBI::dbSendStatement(con,
                     "INSERT into trial_db (x, y) VALUES (25, 'm'), (54, 'l'), (16, 'y')"
)

## ----remove table--------------------------------------------------------
DBI::dbRemoveTable(con, "trial_db")

## ----data types----------------------------------------------------------
DBI::dbDataType(RSQLite::SQLite(), "a")
DBI::dbDataType(RSQLite::SQLite(), 1:5)
DBI::dbDataType(RSQLite::SQLite(), 1.5)






