# O'Reilly-style LaTeX preamble (verified with Tectonic 0.17)

Copy the parts you need. Everything here compiled cleanly in a real study
note (TLS first-principles guide, 2026-08): zero errors, zero overfull boxes.

## Fonts (O'Reilly-like, free)

O'Reilly's book typography is the commercial Thesis family — TheSerif (body),
TheSans (headings), TheSansMono (code) by Luc(as) de Groot; some books use
ScalaPro or Le Monde Livre. The closest free analogues, verified to compile and
embed in tectonic, are Adobe's Source families:

```latex
\usepackage[default]{sourceserifpro}   % body text  ~ TheSerif
\usepackage{sourcesanspro}             % headings    ~ TheSans (use \sffamily)
\usepackage{sourcecodepro}             % code        ~ TheSansMono
\usepackage[font=small, labelfont=bf, labelsep=period]{caption}  % "Figure 2-1." style
\counterwithin{figure}{section}       % O'Reilly-style chapter-figure numbering
\counterwithin{table}{section}
\renewcommand{\thefigure}{\thesection-\arabic{figure}}   % hyphen, not dot: 2-1
\renewcommand{\thetable}{\thesection-\arabic{table}}
\emergencystretch=2em                  % hairline overfulls after font swaps
```

- Put `[default]` **only** on the serif package — `[default]` on
  `sourcesanspro` makes sans the document-wide default.
- Headings switch to the sans family via `\sffamily` inside `\titleformat`
  arguments.
- TikZ diagram labels: `font=\footnotesize` (one step below body) keeps
  diagrams compact; captions at `small` via the caption package.
- Verify embedding after compiling: `pdffonts out.pdf` must list
  SourceSerifPro / SourceSansPro / SourceCodePro (plus math fonts), not
  fallbacks.
- Wider fonts can introduce new overfull lines — `\emergencystretch=2em`
  absorbs hairline overfulls without touching the rest of the layout.

See also `references/oreilly-house-style.md` for practical rules from the
O'Reilly style guide (captions, lists, punctuation, code conventions).

## Minimal usage

```latex
\documentclass[11pt]{article}
\usepackage[margin=1in]{geometry}
% ---- paste the sections below between packages and \begin{document} ----
\title{...}
\author{...}
\date{\today}
\begin{document}
\maketitle
\tableofcontents
\newpage

% callout box:
\begin{warnbox}
Without TLS, an attacker on-path can read a raw HTTP request...
\end{warnbox}

% colored table with alternating rows:
\begin{table}[H]
\centering
\rowcolors{2}{mainteal!4}{white}
\begin{tabularx}{\linewidth}{l X X X}
\hline
\textbf{A} & \textbf{B} & \textbf{C} \\
\hline
...
\end{tabularx}
\end{table}

% colored status text in tables:
\textcolor{tipgreen}{Secure} / \textcolor{warnred}{Obsolete} / \textcolor{amber}{Deprecated}

% TikZ figure:
\begin{figure}[H]
\centering
\begin{tikzpicture}[>=Stealth, font=\footnotesize]
... (see patterns below)
\end{tikzpicture}
\caption{...}
\end{figure}
\end{document}
```

## Packages (order matters)

```latex
\usepackage[table]{xcolor}            % table option REQUIRED for \rowcolors
\usepackage{parskip}                  % paragraph spacing instead of indentation
\raggedbottom                         % collect whitespace at page bottoms when blocks move whole
\usepackage{graphicx}
\usepackage{float}                    % [H] keeps figures exactly where referenced
\usepackage{tabularx}
\usepackage{listings}
\usepackage{titlesec}
\usepackage{fancyhdr}
\usepackage{tcolorbox}
\tcbuselibrary{skins}
\usepackage{tikz}
\usetikzlibrary{arrows.meta, positioning}
\usepackage[colorlinks=true, linkcolor=mainteal, urlcolor=noteblue]{hyperref}  % last
```

Tables stay on one page automatically: `table[H]` (float package) never splits — an
unfitting table moves whole. Same principle as the boxes: if content must not break
across pages, make it one atomic block (float, minipage, or non-breakable tcolorbox).

## Palette

```latex
\definecolor{mainteal}{HTML}{14606E}   % headings, rules, primary
\definecolor{accent}{HTML}{C7501E}     % warm accent (sparingly)
\definecolor{tipgreen}{HTML}{2E7D32}   % TIP
\definecolor{noteblue}{HTML}{1565C0}   % NOTE
\definecolor{warnred}{HTML}{C62828}    % WARNING
\definecolor{amber}{HTML}{E65100}      % IMPORTANT
\definecolor{clarify}{HTML}{6A1B9A}    % CLARIFICATION
```

## Colored headings

```latex
\titleformat{\section}{\Large\bfseries\color{mainteal}}{\thesection}{0.6em}{}
\titleformat{\subsection}{\large\bfseries\color{mainteal!85!black}}{\thesubsection}{0.6em}{}
\titleformat{\subsubsection}{\normalsize\bfseries\color{mainteal!70!black}}{\thesubsubsection}{0.6em}{}
```

Part banner — **no trailing `[after-code]` bracket**: the optional last argument of
`\titleformat` executes in the preamble and fails with `! LaTeX Error: Missing
\begin{document}.` Keep the top rule in the before-code instead, and use `\vskip`
(never `\vspace`) inside titleformat arguments.

```latex
\titleformat{\part}[display]
  {\normalfont\Huge\bfseries\color{mainteal}}
  {\filleft\Large Part \thepart}
  {0.6ex}
  {\titlerule[2pt]\vskip 1.2ex}
\titlespacing{\part}{0pt}{2em}{2.5em}
```

## Header / footer with colored rule

```latex
\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\small\textit{\textcolor{mainteal}{<document title>}}}
\fancyhead[R]{\small\textit{\textcolor{mainteal}{<series name>}}}
\fancyfoot[C]{\thepage}
\renewcommand{\headrulewidth}{0.8pt}
\renewcommand{\headrule}{\color{mainteal}\hrule width\headwidth height\headrulewidth}
```

## Callout boxes (TIP / NOTE / WARNING / IMPORTANT / CLARIFICATION)

All five share one shape: light fill, thin frame, thick colored left bar, and an
attached label tag at the top-left. Define each with its own color and label.

**Do not use `breakable`** — it lets tcolorbox split a box mid-content across a page
break, which reads as a broken layout. Without it each box is atomic: if it does not
fit, it moves whole to the next page (the default LaTeX behavior, same as floats and
minipages). Pair with `\raggedbottom` so the leftover space collects at the page
bottom instead of stretching inter-paragraph gaps.

```latex
\newtcolorbox{tipbox}{enhanced,
  colback=tipgreen!5!white, colframe=tipgreen!70!black,
  boxrule=0.4pt, leftrule=3pt, arc=1mm,
  before skip=10pt, after skip=10pt,
  attach boxed title to top left={yshift=-2.4mm, xshift=3mm},
  boxed title style={colback=tipgreen!70!black, colframe=tipgreen!70!black,
    boxrule=0pt, arc=1mm, top=1mm, bottom=1mm, left=2.5mm, right=2.5mm},
  title={\small TIP}, fonttitle=\bfseries\small}

\newtcolorbox{notebox}{enhanced,
  colback=noteblue!5!white, colframe=noteblue!80!black,
  boxrule=0.4pt, leftrule=3pt, arc=1mm,
  before skip=10pt, after skip=10pt,
  attach boxed title to top left={yshift=-2.4mm, xshift=3mm},
  boxed title style={colback=noteblue!80!black, colframe=noteblue!80!black,
    boxrule=0pt, arc=1mm, top=1mm, bottom=1mm, left=2.5mm, right=2.5mm},
  title={\small NOTE}, fonttitle=\bfseries\small}

\newtcolorbox{warnbox}{enhanced,
  colback=warnred!5!white, colframe=warnred!80!black,
  boxrule=0.4pt, leftrule=3pt, arc=1mm,
  before skip=10pt, after skip=10pt,
  attach boxed title to top left={yshift=-2.4mm, xshift=3mm},
  boxed title style={colback=warnred!80!black, colframe=warnred!80!black,
    boxrule=0pt, arc=1mm, top=1mm, bottom=1mm, left=2.5mm, right=2.5mm},
  title={\small WARNING}, fonttitle=\bfseries\small}

\newtcolorbox{impbox}{enhanced,
  colback=amber!5!white, colframe=amber!85!black,
  boxrule=0.4pt, leftrule=3pt, arc=1mm,
  before skip=10pt, after skip=10pt,
  attach boxed title to top left={yshift=-2.4mm, xshift=3mm},
  boxed title style={colback=amber!85!black, colframe=amber!85!black,
    boxrule=0pt, arc=1mm, top=1mm, bottom=1mm, left=2.5mm, right=2.5mm},
  title={\small IMPORTANT}, fonttitle=\bfseries\small}

\newtcolorbox{clarifybox}{enhanced,
  colback=clarify!5!white, colframe=clarify!75!black,
  boxrule=0.4pt, leftrule=3pt, arc=1mm,
  before skip=10pt, after skip=10pt,
  attach boxed title to top left={yshift=-2.4mm, xshift=3mm},
  boxed title style={colback=clarify!75!black, colframe=clarify!75!black,
    boxrule=0pt, arc=1mm, top=1mm, bottom=1mm, left=2.5mm, right=2.5mm},
  title={\small CLARIFICATION}, fonttitle=\bfseries\small}
```

Usage: `\begin{tipbox} ... \end{tipbox}` — a bold lead-in sentence inside the box
(e.g. `\textbf{Cipher suite.}`) reads well. Boxes can contain itemize/enumerate.

## Listings style

```latex
\lstset{
  basicstyle=\ttfamily\small,
  breaklines=true,           % long openssl / kubectl lines wrap instead of overflowing
  columns=fullflexible,
  keepspaces=true,
  frame=single,
  framerule=0.4pt,
  rulecolor=\color{mainteal!60},
  backgroundcolor=\color{mainteal!4},
  xleftmargin=1em, xrightmargin=1em,
  aboveskip=1em, belowskip=1em,
}
```

No escaping inside `lstlisting` (`#`, `_`, `%`, `->`, braces are all literal).
Use `[language=bash]` for shell commands; leave plain for config/YAML-like blocks
(listings has no YAML mode).

## TikZ patterns

Load `\usetikzlibrary{arrows.meta, positioning}`. `[>=Stealth]` gives clean arrowheads.

### Stack / layer diagram (e.g. protocol stack)

```latex
\begin{tikzpicture}[font=\footnotesize]
\tikzset{layer/.style={rectangle, draw=gray!60, minimum width=7.5cm, minimum height=0.85cm, font=\footnotesize}}
\node[layer, fill=purple!12] (app) {Application --- HTTP, IMAP, \ldots};
\node[layer, fill=mainteal!22, below=0pt of app] (tls) {\textbf{TLS} --- encryption, authentication, integrity};
\node[layer, fill=noteblue!10, below=0pt of tls] (tcp) {TCP --- reliable, ordered transport};
\node[layer, fill=gray!12, below=0pt of tcp] (ip) {IP --- addressing \& routing};
\node[layer, fill=gray!7, below=0pt of ip] (link) {Link --- physical transmission};
\end{tikzpicture}
```

Highlight the layer the document is about (`fill=mainteal!22` + bold) so the eye
lands on it.

### Client-server handshake (arrows with labels)

```latex
\begin{tikzpicture}[>=Stealth, font=\footnotesize]
\node[draw, rounded corners, fill=noteblue!8!white, minimum width=2.6cm, minimum height=1cm] (c) {Client};
\node[draw, rounded corners, fill=tipgreen!8!white, minimum width=2.6cm, minimum height=1cm, right=5.2cm of c] (s) {Server};
\draw[->, thick, mainteal] ([yshift=7mm]c.east) -- node[above] {1.\ SYN, seq=x} ([yshift=7mm]s.west);
\draw[<-, thick, mainteal] ([yshift=0mm]c.east) -- node[above] {2.\ SYN+ACK} ([yshift=0mm]s.west);
\draw[->, thick, mainteal] ([yshift=-7mm]c.east) -- node[below] {3.\ ACK} ([yshift=-7mm]s.west);
\end{tikzpicture}
```

Offset the endpoints with `[yshift=±7mm]` to stack the three message lines; `<-`
draws the arrow pointing back to the client. Keep labels short or they collide with
the boxes at 60 dpi QA.

### Boxes containing stacked inner nodes (e.g. pod with sidecar)

```latex
\begin{tikzpicture}[>=Stealth, font=\footnotesize]
\node[draw, rounded corners, fill=noteblue!8!white, minimum width=4.4cm, minimum height=3cm] (poda) {\textbf{Pod A}};
\node[draw, rounded corners, fill=tipgreen!8!white, minimum width=4.4cm, minimum height=3cm, right=4.2cm of poda] (podb) {\textbf{Pod B}};
\node[draw, fill=white, minimum width=3.6cm, minimum height=0.85cm] (appa) at ([yshift=6mm]poda.center) {App Container};
\node[draw, fill=mainteal!15!white, minimum width=3.6cm, minimum height=0.85cm] (sa) at ([yshift=-6mm]poda.center) {Sidecar};
\node[draw, fill=white, minimum width=3.6cm, minimum height=0.85cm] (appb) at ([yshift=6mm]podb.center) {App Container};
\node[draw, fill=mainteal!15!white, minimum width=3.6cm, minimum height=0.85cm] (sb) at ([yshift=-6mm]podb.center) {Sidecar};
\draw[->, gray] (appa.south) -- node[right=1mm, font=\scriptsize] {plaintext} (sa.north);
\draw[<->, thick, mainteal] (sa.east) -- node[above, font=\small] {\textbf{mTLS}} (sb.west);
\draw[->, gray] (sb.north) -- node[left=1mm, font=\scriptsize] {plaintext} (appb.south);
\end{tikzpicture}
```

Position inner nodes relative to the container with `at ([yshift=±6mm]poda.center)`
so the container's own label (`\textbf{Pod A}`) stays centered between them.

## Source of truth

This preamble is the verified reference for the "Visual design" and "Images in the
PDF" sections of SKILL.md. If a future session fixes a bug in any snippet, fix it
here first, then re-verify with a compile.
