# Practical O'Reilly house style (condensed)

Source: <https://oreillymedia.github.io/production-resources/styleguide/>
A practical subset for study notes / self-published PDFs. It does not need to
align with O'Reilly completely — these are the rules that keep a technical
document consistent and book-like.

## Typography and font conventions

| Element | Rendering |
| --- | --- |
| Emphasis, filenames, paths, URLs, first use of a technical term | *Body font italic* |
| Code, commands, class names, attributes, keys, values, tags | Constant width |
| Placeholders in code (`login: <username>`) | *Constant width italic* |
| Commands the user must type | **Constant width bold** |
| SQL commands | CONSTANT WIDTH CAPS |
| Keyboard accelerators, menu titles | Body text, roman |
| Code text | Straight quotes in code; curly quotes in prose |

Emphasize with italics, never bold.

## Captions and cross references

- Sentence-case captions: "Figure 1-1. The TLS sandwich…" (hyphen between
  chapter and number, not en dash). No trailing period.
- Refer to each figure/table in the text *before* it appears: "see Figure 2-1",
  never "in the figure below" (placement differs between print and ebook).
- Table column heads and titles: sentence-case, no period.

## Headings

- No inline code, bold, or italics inside headings.
- Expand acronyms in headings (unless very well known).
- A/B-level headings: title case (capitalize first letter of each word except
  articles, short prepositions, conjunctions). C-level: sentence case.
- A heading must immediately precede body text — never an admonition/box or
  another heading with no text between.
- Hyphenated words in title case: cap both if the second word is a main word
  (Big-Endian), only the first otherwise (Built-in).

## Lists

- Items are sentence-capped and treated as separate items — no trailing
  "and" / "or" stitching.
- No periods after items unless one item is a complete sentence — then all
  items get periods.
- Nested bullets use em dashes as the bullet.
- A bullet list of "term: definition" entries should be a variable list
  (term italic/standalone, definition below it).

## Punctuation and numbers

- Serial comma (this, that, and the other).
- Em dashes closed up (no spaces). Ellipses closed.
- Commas and periods inside quotation marks.
- Footnote markers after punctuation.
- No period after a list item unless one item is a complete sentence.
- Spell out zero through nine, use numerals for 10+ and for actual values
  (5%, v5, $6.00). Use the % symbol with numerals, closed up: 0.05%.
- En dash (–) for minus/negative numbers; × for dimensions ("8.5 × 11");
  spaces around inline operators (1 + 1 = 2).
- K = 1,024; k = 1,000 (64 K of memory, 56 kbps modem).
- Expand acronyms on first use unless well known (API, AI, CLI, HTML, UI).

## Code

- Max code line length ≈ 76–85 chars (O'Reilly Animal/Trade series; 64 for
  Report 6x9). Keep code within the text margins.
- Indent with spaces, not tabs (4 spaces per level).
- Syntax highlighting with Pygments; color in web/ebook output, black and
  white in print.
- URLs and commands inside code stay straight-quoted and constant width.

## Links

- Anchor URLs to descriptive text ("navigate to the O'Reilly home page" +
  URL in parens), never to "here" / "this website".
- Long URLs get shortened (oreil.ly style) for print readability.

## Miscellaneous

- Authority order: book word list → Chicago Manual of Style (18th ed.) →
  Merriam-Webster. Be consistent (a.m. or A.M., data center or datacenter).
- Avoid "above"/"below" for figures; use live cross references.
- Avoid language that is unnecessarily gendered, violent, or exclusionary
  (man hours, kill, master/slave, blacklist) and color-word associations.
- AI chatbot exchanges: blockquote, with *Prompt:* in italics to separate
  speaker turns; keep AI output verbatim, state clearly what is AI-generated.
- Dates: 1980s or '80s; 32-bit integer; en dash for minus.
