library(data.table)

result_sales_dt
View(result_sales_dt)
result_sales_dt[,max(as.character(yyyy))]
table(result_sales_dt$typenm)


library(readxl)
library(stringr)
library(dplyr)

tbls <- list()

for(m in 4:12){

for(i in 1:17){
  shet <- read_excel(sprintf("C:/Users/gogamza/ownCloud/DATA/apt_sales/2015년_%s월_전국_실거래가_아파트(매매).xls", 
                             str_pad(as.character(m),width = 2,pad = "0")),sheet = i,skip = 7) %>% data.table
  shet[,ym:=paste0('2015', str_pad(as.character(m),width = 2,pad = "0"))]
  tbls[[paste0(m,i)]] <- shet
  }
}

tbls_2015 <- bind_rows(tbls)


tbls_ <- list()

for(m in 1:11){

for(i in 1:17){
  shet <- read_excel(sprintf("C:/Users/gogamza/ownCloud/DATA/apt_sales/2016년_%s월_전국_실거래가_아파트(매매).xls", str_pad(as.character(m),width = 2,pad = "0")),sheet = i,skip = 7) %>% data.table
  shet[,ym:=paste0('2016', str_pad(as.character(m),width = 2,pad = "0"))]
  tbls_[[paste0(m,i)]] <- shet
  }
}

tbls_2016 <- bind_rows(tbls_)


tbls_total <- rbind(tbls_2015, tbls_2016)


save(tbls_total,file = "result_sales_dt_2015_2016.RData")

setnames(tbls_total, c('si_gun_gu', 'm_bun', 'dangi', 'area', 'cont_date', 'price', 'floor', 'year_of_construct', 'road_nm', 'ym'))

tbls_total[,price:=str_replace_all(price,pattern = ",", "")]

tbls_total[,si_gun_gu:=str_trim(si_gun_gu)]

tbls_total[,region:=str_sub(si_gun_gu, 1,2)]
tbls_total[str_sub(si_gun_gu, 1,4) == '충청북도', region:='충북']
tbls_total[str_sub(si_gun_gu, 1,4) == '충청남도', region:='충남']
tbls_total[str_sub(si_gun_gu, 1,4) == '전라북도', region:='전북']
tbls_total[str_sub(si_gun_gu, 1,4) == '전라남도', region:='전남']
tbls_total[str_sub(si_gun_gu, 1,4) == '경상북도', region:='경북']
tbls_total[str_sub(si_gun_gu, 1,4) == '경상남도', region:='경남']


names(result_sales_dt)
result_sales_dt[,typenm]

tbls_total[,typenm:='아파트']

names(tbls_total)

tbls_total[,mm:=str_sub(ym, 5,7)]


tbls_total[,price:=as.numeric(price)]
tbls_total[,floor:=as.numeric(floor)]
tbls_total[,mm:=substr(ym, 5,6)]
tbls_total[between(as.numeric(mm), 1, 3), qrt:='Q1']
tbls_total[between(as.numeric(mm), 4, 6), qrt:='Q2']
tbls_total[between(as.numeric(mm), 7, 9), qrt:='Q3']
tbls_total[between(as.numeric(mm), 10, 12), qrt:='Q4']
tbls_total[,yyyyqrt:=paste0(substr(ym, 1,4), qrt)]
tbls_total[,yyyy:=factor(substr(ym, 1,4))]
tbls_total[,yyyyqrt:=factor(yyyyqrt)]

tbls_total[,yyyymm:=ym]



result_sales_dt[,m_bun:=ifelse(s_bun == 0 ,as.character(m_bun),paste0(m_bun, '-', s_bun))]

result_sales_dt[,s_bun:=NULL]


result_sales_dt_newest <- rbind(result_sales_dt[yyyymm != '201504'], tbls_total[,-c('ym'), with=F])


save(result_sales_dt_newest, file='result_sales_dt_newest.RData')







