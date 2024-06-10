#import "/template/template.typ": *
#show: thmrules
#let lecture-name = "תרגול 1"
#show: ilm.with(
  clear: true, 
  meta: (global: cmeta, local: lecture-name), 
  date: datetime(day: 27, month: 5, year: 2024), 
  author: cmeta.author,
  theorem-index: true
)
