# NoteBrain CLI Flag Reference

This reference documents command-specific and global flags. Read this when you need precise default values, flag availability per command, or flag interactions that aren't covered in the main SKILL.md.

## Command-Specific Flags

These flags are available only on the commands listed.

### `search`

| Flag               | Purpose                                                                                        | Default |
| ------------------ | ---------------------------------------------------------------------------------------------- | ------- |
| `--limit N`        | Maximum total results to return.                                                               | `10`    |
| `--top-k N`        | Maximum chunks to retain **per note**. Prevents one long note from dominating results.         | `3`     |
| `--section "PATH"` | Filter results to chunks under a specific heading path (e.g., `"Architecture > Components"`).  | —       |
| `--tag "TagName"`  | Filter results to notes with this tag.                                                         | —       |
| `--has-tasks`      | Only return chunks containing task lists (checkboxes).                                         | off     |
| `--has-code`       | Only return chunks containing fenced code blocks.                                              | off     |
| `--with-pdf`       | Include PDF text extraction results in the search. Defaults to false (Markdown-only).        | `false` |

> Note: To execute multi-query search with multi-hit boosting, pass multiple positional query arguments: `notebrain search "query1" "query2"`.

### `hidden`

| Flag               | Purpose                                                                                                             | Default |
| ------------------ | ------------------------------------------------------------------------------------------------------------------- | ------- |
| `--limit N`        | Maximum number of hidden connections to return.                                                                     | `10`    |
| `--deep`           | Analyze each chunk individually for granular section-level matches using stored vectors (no re-embedding required). | `false` |
| `--top-k N`        | Chunks to evaluate per candidate note in `--deep` mode.                                                             | `3`     |
| `--include-linked` | Include notes that are already linked directly/indirectly, while still excluding self-references.                   | `false` |

### `connections`

| Flag       | Purpose                                                                                            | Default |
| ---------- | -------------------------------------------------------------------------------------------------- | ------- |
| `--hops N` | Breadth-first search traversal depth. Keep to 1–2 to avoid exponential blowup of returned results. | `2`     |

### `tags`

| Flag             | Purpose                                                                                                   | Default |
| ---------------- | --------------------------------------------------------------------------------------------------------- | ------- |
| `--shared`       | Treat the query as a note slug/title to find notes sharing its tags.                                      | `false` |
| `--children`     | Include child tags in hierarchical structure (e.g. searching 'kubernetes' also matches 'kubernetes/cka'). | `false` |
| `--min-shared N` | Minimum number of shared tags required to include a result (only applies when --shared is active).        | `1`     |

### `boosted`

| Flag            | Purpose                                                                                 | Default |
| --------------- | --------------------------------------------------------------------------------------- | ------- |
| `--seed STRING` | **Required.** Seed note (slug, title, or path) whose graph neighbors get a score boost. | —       |
| `--limit N`     | Maximum number of results.                                                              | `10`    |
| `--boost F`     | Score multiplier for graph-connected results (e.g., `1.5` = 50% boost over base score). | `1.5`   |
| `--with-pdf`    | Include PDF text extraction results in the search. Defaults to false (Markdown-only).   | `false` |

### `get`

No command-specific flags. Takes a single positional argument: `<slug>` (note slug, title, or file path — auto-resolved).

## Global Flags (Available on Subcommands)

These flags work on `search`, `backlinks`, `connections`, `hidden`, `tags`, `boosted`, `get`, and `stats`.

### Output Format & Extraction

| Flag               | Purpose                                                                                                                       | Default |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------------- | ------- |
| `--format FORMAT`  | Output format: `json` (structured envelope), `tsv` (tab-separated, no key names), `text` (standard text).                     | `text`  |
| `--show-file-path` | Include the `file_path` field in output (use `--show-file-path=false` to hide).                                               | `true`  |
| `--jsonpath PATH`  | Extract specific JSON elements using JSONPath (e.g., `"$.results[*].note_slug"`). Eliminates JSON envelope overhead entirely. | —       |
| `--include-text`   | Include the matched markdown text chunk in results. Omit during initial structure-mapping to save tokens.                     | off     |

### Search & Display Filtering

| Flag                 | Purpose                                                                                                                       | Default |
| -------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ------- |
| `--context-window N` | Fetch ±N adjacent chunks around each match into the `context` field. Use for lightweight surrounding context across results. | `0`     |
| `--min-score F`      | Suppress results below this similarity score (0.0–1.0).                                                                      | `0`     |
| `--show-tags`        | Include tag names (`#Tag/Subtag`) in CLI text and JSON outputs.                                                               | `false` |
| `--skip-phantom`     | Exclude uncreated notes (phantom wikilinks without a `.md` file on disk) from results.                                       | `true`  |

### Environment & Diagnostics

| Flag                  | Purpose                                        | Default                           |
| --------------------- | ---------------------------------------------- | --------------------------------- |
| `--chroma-path PATH`  | Path to ChromaDB persistent storage directory. | `~/.notebrain/chroma`             |
| `--vault-path PATH`   | Path to the Obsidian vault directory.          | (from config)                     |
| `--vault-name STRING` | Vault display name for Obsidian URI links.     | basename of `--vault-path`        |
| `--config PATH`       | Path to config file.                           | `~/.notebrain/config/config.toml` |
| `--debug`             | Enable debug-level logging to stderr.          | `false`                           |

> Hyperlink suppression: To disable OSC 8 terminal hyperlinks, set environment variable `NO_HYPERLINKS=1`.
