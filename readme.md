# Resume as Code

**One JSON file. Two outputs. Zero manual work.**

Edit `resume.json` → push → GitHub Actions builds a static site (Astro) and a typeset PDF (Typst), then deploys both to GitHub Pages.

## Structure

```
resume.json                   ← ✏️  single source of truth (JSON Resume v1 schema)
│
├── src/                      ← Astro site (web)
│   ├── pages/index.astro     ← main page — imports resume.json directly
│   ├── components/           ← WorkEntry, SectionTitle
│   └── styles/global.css
│
├── typst/
│   ├── resume.typ            ← Typst PDF template (reads resume.json directly)
│   └── fonts/                ← bundled IBM Plex Sans for reproducible PDF builds
│
├── .github/workflows/
│   └── deploy.yml            ← validates JSON, builds site + PDF, deploys to Pages
│
├── astro.config.mjs
├── tailwind.config.mjs
└── package.json
```

## One-time setup

### 1. Push to your repo

```sh
git init
git remote add origin https://github.com/YOU/resume.git
git add . && git commit -m "resume as code"
git push -u origin master
```

The workflow triggers on pushes to `master`. If your default branch is `main`,
either rename it or change the trigger in `.github/workflows/deploy.yml`.

### 2. Enable GitHub Pages

Repo → **Settings → Pages → Source: GitHub Actions**

Your resume will be live within ~90 seconds. Custom domain via `CNAME`.

## Local development

```sh
npm ci
npm run dev          # Astro dev server with hot reload at localhost:4321
```

To preview the PDF locally, [install Typst](https://github.com/typst/typst/releases) then:

```sh
npm run build:pdf    # one-shot compile → dist/resume.pdf
npm run watch:pdf    # recompile on every save (great for iterating on resume.typ)
```

Both scripts pass `--font-path typst/fonts` (bundled IBM Plex Sans, so output
matches CI) and `--root .` (lets Typst read `resume.json` from the repo root).

## Updating your resume

1. Edit `resume.json`
2. `git commit -am "update resume" && git push`
3. Done — site and PDF rebuild automatically

## Customizing

| What | Where |
|---|---|
| Site layout & sections | `src/pages/index.astro` |
| Site colors / fonts | `tailwind.config.mjs` + `src/styles/global.css` |
| PDF layout & typography | `typst/resume.typ` |
| Resume data | `resume.json` |

The site and PDF are independent — style them however you like without
affecting each other.

## Schema

Follows the [JSON Resume](https://jsonresume.org/schema/) v1 open standard.

Validate locally against the upstream schema:

```sh
npm run validate
```

Or check it in your browser at https://jsonresume.org/.
