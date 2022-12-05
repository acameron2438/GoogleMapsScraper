#----------------------------------------------Load Packages---------------------------------------------
library(RCurl, lib="D:/Projects/R/win-library/3.6")
library(RJSONIO, lib="D:/Projects/R/win-library/3.6")
library(plyr, lib="D:/Projects/R/win-library/3.6")
require(stringr, lib="D:/Projects/R/win-library/3.6")
#----------------------------------------------Create Function-------------------------------------------
Scraper <- function(location) 
{
  url = paste("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=",location,"&inputtype=textquery&fields=formatted_address,name,types,geometry&key='[InsertAPIKeyHere]'",sep="")
  map_data = try(fromJSON(paste(readLines(url),collapse="")))
  name = try(map_data$candidates[[1]]$name)
  geo = try(map_data$candidates[[1]]$geometry$location)
  address = try(map_data$candidates[[1]]$formatted_address)
  type = try(map_data$candidates[[1]]$types[1])
  return(c(name, geo, address, type))
}
#Test Addresses
location = "place+with+address:HOME+DEPOT+HOLLYWOOD+5600+SUNSET+BLVD+HOLLYWOOD+CA+90028"
location="place+with+address:ASU+Main+1050+S.+Forest+Mall+Tempe+AZ+85287"
location="place+with+address:SH+Rental+Car+Center+1805+E.+Sky+Harbor+Circle+South+Phoenix+AZ+85034"
location="CUNY BMCC+25+Broadway+New+York++10007"
location="NWTC+2740+W.+Mason+Green+Bay+WI+54303"
location="Baptist Medical Ctr Dwtn+800+Prudential+Dr+SAN+MARCO++32207"
location="FLEXTRONICS+777+GILBRALTAR+COURT+Milpitas++95035"
#Test URL
paste("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=",location,"&inputtype=textquery&fields=formatted_address,name,types,geometry&key='[InsertAPIKeyHere]'",sep="")
#----------------------------------------------Add Columns------------------------------------------------
InputDataFrame$Google_Name=""
InputDataFrame$Google_Lat=""
InputDataFrame$Google_Lng=""
InputDataFrame$Google_Street=""
InputDataFrame$Google_City=""
InputDataFrame$Google_State=""
InputDataFrame$Google_Zip=""
InputDataFrame$Google_Country=""
InputDataFrame$Google_Channel=""
InputDataFrame$Google_Address=""
#----------------------------------------------Pull Data---------------------------------------------------
for (i in 1:nrow(InputDataFrame))
  try({
    location=paste("place+with+address:",InputDataFrame[i,7],sep="+")
    x=try(Scraper(location=location))
    string_count=str_count(x[4],pattern=",")+1
    InputDataFrame[i,8]=x[1] #Name
    InputDataFrame[i,9]=x[2] #Lat
    InputDataFrame[i,10]=x[3] #Lng
    InputDataFrame[i,11]=str_split_fixed(x[4],",",n=string_count)[string_count-3] #Street
    InputDataFrame[i,12]=str_split_fixed(x[4],",",n=string_count)[string_count-2] #City
    InputDataFrame[i,13]=str_split_fixed(str_split_fixed(x[4],",",n=string_count)[[string_count-1]]," ",n=3)[[2]] #State
    InputDataFrame[i,14]=str_split_fixed(str_split_fixed(x[4],",",n=string_count)[[string_count-1]]," ",n=3)[[3]] #Zip
    InputDataFrame[i,15]=str_split_fixed(x[4],",",n=string_count)[string_count] #Google_Country
    InputDataFrame[i,16]=x[5] #Channel
    InputDataFrame[i,17]=x[4] #Google_Address
    print(i)
  })

#for (i in 1:nrow(InputDataFrame))
#----------------------------------------------Export------------------------------------------------------
write.csv(x=InputDataFrame,file="OutputDataFrame.csv")
