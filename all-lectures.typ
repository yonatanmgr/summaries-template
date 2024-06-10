#import "/template/template.typ": *
#show: thmrules

#let abst = [
  #if cmeta.lecturers.len() > 1 [*שמות המרצים*] else [*שם המרצה*]: #concat_hebrew(cmeta.lecturers) | *מספר הקורס*: #cmeta.course-number \
  הוקלד באמצעות #link("https://github.com/typst/typst")[typst] לאורך סמסטר #cmeta.semester.
  טל"ח.
  #if cmeta.block-style != "classic" and cmeta.keys().contains("print-ver-url") {
    place(left+bottom, dx: -150pt, dy: 60pt)[
      #link(cmeta.print-ver-url)[#underline[גרסה להדפסה]]
    ]
  }
]

#show: ilm.with(
  title: [#cmeta.course-name - \ סיכומי הרצאות],
  author: cmeta.author,
  author-mail: cmeta.author-mail,
  date: datetime.today(),
  abstract: abst,
  clear: false,
  meta: (global: cmeta),
  theorem-index: true,
  def-index: true
)

#let start = 1;
#let end = 1;
#let skip_lec = ()
#let skip_rec = ()

#{for num in range(start, end+1) {
  if not skip_lec.contains(num) {
    include "/lectures/lecture_"+zero_pad(num)+".typ"
    pagebreak(weak: true)
  }

  if cmeta.include-recitations {
    if not skip_rec.contains(num) {
      include "/recitations/rec_"+zero_pad(num)+".typ"
      pagebreak(weak: true)
    }
  }
}}