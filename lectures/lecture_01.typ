#import "/template/template.typ": *
#show: thmrules
#let lecture-name = "הרצאה 1"
#show: ilm.with(
  clear: true, 
  meta: (global: cmeta, local: lecture-name), 
  date: datetime(day: 1, month: 1, year: 2024), 
  author: cmeta.author,
  theorem-index: true
)

