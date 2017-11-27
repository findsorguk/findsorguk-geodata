#' ----
#' title: " A script to break SHP files into multiple parts and to convert to geoJSON
#' author: "Daniel Pett"
#' date: "27/11/2017"
#' output: geojson
#' output: shp
#' license: MIT
#' ----
#' Tested on 
#' R version 3.3.2 (2016-10-31) -- "Sincere Pumpkin Patch"
#' Platform: x86_64-apple-darwin13.4.0 (64-bit)
#' Rstudio: Version 1.0.136 – © 2009-2016 RStudio, Inc.
#' 

# Initiate libraries required
library(foreign)
library(dplyr)

# Set your working directory
setwd("/Users/danielpett/Documents/research/osData/") 

# Check if directories (Split data and geoJson) exist and if not create them

if (!file.exists('splitOSdata')){
  dir.create('splitOSdata')
}

if (!file.exists('geoJSON')){
  dir.create('geoJSON')
}

# Create path for split up OSdata
splitData <- paste0(getwd(), '/', 'splitOSdata')

# Create path for geojson
jsonData <- paste0(getwd(), '/', 'geoJSON')

# Set path to downloaded OS Data (expanded from OS file)
osData <- '/Users/danielpett/Documents/research/osData/bdline_gb-2017-10/Data'

# We do not need 4 folders from this download set
unwanted <- c('Polling Districts England', 'Wales', 'Supplementary_Ceremonial', 'Supplementary_Historical')

# Delete unwanted folders
for(del in unwanted){
  folder <- paste0(osData,'/', del)
  unlink(folder, recursive = TRUE, force=TRUE)
}

#List the directories
directories <- list.dirs(osData, recursive=FALSE)

# Iterate through directories and find the DBF files and then split and convert
for (dir in directories){
  for(d in dir){
    di <- list.files(d, pattern = "\\.dbf$")
    dbfPath <- paste0(d,'/',di)
    for(dba in dbfPath){
      if(tools::file_ext(dba) == 'dbf'){
          dfblocks = read.dbf(dba,as.is=TRUE)
          unitID = unique(dfblocks$UNIT_ID)
          unitID <- as.data.frame(unitID)
            for (i in 1:nrow(unitID)){
              id <- unitID[i, "unitID"]
              split <- paste0(splitData, ' ',  dba)
              strOGR = paste("ogr2ogr -where 'UNIT_ID = ", id, "' ", split , " -nln ", id, sep="" )
              print(paste0('Split up shp: ', strOGR))
              system(strOGR)
              json <- paste0(jsonData, '/', id, '.geojson')
              file <- paste0(splitData,'/', id, '.shp')
              strgeoJSON = paste("ogr2ogr -f GeoJSON -t_srs WGS84 '", json, "' '", file, "' -skipfailures", sep="")
              print(paste0('Convert shp to geojson: ', strgeoJSON))
              system(strgeoJSON)
            
            }
      }
    }
  }
}
