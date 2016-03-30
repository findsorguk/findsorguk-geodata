library(foreign)
dfblocks = read.dbf('/Users/danielpett/Documents/research/osData/Data/osData/scotland_and_wales_const_region.dbf',
                    as.is=TRUE)
unitID = unique(dfblocks$UNIT_ID)
unitID <- as.data.frame(unitID)
for (i in 1:nrow(unitID)){
  id <- unitID[i, "unitID"]
  strOGR = paste(
    "ogr2ogr -where 'UNIT_ID = ", id, "' /Users/danielpett/Documents/research/osData/Data/splitOsData/scotlandAndWalesConstRegion /Users/danielpett/Documents/research/osData/Data/osData/ scotland_and_wales_const_region -nln ", id, sep="" 
  )
  system(strOGR)
}