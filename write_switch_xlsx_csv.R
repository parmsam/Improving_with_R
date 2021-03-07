#purpose: write to csv instead of xlsx (default) if dimension of data frame are or will be past xlsx limit soon
# switch to csv export automatically if file size is past set limits

#load necessary package to write xlsx
library(openxlsx)
#load stringr package if need to rename extensions
library(stringr) 

#max limit for xlsx is 1,048,576 rows by 16,384 columns; rounding down
#spec: https://support.microsoft.com/en-us/office/excel-specifications-and-limits-1672b34d-7043-467e-8e27-269d656771c3

#declare function
write_switch_xlsx_csv <- function(df, fileName, sheetName = "Sheet1"){
  fileName = str_replace(fileName, "\\.csv","\\.xlsx") #should be xlsx export by default; enforce this
  if( (dim(iris)[1] > 1000000) | (dim(iris)[2] > 16000) ) { #set limit here
    fileName = str_replace(fileName, "\\.xlsx","\\.csv") #rename file extension since need csv export
    write.csv(x = df,file = fileName) #write to csv
  }
  else { #write to xlsx via openxlsx package
    wb <- createWorkbook()
    addWorksheet(wb, sheetName = sheetName)
    writeData(wb, sheet = sheetName, x = df)
    saveWorkbook(wb, file = fileName, overwrite = TRUE)
  }
}

#test if needed on iris dataset
# library(tidyverse)
# iris
# write_switch_xlsx_csv(iris, "test.xlsx")
