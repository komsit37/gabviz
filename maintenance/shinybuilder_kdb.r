kdb_db <- quote({
  if (.Platform$pkgType=="mac.binary.mavericks"){
  	#OSX - dev
  	source("/workspace/qserver/osx_qserver/qserver.R")
  } else{
  #linux - live
  	source("/apps/r/l64_qserver/qserver.R")
  }
  h<-open_connection("192.241.230.61",5112)
})

kdb_default_query <- "([]a:1 2;b:1 2)"

dbListAdd(db_name = 'bnb', db = kdb_db, query_fn = execute, default_query = kdb_default_query)
dbListAdd(db_name = 'set-rdb', db = kdb_db, query_fn = execute, default_query = kdb_default_query)
dbListAdd(db_name = 'set-hdb', db = kdb_db, query_fn = execute, default_query = kdb_default_query)
dbListRemove('bnb')
dbListPrint()
names(dbListPrint())

setwd('/workspace/shiny/dashboard')
source('./R/dbList.R')