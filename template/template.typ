#import "/template/ilm-custom.typ": *
#import "/template/thm-custom.typ": *
#import "/template/utils.typ": *
#import "/template/functions.typ": *

// Config file.
#let cmeta = yaml("/config.yaml")

// Environment definitions.
#let question = newenv("global", "שאלה", olive, addon: "תשובה").with([])
#let ex = newenv("exercise", "תרגיל", teal, addon: "פתרון", numbering: 0).with([])
#let exqed = newenv("exercise", "תרגיל", qed: true, teal, addon: "פתרון", numbering: 0).with([])
#let example = newenv("example", "דוגמה", green, numbering: 0).with([])
#let namedex = newenv("exercise", "תרגיל", teal, addon: "פתרון", numbering: 0)
#let def = newenv("global", "הגדרה", blue)
#let prop = newenv("global", "טענה", purple, addon: "הוכחה", qed: true)
#let conclusion = newenv("global", "מסקנה", color.hsl(50deg,200,60))
#let conclusionqed = newenv("global", "מסקנה", qed: true, addon: "הוכחה", color.hsl(50deg,200,60))
#let the = newenv("global", "משפט", red, addon: "הוכחה", qed: true)
#let lem = newenv("global", "למה", orange, addon: "הוכחה", qed: true)
#let note = newenv("global", "הערה", black, alt: true, centered: true).with([])
#let thebr = newenv("global", "משפט", red, addon: "הוכחה", qed: true, breakable: true)
#let lembr = newenv("global", "למה", orange, addon: "הוכחה", qed: true, breakable: true)
#let propbr = newenv("global", "טענה", purple, addon: "הוכחה", qed: true, breakable: true)