# Resume as Code

Edit `resume.json`, push to `master`, and GitHub Actions builds a static site
(Astro) and a typeset PDF (Typst), then deploys both to GitHub Pages.

```
resume.json              single source of truth (JSON Resume schema)
src/                     Astro site — pages/index.astro reads resume.json
typst/resume.typ         PDF template — also reads resume.json
public/CNAME             custom domain, copied into the build output
.github/workflows/       validate → build site + PDF → deploy to Pages
```

## Setup

1. Push to your repo's `master` branch.
2. Repo → **Settings → Pages → Source: GitHub Actions**.
3. For a custom domain, set it in `public/CNAME` (one host per line).

## Local development

```sh
npm install
npm run dev          # http://localhost:4321

npm run build:pdf    # compile PDF (requires Typst)
npm run watch:pdf    # recompile on save
npm run validate     # check resume.json against the schema
```

No `package-lock.json` is committed: rollup's platform-specific binaries must
resolve per-machine (npm/cli#4828), so use `npm install`, not `npm ci`.

## Editing

| What | Where |
|---|---|
| Content | `resume.json` |
| Site layout | `src/pages/index.astro`, `src/components/` |
| Site styling | `tailwind.config.mjs`, `src/styles/global.css` |
| PDF layout | `typst/resume.typ` |
