---
name: tectonic-pdf
description: Generate PDFs from LaTeX (.tex) or Markdown (.md) using Tectonic, a self-contained TeX engine. Use whenever the user wants a PDF, whether converting markdown, compiling existing LaTeX, writing a document from scratch (reports, resumes, letters, CVs), or live-rebuilding while the user edits. Trigger on words like "make a PDF", "convert to PDF", "render this markdown", "compile this tex", "latex", "tectonic", "typeset" — even when the tool is never named.
---

# Tectonic PDF generation

Tectonic is a self-contained XeTeX-based TeX engine installed at `/usr/bin/tectonic` (v0.17). Unlike a full TeX Live install, it downloads packages ("bundles") on demand to a per-user cache on first use, so **the first compile of any document may take a minute while the bundle downloads; subsequent compiles take seconds**. It runs multiple passes automatically (cross-references, TOC, bibtex-style reruns), so you never need to compile twice.

Tectonic cannot parse Markdown itself — it compiles (La)TeX only. Markdown must be converted to LaTeX first (see "Markdown → PDF" below).

## Choose your workflow

| Input | Workflow |
| --- | --- |
| `.tex` file(s) the user has | Compile directly (Workflow A) |
| `.md` / markdown content | Convert to LaTeX, then compile (Workflow B) |
| No file — user describes a document | Write the LaTeX yourself (Workflow C) |
| User wants to keep editing / iterate | Add `-X watch` (Workflow D) |

## Workflow A: Compile existing LaTeX

```bash
tectonic -X compile main.tex
```

Produces `main.pdf` next to `main.tex`. Useful flags:

- `--outdir DIR` — put output elsewhere
- `--keep-logs` — keep the `.log` file (invaluable for debugging, see Troubleshooting)
- `--synctex` — SyncTeX data for editor source-linking
- `-p, --print` — show the engine's chatter (warnings, overfull boxes)
- `--reruns N` — force extra engine passes

If the project uses multiple `.tex` files with `\input`/`\include`, compile the root file only — Tectonic resolves the includes automatically.

## Workflow B: Markdown → PDF

1. Convert the markdown to LaTeX (see conversion rules below).
2. Compile with Workflow A.

If `pandoc` is installed, it is a faster path: `pandoc input.md -o output.pdf --pdf-engine=tectonic`. Check with `which pandoc` — on systems where it's absent (it is on this machine), do the conversion manually.

Never hand the markdown file to tectonic itself; it will fail.

## Workflow C: Writing a document from scratch

For a single-file document, write a complete standalone `.tex` file. Minimal skeleton:

```latex
\documentclass[11pt]{article}
\usepackage[margin=1in]{geometry}
\usepackage{hyperref}
\title{...}
\author{...}
\begin{document}
\maketitle
...content...
\end{document}
```

For a multi-file project (or when the user wants a repeatable structure), scaffold a project:

```bash
tectonic -X new mydoc        # creates mydoc/ with src/index.tex, src/_preamble.tex, src/_postamble.tex, Tectonic.toml
cd mydoc && tectonic -X build
```

Project output goes to `build/default/default.pdf`, NOT the project root — tell the user where it landed. Edit `src/index.tex` for content, `src/_preamble.tex` for the preamble. The template splits the document into preamble/content/postamble, so keep `\documentclass` and `\begin{document}` in the preamble file and `\end{document}` in the postamble.

## Workflow D: Live rebuilding

```bash
cd mydoc && tectonic -X watch        # rebuilds on every file change
tectonic -X watch -x "build --keep-logs"   # custom build command via -x/--exec
```

Great when the user is iterating on a document. Tell them to leave it running.

## Markdown → LaTeX conversion rules

Convert every markdown construct; don't leave any plain markdown syntax in the `.tex`.

| Markdown | LaTeX |
| --- | --- |
| `# H1` … `###### H6` | `\section{...}` … `\subparagraph{...}` (or `\subsection` etc. — use `article`'s sectioning, skipping H1 if it's the title) |
| `**bold**` | `\textbf{...}` |
| `*italic*` / `_italic_` | `\textit{...}` |
| `` `code` `` | `\texttt{...}` |
| Inline links `[text](url)` | `\href{url}{text}` (needs `\usepackage{hyperref}`) |
| Images `![alt](path)` | `\includegraphics[width=\linewidth]{path}` (needs `\usepackage{graphicx}`) |
| Unordered lists `- item` / `* item` | `\begin{itemize} \item ... \end{itemize}` |
| Ordered lists `1. item` | `\begin{enumerate} \item ... \end{enumerate}` |
| Nested lists | Nested `itemize`/`enumerate` environments |
| Fenced code blocks ```` ```lang ```` | `\begin{lstlisting}[language=lang] ... \end{lstlisting}` (needs `\usepackage{listings}`); or `verbatim` for no syntax highlighting |
| Tables | `tabular` or `tabularx` (needs `\usepackage{tabularx}` for wrapped columns) |
| Blockquote `> text` | `\begin{quote} ... \end{quote}` |
| Horizontal rule `---` | `\hrule` or `\noindent\rule{\linewidth}{0.4pt}` |
| Math `$...$` / `$$...$$` | Leave as-is — tectonic handles `$...$` and `\[...\]` natively |

Pitfalls to watch for:

- **Escape special characters**: `% # & _ { } $` (and `~ ^ \` where needed) must be escaped with a backslash in text, or the compile fails. The markdown source itself is the best place to catch these. Braces inside `\texttt{...}` count too: `\texttt{\{"apiVersion": "v1", \ldots\}}`.
- **Emoji do not render** (❌ ✅ 👉 live outside Latin Modern's glyph set): replace them with plain words, `$\rightarrow$`, or colored status text in the `.tex` (keep them in the `.md` if it doubles as an Obsidian note).
- **Long inline `\texttt{...}` strings overflow the line** ("Overfull \hbox"): wrap the paragraph in `\begin{sloppypar}...\end{sloppypar}`.
- **Wrap long table cells**: use `tabularx` with an `X` column instead of `tabular`, or content overflows the page.
- **Page geometry**: add `\usepackage[margin=1in]{geometry}` so pages don't use TeX's cramped default margins.
- **Code blocks with `#` or `_`**: inside `lstlisting`, no escaping is needed — don't escape inside verbatim environments.

## LaTeX writing guidance

- Engine is XeTeX: **UTF-8/Unicode text works natively** (em-dashes, accented letters, curly quotes, CJK with a suitable font via `fontspec`).
- Packages verified to work with the default bundle: `geometry`, `listings`, `tabularx`, `array`, `caption`, `hyperref`, `graphicx`, `xcolor`, `tcolorbox`, `titlesec`, `fancyhdr`, `tikz`, `float`, `parskip`, `sourceserifpro`, `sourcesanspro`, `sourcecodepro`. Don't be shy about using them — Tectonic fetches them automatically.
- Prefer `article` class for reports/notes; `letter`/custom for letters; `amsart`/`amsmath` for math-heavy docs.
- Compile after every meaningful change so errors surface early and the user sees progress.

## Visual design: O'Reilly-style boxes & color

Study notes and reports read much better with colored callout boxes and a consistent palette — the classic "O'Reilly book" look: a light box, colored left bar, and a small attached label tag (TIP / NOTE / WARNING / IMPORTANT / CLARIFICATION). Users ask for this as "tips and clarification boxes", "colored boxes", "like O'Reilly books" — treat those phrases as styling requests.

- **Fonts**: O'Reilly's Thesis family (TheSerif/TheSans/TheSansMono) is commercial; the free analogues that compile in tectonic are Adobe's **Source Serif Pro** (body), **Source Sans Pro** (headings), **Source Code Pro** (code) — `\usepackage[default]{sourceserifpro}` etc., with the `[default]` on the serif package only. See `references/oreilly-style.md` (Fonts section) for the exact snippet.
- **House style**: practical rules from the official O'Reilly style guide (captions sentence-case without trailing period, italic emphasis, list punctuation, serial comma, code line length) are in `references/oreilly-house-style.md` — apply them to study-note text when the user wants an "O'Reilly-like" document.

- Color maps to meaning: **green = TIP, blue = NOTE, red = WARNING, orange = IMPORTANT, purple = CLARIFICATION** (clarification boxes answer "why not just…?" questions). A teal primary + warm accent for headings is a safe palette.
- `tcolorbox` needs `\tcbuselibrary{skins}`; `xcolor` needs the **`table` option** (`\usepackage[table]{xcolor}` — plain xcolor has no `\rowcolors` for alternating table rows). Load `hyperref` last.
- **Copy the exact working preamble from `references/oreilly-style.md`** — the `attach boxed title` definitions and the part-banner format are fiddly and were debugged once already; do not improvise them from memory.
- TikZ (`\usetikzlibrary{arrows.meta, positioning}`) is in the bundle — draw stack/layer diagrams, handshakes, and box-and-arrow figures with it instead of ASCII art. Patterns live in the same reference file.

## Images in the PDF

- **XeTeX cannot include `.webp` (or `.gif`) images directly** — convert to PNG first: `magick in.webp -resize "1600>" -background white -flatten out.png` (flatten renders transparency on white; the resize keeps the PDF size sane).
- Embed as `\begin{figure}[H] \centering \includegraphics[width=0.8\linewidth]{...} \caption{...} \end{figure}` — the `float` package's `[H]` keeps figures where the text references them.
- **Caption from what the image actually shows**: look at the image (vision pass) before writing the caption; never invent captions for images you have not seen.
- Escape underscores in filenames inside captions: `\texttt{authorized\_keys}`.

## Visual QA before delivery

A compile that succeeds can still ship broken pages. Before declaring done:

1. `pdfinfo <input>.pdf | grep Pages` — sanity-check the page count.
2. `grep "^!" <input>.log` and `grep "Overfull" <input>.log` — zero errors; overfull boxes are fixable cosmetics.
3. Render sampled pages (`pdftoppm -png -r 60 -f N -l N <input>.pdf /tmp/pg`) and inspect them with a vision pass: title page, one figure-heavy page, one box-heavy page.
4. Cross-check any suspicious text with `pdftotext` — vision reads of small print misreport (a 60-dpi read of "Symmetric Key Exchange" once came back as "Diffie-Hellman Key Exchange"); the extracted text is ground truth.
5. After a font swap, `pdffonts <input>.pdf` — every family you loaded must appear in the list (plus math fonts).

## Troubleshooting

- **`! Undefined control sequence.` at `\rowcolors`** — xcolor needs the `table` option (see Visual design).
- **Boxes split across a page boundary** — tcolorbox `breakable` lets a box break mid-content across pages, which reads as a broken layout. Drop `breakable` so boxes are **atomic**: one that does not fit moves whole to the next page (the default LaTeX behavior, same as floats). Add `\raggedbottom` so leftover space collects at the page bottom instead of stretching gaps. Tables with `table[H]` never split; long `lstlisting` blocks can — wrap them in a `minipage` if one lands on a break.
- **`! LaTeX Error: Missing \begin{document}` pointing at a `\titleformat{\part}[display]` line** — the optional trailing `[after-code]` argument executes in the preamble and breaks the build; drop it (keep the top rule in the before-code) and use `\vskip` (not `\vspace`) inside `\titleformat` arguments.
- **Overfull `\hbox` warnings** — long inline `\texttt{...}`: wrap the paragraph in `sloppypar` (see Markdown→LaTeX pitfalls); hairline overfulls after a font swap: `\emergencystretch=2em` (see Fonts in `references/oreilly-style.md`).
- **`[default]` on `\usepackage{sourcesanspro}` makes the whole document sans** — put `[default]` on the serif package only (Fonts section of `references/oreilly-style.md`).
- **Fonts don't embed (or whole PDF falls back to one family)** — after a font swap, `pdffonts` must list every family you loaded (see Visual QA step 5 and the Fonts section of `references/oreilly-style.md`).
- **"the XeTeX engine had an unrecoverable error"** — this opaque message is the engine halting; the real cause is in the log. Recompile with `--keep-logs`, then read `<input>.log` and search for the first line starting with `!` (e.g. `! Undefined control sequence.`) plus the surrounding context — it shows the offending line. Fix that and recompile.
- **First run is slow / downloads** — normal; Tectonic downloads `tlextras` etc. once. `-C, --only-cached` uses only cached resources (useful offline).
- **Wrong output location** — single-file compile puts the PDF next to the input; project builds put it in `build/default/`. Check both before telling the user nothing was produced.
- **Warnings are normal** — overfull `\hbox` warnings, undefined-reference warnings on the first pass are cosmetic. Only `error:` lines matter.
- Verify the PDF exists (`ls -la *.pdf`) after compiling, and open it with `xdg-open`/`open` if the user wants a preview.
