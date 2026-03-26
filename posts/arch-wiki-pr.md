# Arch Wiki PR / Issue — Suggest Adding AI Tooling Resources

## Target: https://github.com/archlinux/archwiki/pulls

## PR Title:
docs: add AI assistant tooling resources for Arch-based distributions

## PR Body:

Hello Arch Wiki maintainers!

I'd like to suggest adding a section on AI assistant tooling for Arch-based distributions in the relevant wiki pages (e.g., "General recommendations" or a new "AI tooling" page).

## Suggested content:

```markdown
## AI Coding Assistants

AI coding assistants (Claude Code, OpenCode, Codex, Cursor) can be configured 
to use Arch-specific workflows on Arch-based distributions (Manjaro, EndeavourOS, etc.).

### Manjaro Skill

A skill that teaches AI assistants to prefer pacman/yay over generic package managers:

    npx skills add ankaboot-source/manjaro-skill

This ensures AI assistants use pacman (official repos) → yay (AUR) → 
pip/npm only in isolation, instead of defaulting to pip install -g, npm -g, snap, or brew.

Repository: https://github.com/ankaboot-source/manjaro-skill
```

## Rationale

Many Arch-based users rely on AI coding assistants and report that these tools default to wrong package managers (pip, npm, snap) instead of pacman/yay. Adding this to the wiki helps users configure their AI tooling correctly.

## Pages where this might fit:

- General recommendations
- Arch-based distributions (for Manjaro/EndeavourOS sections)
- A new "AI tooling" page

Happy to adjust the wording or placement based on wiki conventions. Let me know if you'd prefer an issue instead of a PR.
