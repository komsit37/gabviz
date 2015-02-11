# Copyright (c) 2014 Clear Channel Broadcasting, Inc. 
# https://github.com/iheartradio/ShinyBuilder
# Licensed under the MIT License (MIT)

#---------
#Libraries
#---------
library(stringr)
library(googleVis)
#library(RJDBC)
library(RJSONIO)
library(RSQLite)
library(shinyAce)
library(shinyMCE)
library(shinyGridster)
#library(ShinyBuilder)

cat('loading...')
source('./R/dbList.R')
source('googleChart.R')

#DB list
db_list <- dbListInit()

#Shinybuilder directory
sb_dir <- "./"

#Available dashboards
available_dashboards <- str_replace(list.files(path = str_c(sb_dir,'dashboards')), '.RData', '')



