// Typesets resume.json (JSON Resume schema) as a modern single-column PDF.
// Serif display (IBM Plex Serif) for the name + section titles, IBM Plex Sans
// for body. US Letter, paginated. Fonts are bundled in typst/fonts.

#let d = json("../resume.json")

#set document(title: d.basics.name + " — Resume", author: d.basics.name)

// ── palette ──────────────────────────────────────────────────────────────
#let accent = rgb("c2410c") // burnt orange, matches the site
#let ink    = rgb("1a1a1a")
#let body   = rgb("333333")
#let muted  = rgb("5c5c5c")
#let faint  = rgb("d9d9d9")

// ── page + base type ─────────────────────────────────────────────────────
#set page(paper: "us-letter", margin: (x: 0.72in, y: 0.62in))
#set text(font: "IBM Plex Sans", size: 9.5pt, fill: body, fallback: false)
#set par(leading: 0.72em, spacing: 0.72em, justify: false)

#let serif = "IBM Plex Serif"

// ── date helpers ─────────────────────────────────────────────────────────
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

// ── building blocks ──────────────────────────────────────────────────────
#let tint = accent.lighten(86%)
#let square = box(baseline: 0.02em, width: 0.34em, height: 0.34em, fill: accent)

// filled accent chip holding a reversed-out section number
#let badge(n) = box(
  fill: accent,
  radius: 2pt,
  inset: (x: 4.5pt, y: 2.5pt),
  text(fill: white, size: 8pt, weight: "semibold")[#n],
)

// soft tinted pill for dates
#let pill(s) = box(
  fill: tint,
  radius: 3pt,
  inset: (x: 5pt, y: 2.5pt),
  text(fill: accent, size: 8pt, weight: "medium")[#s],
)

#let bullets(items) = {
  set par(leading: 0.58em, spacing: 0.6em)
  for item in items {
    grid(
      columns: (1em, 1fr),
      align: (left + top, left + top),
      move(dy: 0.32em, square), text(fill: body)[#item],
    )
  }
}

// numbered section header: "01  EXPERIENCE ────────────────"
#let sec = counter("sec")
#let section(title) = {
  sec.step()
  block(above: 1.5em, below: 0.9em, sticky: true, {
    grid(
      columns: (auto, auto, 1fr),
      align: horizon,
      column-gutter: 0.7em,
      context badge(sec.display("01")),
      text(font: serif, size: 12pt, weight: "medium", tracking: 0.05em)[#upper(title)],
      line(length: 100%, stroke: 0.5pt + faint),
    )
  })
}

// ── header ───────────────────────────────────────────────────────────────
#let basics = d.basics

#let contact-lines = {
  let parts = ()
  let email = basics.at("email", default: "")
  if email != "" { parts.push(link("mailto:" + email)[#email]) }
  let phone = basics.at("phone", default: "")
  if phone != "" { parts.push(phone) }
  let url = basics.at("url", default: "")
  if url != "" {
    let shown = url.replace("https://", "").replace("http://", "")
    parts.push(link(url)[#shown])
  }
  let loc = basics.at("location", default: none)
  if loc != none {
    let bits = ()
    let city = loc.at("city", default: "")
    if city != "" { bits.push(city) }
    let region = loc.at("region", default: "")
    if region != "" { bits.push(region) }
    if bits.len() > 0 { parts.push(bits.join(", ")) }
  }
  parts
}

#grid(
  columns: (1fr, auto),
  align: (left + bottom, right + bottom),
  column-gutter: 1em,
  {
    text(font: serif, size: 28pt, weight: "semibold", fill: ink, tracking: -0.01em)[#basics.name]
    v(0.42em)
    box(width: 2.1em, height: 3pt, fill: accent, radius: 1pt)
    v(0.42em)
    text(fill: accent, size: 9.5pt, weight: "medium", tracking: 0.2em)[
      #upper(basics.at("label", default: ""))
    ]
  },
  {
    set text(size: 8.8pt, fill: muted)
    set par(leading: 0.85em)
    align(right, contact-lines.join(linebreak()))
  },
)

#v(0.75em)
#line(length: 100%, stroke: 0.6pt + faint)

// summary as a lede paragraph (no section header)
#{
  let s = basics.at("summary", default: "")
  if s != "" {
    v(0.7em)
    text(size: 9.7pt, fill: body)[#s]
  }
}

// ── experience ───────────────────────────────────────────────────────────
#{
  let items = d.at("work", default: ())
  if items.len() > 0 {
    section("Experience")
    for job in items {
      block(above: 0.95em, breakable: false, {
        grid(
          columns: (1fr, auto),
          align: (left + horizon, right + horizon),
          text(weight: "bold", size: 10.5pt, fill: ink)[#job.name],
          pill(period(
            job.at("startDate", default: ""),
            job.at("endDate", default: ""),
          )),
        )
        v(0.12em)
        {
          text(fill: accent, weight: "semibold", size: 9.2pt)[#job.at("position", default: "")]
          let summary = job.at("summary", default: "")
          if summary != "" {
            text(fill: faint)[#h(0.5em) · #h(0.5em)]
            text(fill: muted, style: "italic")[#summary]
          }
        }
        let hl = job.at("highlights", default: ())
        if hl.len() > 0 {
          v(0.42em)
          bullets(hl)
        }
      })
    }
  }
}

// ── projects ─────────────────────────────────────────────────────────────
#{
  let items = d.at("projects", default: ())
  if items.len() > 0 {
    section("Projects")
    for proj in items {
      block(above: 0.95em, breakable: false, {
        grid(
          columns: (1fr, auto),
          align: (left + horizon, right + horizon),
          text(weight: "bold", size: 10.5pt, fill: ink)[#proj.name],
          {
            let kw = proj.at("keywords", default: ())
            if kw.len() > 0 { text(fill: muted, size: 8.6pt)[#kw.join(" · ")] }
          },
        )
        let desc = proj.at("description", default: "")
        if desc != "" {
          v(0.12em)
          text(fill: muted, style: "italic")[#desc]
        }
        let hl = proj.at("highlights", default: ())
        if hl.len() > 0 {
          v(0.42em)
          bullets(hl)
        }
      })
    }
  }
}

// ── skills ───────────────────────────────────────────────────────────────
#{
  let items = d.at("skills", default: ())
  if items.len() > 0 {
    section("Skills")
    for skill in items {
      grid(
        columns: (7.5em, 1fr),
        align: (left + top, left + top),
        column-gutter: 0.9em,
        inset: (y: 0.42em),
        text(weight: "semibold", size: 9pt, fill: ink)[#skill.name],
        text(fill: muted, size: 9pt)[#skill.at("keywords", default: ()).join("  ·  ")],
      )
    }
  }
}

// ── education ────────────────────────────────────────────────────────────
#{
  let items = d.at("education", default: ())
  if items.len() > 0 {
    section("Education")
    for edu in items {
      block(above: 0.7em, {
        grid(
          columns: (1fr, auto),
          align: (left + horizon, right + horizon),
          text(weight: "bold", size: 10pt, fill: ink)[#edu.institution],
          pill(period(
            edu.at("startDate", default: ""),
            edu.at("endDate", default: ""),
          )),
        )
        let bits = ()
        let study = edu.at("studyType", default: "")
        if study != "" { bits.push(study) }
        let area = edu.at("area", default: "")
        if area != "" { bits.push(area) }
        if bits.len() > 0 {
          v(0.1em)
          text(fill: muted)[#bits.join(", ")]
        }
      })
    }
  }
}

// ── interests ────────────────────────────────────────────────────────────
#{
  let items = d.at("interests", default: ())
  if items.len() > 0 {
    section("Interests")
    for interest in items {
      grid(
        columns: (7.5em, 1fr),
        align: (left + top, left + top),
        column-gutter: 0.9em,
        inset: (y: 0.42em),
        text(weight: "semibold", size: 9pt, fill: ink)[#interest.name],
        text(fill: muted, size: 9pt)[#interest.at("keywords", default: ()).join("  ·  ")],
      )
    }
  }
}
