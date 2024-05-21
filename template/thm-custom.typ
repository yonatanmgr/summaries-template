// Store theorem environment numbering
#import "@preview/showybox:2.0.1": *
#let cmeta = yaml("/config.yaml")

#let thmcounters = state("thm",
  (
    "counters": ("heading": ()),
    "latest": ()
  )
)

#let thmenv(identifier, base, base_level, fmt, ..args) = {

  let global_numbering = numbering

  return (
    ..args,
    body,
    number: auto,
    numbering: "1.1",
    refnumbering: auto,
    supplement: identifier,
    supplement-display: args.named().id-display,
    base: base,
    base_level: base_level
  ) => {
    let name = none
    if args != none and args.pos().len() > 0 {
      name = args.pos().first()
    }
    if refnumbering == auto {
      refnumbering = numbering
    }
    let result = none
    if number == auto and numbering == none {
      number = none
    }
    if number == auto and numbering != none {
      result = locate(loc => {
        return thmcounters.update(thmpair => {
          let counters = thmpair.at("counters")
          // Manually update heading counter
          counters.at("heading") = counter(heading).at(loc)
          if not identifier in counters.keys() {
            counters.insert(identifier, (0, ))
          }

          let tc = counters.at(identifier)
          if base != none {
            let bc = counters.at(base)

            // Pad or chop the base count
            if base_level != none {
              if bc.len() < base_level {
                bc = bc + (0,) * (base_level - bc.len())
              } else if bc.len() > base_level{
                bc = bc.slice(0, base_level)
              }
            }

            // Reset counter if the base counter has updated
            if tc.slice(0, -1) == bc {
              counters.at(identifier) = (..bc, tc.last() + 1)
            } else {
              counters.at(identifier) = (..bc, 1)
            }
          } else {
            // If we have no base counter, just count one level
            counters.at(identifier) = (tc.last() + 1,)
            let latest = counters.at(identifier)
          }

          let latest = counters.at(identifier)
          return (
            "counters": counters,
            "latest": latest
          )
        })
      })

      number = thmcounters.display(x => {
        return global_numbering(numbering, ..x.at("latest"))
      })
    }

    return figure(
      result +  // hacky!
      fmt(name, number, body, ..args.named()) +
      [#metadata(identifier) <meta:thmenvcounter>],
      kind: "thmenv",
      outlined: false,
      caption: name,
      supplement: supplement-display,
      numbering: refnumbering,
    )
  }
}

#let thmrules(qed-symbol: $qed$, doc) = {

  show figure.where(kind: "thmenv"): it => it.body

  show ref: it => {
    if it.element == none {
      return it
    }
    if it.element.func() != figure {
      return it
    }
    if it.element.kind != "thmenv" {
      return it
    }

    let supplement = it.element.supplement
    if it.citation.supplement != none {
      supplement = it.citation.supplement
    }

    let loc = it.element.location()
    let thms = query(selector(<meta:thmenvcounter>).after(loc), loc)
    let number = thmcounters.at(thms.first().location()).at("latest")
    return link(
      it.target,
      [#supplement~#numbering(it.element.numbering, ..number)]
    )
  }

  doc
}

#let QED = place(left, dy: 0cm, dx: -0.37cm, $qed$)

#let boxargs(head, number, name, color, alt: false, centered: false, breakable: false) = {
  let style = none
  let sep-style = none
  if alt == true {
    style = (
    boxed-style: (anchor: (x: if centered {center} else {start}), radius: 2pt),
    radius: 2pt,
    thickness: (right: 0.8pt, top:  0.8pt, left: 0.8pt, bottom: 0.8pt)
    )
  }
  
  if cmeta.block-style == "classic" {
    style = (
      color: black,
      title-color: white,
      footer-color: white,
      thickness: (0pt),
      align: right,
      title-inset: (right: 0pt, top: 8pt, bottom: 8pt, left: 0pt),
      body-inset: (right: 0pt, top: 8pt, bottom: 8pt, left: 0pt),
      footer-inset: (right: 0pt, top: 8pt, bottom: 8pt, left: 0pt)
    )
    sep-style = (
      thickness: 0pt
    )
  }

  let args = (
    title: [#head #number#if name != [] {[ (#name)]} else {[]}:],
    title-style: (
      align: if centered {center} else {start},
      weight: 900,
      sep-thickness: 0pt,
      color: color.darken(50%),
      ..style
    ),
    body-style: (align: right),
    footer-style: (align: right, sep-thickness: 0pt, color: luma(20%)),
    breakable: breakable,
    sep: (
      thickness: 0.8pt,
      dash: "densely-dotted",
      gutter: 1em,
      ..sep-style
    ),
    frame: (
      radius: 0pt,
      thickness: (right: 0.8pt),
      title-color: color.lighten(90%),
      footer-color: luma(88%),
      border-color: color.darken(50%),
      inset: 8pt,
      body-inset: 10pt,
      footer-inset: 10pt,
      ..style,
    ),
  )
  return args
}

#let newenv(id, head, color, addon: none, numbering: none, qed: false, alt: false, centered: false, breakable: false) = {
  return (title, ..body) => {
    let t = thmenv(id, "heading", id-display: head, numbering, (name, number, _) => [
      #let args = boxargs(head, number, name, color, alt: alt, centered: centered, breakable: breakable)
      
      #if body.pos().len() == 1 {
        showybox(..args)[#body.pos().at(0)]
      } else if body.pos().len() == 2 {
        if body.pos().at(1) == [] {
          showybox(..args)[#body.pos().at(0)]
        } else {
          showybox(..args)[#body.pos().at(0)][
              #if addon != none {[#emph[#addon]:]} #body.pos().at(1)
              #if qed {QED}
            ]
        }
      } else if body.pos().len() == 3 {
        if body.pos().at(1) == [] {
          if body.pos().at(2) == [] {
            showybox(..args)[#body.pos().at(0)]
          } else {
            showybox(..args, footer: emph[#body.pos().at(2)])[#body.pos().at(0)]
          }
        } else {
          if body.pos().at(2) == [] {
            showybox(..args)[#body.pos().at(0)][
              #if addon != none {[#emph[#addon]:]} #body.pos().at(1)
              #if qed {QED}
            ]
          } else {
            showybox(..args, footer: emph[#body.pos().at(2)])[#body.pos().at(0)][
              #if addon != none {[#emph[#addon]:]} #body.pos().at(1)
              #if qed {QED}
            ]
          }
        } 
      } 
    ])
    t(title, ..body)
    }
  }
}