# pass-sclip

A [pass](https://www.passwordstore.org/) extension to copy to [`screen`](https://www.gnu.org/software/screen/)’s paste buffer.

## Installation

Put `sclip.bash` in either of `/usr/lib/password-store/extensions` (global installation) or `~/.password-store/.extensions` (local to your user). Make sure, that:

1. `sclip.bash` is executable, and
2. that you have `PASSWORD_STORE_ENABLE_EXTENSIONS=true` exported.

## Usage

Works exactly like `pass show --clip`, but puts the password in `screen`’s paste buffer. Example:

    $ pass sclip foo/bar
    Copied foo/bar to screen clipboard. Will clear in 45 seconds.
    
Now you can use the key combo `Ctrl-a ]` to paste the password into a screen window.

The `screen` paste buffer will be cleared after the same time that `pass show --clip` uses. Use `PASSWORD_STORE_CLIP_TIME` to controll it.
