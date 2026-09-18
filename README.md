# atype

Type text into Android from your terminal with `adb shell input text`. It does not install or
switch to a custom input method (no ADBKeyboard APK required), so an AVD can keep
`hw.keyboard=no`.

## Requirements

- A connected Android device or running emulator (`adb devices`)
- Android SDK Platform Tools. On macOS, `atype` first checks
  `~/Library/Android/sdk/platform-tools/adb`, then `adb` on `PATH`.

## Install

### One command (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/komen205/atype/main/install.sh | bash
```

That drops `atype` into `~/.local/bin`, marks it executable, warns if that dir isn't on your
`PATH`, and checks for a running emulator. Override the target dir with
`ATYPE_BIN_DIR=/usr/local/bin`.

### Manual (clone and install)

```bash
# 1. Clone the repo
git clone https://github.com/komen205/atype.git

# 2. Install the script into a directory on your PATH
mkdir -p ~/.local/bin
install -m 755 atype/atype ~/.local/bin/atype

# 3. Ensure ~/.local/bin is on your PATH (add to ~/.zshrc or ~/.bashrc if missing)
export PATH="$HOME/.local/bin:$PATH"

# 4. Verify
atype "hello"
```

Or install a single file without cloning:

```bash
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/komen205/atype/main/atype -o ~/.local/bin/atype
chmod 755 ~/.local/bin/atype
```

## Usage

Type a string:

```bash
atype "hello@example.com"
```

Send a special key:

```bash
atype enter
atype tab
atype backspace
atype delete
atype escape
atype clear      # clears the focused text field
```

Interactive mode reads line by line, so you can fill a whole form:

```bash
$ atype
atype> user@example.com
atype> tab
atype> hunter2
atype> enter
atype> ^D
```

If `adb` is somewhere else, provide its path for a command:

```bash
ADB=/path/to/adb atype "hello"
```

## Notes

- Focus a text field in the emulator before running `atype`.
- The text is single-quoted before it reaches the device shell, so shell metacharacters
  like `$`, `` ` ``, `;`, and `&` are typed literally instead of being expanded on-device
  (e.g. `$$` no longer turns into a process id).
- Spaces are encoded as `%s` for `input text`, so a literal `%` next to a space can be
  ambiguous. Android may also discard characters its keymap doesn't support.
