-- Strings
yay.opt.aururl = "https://aur.archlinux.org" -- Base AUR URL.
yay.opt.aurrpcurl = "https://aur.archlinux.org/rpc?" -- AUR RPC endpoint URL; empty uses default endpoint.
yay.opt.build_dir = os.getenv("HOME") .. "/.cache/yay" -- Build/cache directory for AUR packages.
yay.opt.editor = os.getenv("EDITOR") or os.getenv("VISUAL") or "vi" -- Editor command used for PKGBUILD edits; empty uses VISUAL/EDITOR.
yay.opt.editor_flags = "" -- Extra flags passed to the editor command.
yay.opt.makepkg_bin = "makepkg" -- makepkg executable (name in PATH or absolute path).
yay.opt.makepkg_conf = "" -- makepkg.conf path; empty uses default makepkg config.
yay.opt.pacman_bin = "pacman" -- pacman executable.
yay.opt.pacman_conf = "/etc/pacman.conf" -- pacman.conf file path.
yay.opt.redownload = "no" -- PKGBUILD download mode: "no" | "yes" | "all".
yay.opt.git_bin = "git" -- git executable.
yay.opt.gpg_bin = "gpg" -- gpg executable.
yay.opt.gpg_flags = "" -- Extra flags passed to gpg.
yay.opt.mflags = "" -- Extra flags passed to makepkg.
yay.opt.sort_by = "" -- AUR search sort field: "votes" | "popularity" | "name" | "base" | "submitted" | "modified" | "".
yay.opt.search_by = "name-desc" -- AUR search field: "name" | "name-desc" | "maintainer" | "submitter" | "depends" | "makedepends" | "optdepends" | "checkdepends" | "provides" | "conflicts" | "replaces" | "groups" | "keywords" | "comaintainers".
yay.opt.git_flags = "" -- Extra flags passed to git.
yay.opt.remove_make = "ask" -- Remove makedepends mode: "no" | "yes" | "ask" | "askyes".
yay.opt.sudo_bin = "sudo" -- Privilege elevation command.
yay.opt.sudo_flags = "" -- Extra flags passed to the sudo command.
yay.opt.rebuild = "no" -- Build mode: "no" | "yes" | "tree" | "all".
-- yay.opt.answer_clean = "" --  yay v13.0.1+ Pre-select clean menu answer: "" | "All" | "None" | "Installed" | "NotInstalled" (also accepts menu syntax: ranges, ^n, "abort").
-- yay.opt.answer_diff = "" --  yay v13.0.1+ Pre-select diff menu answer: "" | "All" | "None" | "Installed" | "NotInstalled" (also accepts menu syntax: ranges, ^n, "abort").
-- yay.opt.answer_edit = "" --  yay v13.0.1+ Pre-select edit menu answer: "" | "All" | "None" | "Installed" | "NotInstalled" (also accepts menu syntax: ranges, ^n, "abort").

-- Integers
yay.opt.request_split_n = 150 -- Max packages per AUR RPC request (use values > 0).
yay.opt.completion_refresh_time = 7 -- Completion cache refresh days: -1 (never), 0 (always), >0 (every N days).
yay.opt.max_concurrent_downloads = 0 -- Parallel PKGBUILD source downloads; 0 uses CPU count.

-- Booleans
yay.opt.bottom_up = true -- Show AUR packages before repo packages in mixed results.
yay.opt.sudo_loop = false -- Keep sudo session alive in the background during long builds.
yay.opt.devel = false -- Check development/VCS packages on sysupgrade.
yay.opt.clean_after = false -- Remove untracked files after install.
yay.opt.keep_src = false -- Keep pkg/ and src/ after successful builds.
yay.opt.provides = true -- Resolve matching providers when dependencies are ambiguous.
yay.opt.pgp_fetch = true -- Prompt to import unknown PGP keys from validpgpkeys.
yay.opt.clean_menu = true -- Show pre-build clean menu.
yay.opt.diff_menu = true -- Show diff menu before building.
yay.opt.edit_menu = true -- Show PKGBUILD edit menu before building.
yay.opt.combined_upgrade = true -- Use combined repo+AUR upgrade flow on sysupgrade.
yay.opt.use_ask = false -- Use pacman's --ask to auto-confirm known conflicts.
yay.opt.batch_install = false -- Queue AUR package installs instead of installing each package immediately.
yay.opt.single_line_results = false -- Use single-line search result format.
yay.opt.separate_sources = true -- Separate query results by source (repo vs AUR).
yay.opt.debug = false -- Enable debug logging and local init.lua lookup convenience.
yay.opt.rpc = true -- Use AUR RPC for dependency/query operations.
yay.opt.double_confirm = true -- Ask for confirmation before and after builds during upgrades.

-- Hooks
-- Run Lua before yay prints the upgrade exclusion menu. Return package names
-- from event.data.upgrades to pre-exclude them. Set skip_menu = false, or omit
-- it, to show the native menu after these exclusions are applied.
--
yay.create_autocmd("UpgradeSelect", {
	desc = "skip recently modified AUR upgrades",
	callback = function(event)
		local exclude = {}
		local recent_cutoff = os.time() - (1 * 12 * 60 * 60)
		for _, pkg in ipairs(event.data.upgrades) do
			if pkg.repository == "aur" and pkg.last_modified >= recent_cutoff then
				yay.log.warn("pre-excluding recently modified AUR package:", pkg.name)
				table.insert(exclude, pkg.name)
			end
		end

		return { exclude = exclude, skip_menu = false }
	end,
})

-- Warn (without aborting) when a PKGBUILD contains patterns commonly seen in
-- malicious or compromised AUR packages: piping a remote download straight
-- into a shell, decoding/executing base64 blobs, curl|wget to non-standard
-- ports, or destructive filesystem commands. This is a heuristic, not a
-- guarantee -- always read PKGBUILDs yourself, especially with diff_menu/
-- edit_menu enabled above.
yay.create_autocmd("AURPreInstall", {
	desc = "warn on suspicious PKGBUILD patterns",
	callback = function(event)
		local suspicious_patterns = {
			{
				pattern = "curl[^\n]*|%s*sh",
				reason = "pipes a remote download directly into a shell (curl | sh)",
			},
			{
				pattern = "curl[^\n]*|%s*bash",
				reason = "pipes a remote download directly into a shell (curl | bash)",
			},
			{
				pattern = "wget[^\n]*|%s*sh",
				reason = "pipes a remote download directly into a shell (wget | sh)",
			},
			{
				pattern = "wget[^\n]*|%s*bash",
				reason = "pipes a remote download directly into a shell (wget | bash)",
			},
			{ pattern = "base64%s+%-%-?d", reason = "decodes a base64 blob (often used to hide payloads)" },
			{ pattern = "base64%s+%-D", reason = "decodes a base64 blob (often used to hide payloads)" },
			{
				pattern = "rm%s+%-rf%s+/[^%w]",
				reason = "contains a destructive recursive delete against root paths",
			},
			{
				pattern = "%f[%w]eval%f[%W]",
				reason = "uses eval, which can execute arbitrary obfuscated code",
			},
			{ pattern = "/dev/tcp/", reason = "opens a raw TCP connection (possible reverse shell)" },
			{ pattern = "nc%s+%-e", reason = "spawns netcat with -e (possible reverse shell)" },
		}

		local hits = {}
		for _, entry in ipairs(suspicious_patterns) do
			if event.data.pkgbuild:lower():match(entry.pattern:lower()) then
				table.insert(hits, entry.reason)
			end
		end

		if #hits > 0 then
			yay.log.warn(event.match .. ": PKGBUILD looks suspicious:")
			for _, reason in ipairs(hits) do
				yay.log.warn("  - " .. reason)
			end
			yay.log.warn("Review the PKGBUILD carefully before continuing (enable edit_menu/diff_menu above).")
		end
	end,
})
