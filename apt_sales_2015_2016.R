library(data.table)

result_sales_dt
View(result_sales_dt)
result_sales_dt[,max(as.character(yyyy))]
table(result_sales_dt$typenm)


library(readxl)

library(dplyr)

tbls <- list()

for(m in 4:12){

for(i in 1:17){
  shet <- read_excel(sprintf("/Users/gogamza/ownCloud/DATA/apt_sales/2015년_%s월_전국_실거래가_아파트(매매).xls", str_pad(as.character(m),width = 2,pad = "0")),sheet = i,skip = 7) %>% data.table
  shet[,ym:=paste0('2015', str_pad(as.character(m),width = 2,pad = "0"))]
  tbls[[i]] <- shet
  }
}

tbls_2015 <- bind_rows(tbls)


tbls_ <- list()

for(m in 1:10){

for(i in 1:17){
  shet <- read_excel(sprintf("/Users/gogamza/ownCloud/DATA/apt_sales/2016년_%s월_전국_실거래가_아파트(매매).xls", str_pad(as.character(m),width = 2,pad = "0")),sheet = i,skip = 7) %>% data.table
  shet[,ym:=paste0('2016', str_pad(as.character(m),width = 2,pad = "0"))]
  tbls_[[i]] <- shet
  }
}

tbls_2016 <- bind_rows(tbls_)


tbls_total <- rbind(tbls_2015, tbls_2016)


save(tbls_total,file = "result_sales_dt_2015_2016.RData")



