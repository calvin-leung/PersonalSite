// Typesets resume.json (JSON Resume schema) as a single-column PDF.

#let d = json("../resume.json")

#let accent = rgb("dc2626")
#let muted  = rgb("666666")

#set page(width: 595.92pt, height: auto, margin: (x: 20mm, y: 20mm))
#set text(font: "IBM Plex Sans", size: 10.5pt, fallback: false)
#set par(leading: 0.65em)

#let months = (
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
)

#let fmt-date(s) = {
  if s == none or s == "" { return "" }
  let parts = s.split("-")
  if parts.len() < 2 { return s }
  let m = int(parts.at(1))
  if m < 1 or m > 12 { return s }
  months.at(m - 1) + " " + parts.at(0)
}

#let period(start, end) = {
  let s = fmt-date(start)
  let e = fmt-date(end)
  if s != "" and e != "" { return s + " – " + e }
  if s != "" { return s + " – Present" }
  return e
}

#let section(title) = {
  v(0.9em)
  text(weight: "bold", fill: accent)[#upper(title)]
  v(-0.3em)
  line(length: 100%, stroke: 0.5pt + accent)
}

#let bullets(items) = {
  for item in items {
    grid(columns: (1em, 1fr), align: top, [•], [#item])
    v(-0.2em)
  }
}

#let basics = d.basics

#text(size: 22pt, weight: "bold")[#basics.name]
#v(0.1em)
#text(fill: muted)[#basics.at("label", default: "")]

#v(0.5em)
#{
  let parts = ()
  let email = basics.at("email", default: "")
  if email != "" { parts.push(email) }
  let phone = basics.at("phone", default: "")
  if phone != "" { parts.push(phone) }
  let url = basics.at("url", default: "")
  if url != "" { parts.push(url) }
  let loc = basics.at("location", default: none)
  if loc != none {
    let bits = ()
    let city = loc.at("city", default: "")
    if city != "" { bits.push(city) }
    let region = loc.at("region", default: "")
    if region != "" { bits.push(region) }
    if bits.len() > 0 { parts.push(bits.join(", ")) }
  }
  text(size: 9pt, fill: muted)[#parts.join("   ·   ")]
}

#v(0.3em)
#line(length: 100%, stroke: 0.5pt + accent)

#{
  let s = basics.at("summary", default: "")
  if s != "" {
    section("Summary")
    v(0.4em)
    [#s]
  }
}

#{
  let items = d.at("skills", default: ())
  if items.len() > 0 {
    section("Skills")
    for skill in items {
      v(0.4em)
      text(weight: "semibold")[#skill.name]
      linebreak()
      text(fill: muted)[#skill.at("keywords", default: ()).join(", ")]
    }
  }
}

#{
  let items = d.at("work", default: ())
  if items.len() > 0 {
    section("Experience")
    for job in items {
      v(0.5em)
      grid(
        columns: (1fr, auto),
        text(weight: "bold")[#job.name],
        text(fill: muted)[#period(job.at("startDate", default: ""), job.at("endDate", default: ""))],
      )
      let summary = job.at("summary", default: "")
      if summary != "" {
        text(fill: muted, style: "italic")[#summary]
        linebreak()
      }
      text(fill: muted)[#job.at("position", default: "")]
      let hl = job.at("highlights", default: ())
      if hl.len() > 0 {
        v(0.2em)
        bullets(hl)
      }
    }
  }
}

#{
  let items = d.at("projects", default: ())
  if items.len() > 0 {
    section("Projects")
    for proj in items {
      v(0.5em)
      text(weight: "bold")[#proj.name]
      let desc = proj.at("description", default: "")
      if desc != "" {
        linebreak()
        text(fill: muted)[#desc]
      }
      let hl = proj.at("highlights", default: ())
      if hl.len() > 0 {
        v(0.2em)
        bullets(hl)
      }
    }
  }
}

#{
  let items = d.at("education", default: ())
  if items.len() > 0 {
    section("Education")
    for edu in items {
      v(0.5em)
      grid(
        columns: (1fr, auto),
        text(weight: "bold")[#edu.institution],
        text(fill: muted)[#period(edu.at("startDate", default: ""), edu.at("endDate", default: ""))],
      )
      let bits = ()
      let study = edu.at("studyType", default: "")
      if study != "" { bits.push(study) }
      let area = edu.at("area", default: "")
      if area != "" { bits.push(area) }
      if bits.len() > 0 { text(fill: muted)[#bits.join(", ")] }
    }
  }
}

#{
  let items = d.at("interests", default: ())
  if items.len() > 0 {
    section("Interests")
    for interest in items {
      v(0.4em)
      text(weight: "semibold")[#interest.name]
      linebreak()
      text(fill: muted)[#interest.at("keywords", default: ()).join(", ")]
    }
  }
}
