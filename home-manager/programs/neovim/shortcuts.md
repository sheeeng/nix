# Neovim Keyboard Shortcuts

This document lists all the configured keyboard shortcuts in your Nix-managed Neovim setup.

## macOS Keyboard Symbols

- Fn (Function) 🌐 or Globe 🌐
- Control (or Ctrl) ⌃
- Option (or Alt) ⌥
- Shift ⇧
- Command (or Cmd) ⌘

## Global Configuration

- **Leader Key**: `Space` (configured as both `mapleader` and `maplocalleader`)

## File Management

### NvimTree (File Explorer)

| Shortcut | Action | Description |
|----------|--------|-------------|
| `⌃S` | Toggle NvimTree | Open/close the file tree explorer |

## Search and Navigation

### Telescope (Fuzzy Finder)

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Space SH` | Search Help | Search through help documentation |
| `Space SK` | Search Keymaps | Search through configured keymaps |
| `Space SF` | Search Files | Find files in the project |
| `Space SS` | Search Select | Select Telescope builtin commands |
| `Space SW` | Search Word | Search for the current word under cursor |
| `Space SG` | Search Grep | Live grep search |
| `Space SD` | Search Diagnostics | Search through LSP diagnostics |
| `Space SR` | Search Resume | Resume last search |
| `Space S.` | Search Recent | Search recently opened files |
| `Space Space` | Find Buffers | Find existing open buffers |

### Searchbox (Incremental Search)

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Space S` | Incremental Search | Start incremental search |

### Spectre (Search and Replace)

| Shortcut | Action | Mode | Description |
|----------|--------|------|-------------|
| `Space ⇧S` | Toggle Spectre | Normal | Open/close Spectre search and replace |
| `Space SW` | Search Word | Normal | Search current word under cursor |
| `Space SW` | Search Selection | Visual | Search currently selected text |
| `Space SP` | Search in File | Normal | Search within current file only |

## Code Completion (nvim-cmp)

### Insert Mode Mappings

| Shortcut | Action | Description |
|----------|--------|-------------|
| `⌃B` | Scroll Up | Scroll documentation up 4 lines |
| `⌃F` | Scroll Down | Scroll documentation down 4 lines |
| `⌃Space` | Complete | Trigger completion manually |
| `⌃E` | Abort | Close completion menu |
| `Enter` | Confirm | Accept selected completion item |

### Command Line Mappings

The completion system also provides mappings for command line mode:

- `/` and `?` search commands use buffer completion
- `:` command mode uses path and command completion

## Default Vim Shortcuts (Still Available)

Since this configuration doesn't override standard Vim shortcuts, all default Vim keybindings remain available, including:

### Basic Navigation

- `h`, `j`, `k`, `l` - Move left, down, up, right
- `w`, `b`, `e` - Word navigation
- `gg`, `G` - Go to top/bottom of file
- `0`, `$` - Go to beginning/end of line

### Editing

- `i`, `a`, `o` - Enter insert mode
- `dd`, `yy`, `p` - Delete/copy/paste lines
- `u`, `⌃R` - Undo/redo
- `.` - Repeat last command

### Visual Mode

- `v`, `⇧V`, `⌃V` - Enter visual, visual line, visual block mode

## Plugin-Specific Features

### Copilot

- Copilot is enabled for Git commit files
- Uses default Copilot keybindings (Tab to accept suggestions)

### Git Integration (Gitsigns)

- Uses default Gitsigns keybindings for Git hunks and navigation

### Visual Multi

- Multiple cursor support with default keybindings

## Notes

- Mouse support is disabled (`vim.opt.mouse = ""`)
- Clipboard integration is enabled with system clipboard
- Line numbers are displayed (both absolute and relative)
- Tab width is set to 2 spaces
- Smart case sensitivity is enabled for searches
