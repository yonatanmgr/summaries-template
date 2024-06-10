// Workaround for the lack of an `std` scope.
#let std-bibliography = bibliography
#let std-smallcaps = smallcaps
#let std-upper = upper

#import "/template/utils.typ": *
#import "@preview/hydra:0.3.0": hydra
#import "@preview/outrageous:0.1.0"
#import "@preview/codly:0.2.0": *
#import "@preview/lovelace:0.2.0": *

// Overwrite the default `smallcaps` and `upper` functions with increased spacing between
// characters. Default tracking is 0pt.
#let smallcaps(body) = std-smallcaps(text(tracking: 0.6pt, body))
#let upper(body) = std-upper(text(tracking: 0.6pt, body))

// Colors used across the template.
#let stroke-color = luma(180)
#let fill-color = luma(250)
 
#let ilm(
  title: [כותרת המסמך],
  author: "כותב",
  author-mail: "",
  paper-size: "a4",
  date: none,
  abstract: none,
  preface: none,
  bibliography: none,
  // Whether to start a chapter on a new page.
  chapter-pagebreak: false,
  // Whether to display an index of figures (images).
  figure-index: false,
  // Whether to display an index of tables
  table-index: false,
  // Whether to display an index of listings (code blocks).
  listing-index: false,
  theorem-index: false,
  def-index: false,
  clear: true,
  meta: none,
  body,
) = {
  // set document(title: title, author: author)
  set text(font: meta.global.font, lang: "he", size: 0.97em)
  set raw(lang: "python")
  show raw: set text(font: ("Iosevka", "Fira Mono"), size: 9pt)

  set page(
    paper: paper-size,
    margin: (bottom: 2.25cm, top: 2.25cm),
    numbering: "1", 
    number-align: center,
    header: locate(loc => {
     let chap = hydra(1, loc: loc)
     let sect = hydra(2, loc: loc)
     if chap != none and query(heading.where(body: chap.children.slice(2).join())).len() > 0 [
       #link(query(heading.where(body: chap.children.slice(2).join())).first().location())[
         פרק #chap.children.first(): #strong(chap.children.slice(1).join()) 
       ]
       #if sect != none [\- #link(query(heading.where(body: sect.children.slice(2).join())).first().location())[_#sect.children.slice(1).join()_]]
       #line(length: 100%, stroke: stroke-color)
     ]
    })
  )

  // Code formatting.
  show: codly-init.with()
  let icon(codepoint) = {
    box(
      height: 1em,
      baseline: 0.2em,
      image(codepoint)
    )
    h(0.35em)
  }
  codly(languages: (
    python: (name: "Python", icon: icon("/resources/icons/python.svg"), color: rgb("#FFD343"), ),
  ), zebra-color: luma(245), stroke-width: 1.5pt, stroke-color: luma(220))

  // Pseudocode formatting.
  show: setup-lovelace
  set enum(numbering: "(1.א)")
  
  // Cover page.
  if clear == false {
    page(align(right + bottom, block(width: 90%)[
      #place(top, float: true)[
        #place(top+left, dx: 100%-550pt, dy: 100%-610pt)[
          #box(width: 700pt, clip: true, height: 500pt)[
            #image(meta.global.cover, fit: "cover", )
          ]
        ]
      ]
      
      #let v-space = v(2em, weak: true)
      #text(3em)[*#title*]

      #v-space
      #text(1.6em, link("mailto:"+author-mail)[#author])

      #if abstract != none {
        v-space
        block(width: 85%)[
          // Default leading is 0.65em.
          #par(leading: 0.78em, justify: true, linebreaks: "optimized", text(1em, abstract))
        ]
      }

      #if date != none {
        v-space
        // Display date as MMMM DD, YYYY
        text(date.display("[day padding:zero]/[month]/[year repr:full]"))
      }
    ]), numbering: none)
  }
  // Configure paragraph properties.
  // Default leading is 0.65em.
  set par(leading: 1em, justify: true, linebreaks: "optimized")
  // Default spacing is 1.2em.
  show par: set block(spacing: 1.35em)

  // Show a small maroon circle next to external links.
  show link: it => {
    // Workaround for ctheorems package so that its labels keep the default link styling.
    if type(it.dest) == label or type(it.dest) == location { return it }
    else if not clear {
      it
      h(1.6pt)
      super(box(height: 3.8pt, circle(radius: 1.2pt, stroke: 0.7pt + rgb("#993333"))))
    } else {
      it
    }
  }

  show outline.entry: outrageous.show-entry.with(font-weight: ("bold", auto), font: (meta.global.font, auto), body-transform: (lvl, body) => {
    if "children" in body.fields() {
      let (number, space, ..text) = body.children
      style(styles => {
        h(measure([.], styles).width * (lvl - 1))
        if not number.at("text", default: "").starts-with(regex("\d")) {
          [#((space,) + text).join()]
        } else {
          [#number. #text.join()]
        }
      })
    }
  })

  if clear == false {
    if preface != none {
      set heading(numbering: none)
      page(preface)
    }
  
    outline(title: [#text(size: 1.2em)[תוכן עניינים] 
    #v(0.5em)], depth: 2, indent: true)
    pagebreak(weak: true)
  }

  show raw.where(block: false): box.with(
    fill: fill-color.darken(2%),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )

  // Display block code with padding.
  show raw.where(block: true): block.with(
    inset: (x: 5pt),
  )

  // Break large tables across pages.
  show figure.where(kind: table): set block(breakable: true)
  set table(
    // Increase the table cell's padding
    inset: 7pt, // default is 5pt
    stroke: (0.5pt + stroke-color)
  )

  // Headings Numbering.
  set heading(numbering: (..nums) => {
    let nums = nums.pos()
    if nums.len() < 4 {
      numbering("1.1", ..nums)
    }
  })
  
  show heading: it => block({
    if it.numbering != none {
      numbering(it.numbering, ..counter(heading).at(it.location()))
      if it.level < 4 { [. ] }
    }
    it.body
  })

  // Heading spacings
  show heading.where(level: 1): it => {
    if chapter-pagebreak {pagebreak(weak: true)}
    [#text(size: 1.3em)[#it]]
    v(0.3cm)
  }
  
  show heading.where(level: 2): it => {
    it
    v(0.2cm)
  }
  
  show heading.where(level: 3): it => {
    it
    v(0.1cm)
  }

  // Patch for #3696
  show math.equation.where(block: false): if sys.version.minor > 10 {
      it => box({
      // set par(leading: 3em)
      text(dir: ltr)[#it]
    }) 
  } else {
    it => it
  }

  // Patch for #3695
  show regex("\p{Hebrew}.+"): it => text(dir: rtl, font: meta.global.font, lang: "he")[#it]

  // Section/file Title
  {
    locate(loc => {
      if clear == true and loc.page() == 1 {
         place(top+left, float: false, dy: -39pt)[
            #meta.global.course-name: *#meta.local* (#date.display("[day padding:zero]/[month]/[year repr:full]")) | #author
        ]
       } else if loc.page() > 1 and meta.keys().contains("local") {
           place(top+left, float: false, dy: -39pt)[
             #meta.local (#date.display("[day padding:zero]/[month]/[year repr:full]"))
              #line(length: 100%, stroke: stroke-color)
         ]
        }
    })
  }
  
  body

  // Index
  if not clear and sys.version.minor > 10 {
    let fig-t(kind) = query(figure.where(supplement: [#kind]))
    let has-fig(kind) = counter(figure.where(supplement: [#kind])).get().at(0) > 0
    
    set page(header: [
      נספח: *מפתח העניינים*
      #line(length: 100%, stroke: stroke-color)
    ],)
    
    context {
      let theorems = fig-t("משפט")
      let lems = fig-t("למה")
      let props = fig-t("טענה")
      let defs = fig-t("הגדרה")
      
      let show-theorems = theorem-index and has-fig("משפט")
      let show-defs = def-index and has-fig("הגדרה")

      if show-defs or show-theorems {pagebreak()}

      let index(title, prefix: false, items) = {
        show par: it => par(justify: false)[#it]
        [#heading(bookmarked: false, outlined: false, numbering: none, level: 2)[#text(size: 1.15em)[#title]]]
        for item in items.flatten()
          .filter(x => x.caption.body.has("text") or x.caption.body.children.len() > 0)
          .sorted(key: x => {
            if x.caption.body.has("text") {
              return x.caption.body.text
            } else {return "תתת"}
          })
          .dedup(key: x => {return x.caption}) [
              / #link(item.location())[
                  #box(width: 100%-1em)[
                    #if prefix {[(#item.supplement.text.first())]}
                    #item.caption.body
                  ]
                ]: #place(left+top)[#item.location().page()
              ]
          ]
          // colbreak(weak: true)
      }

      columns(2, gutter: 20pt)[
        #place(dy: -200pt)[
            #heading(level: 1, numbering: none, bookmarked: true)[נספחים]
            #heading(level: 2, numbering: none, bookmarked: true)[מפתח העניינים]
        ]

        #if show-defs [#index("הגדרות", (defs))]
        
        #if show-theorems [#index("ל‏ֵמוֹת, טענות ומשפטים", (theorems, lems, props), prefix: true)]
      ]
    }
  }

  // Display bibliography.
  if bibliography != none {
    // Display bibliography on a new page regardless of whether `chapter-pagebreak` is
    // enabled or not.
    pagebreak()
    show std-bibliography: set text(0.85em)
    // Use default paragraph properties for bibliography.
    show std-bibliography: set par(leading: 0.65em, justify: false, linebreaks: auto)
    bibliography
  }
}

// This function formats its `body` (content) into a blockquote.
#let blockquote(body) = {
  block(
    width: 100%,
    fill: fill-color,
    inset: 2em,
    stroke: (y: 0.5pt + stroke-color),
    body
  )
}

