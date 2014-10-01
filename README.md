# Whiteboard

A scratch pad for experimenting with scripts within Vim.

## Why?

I want the full editing power of Vim while I experiment and iterate with a
small bit of code. I want all of this to occur inside Vim, for convenience and
comfort.

## Installation

Use your plugin manager of choice.

If you are using [Pathogen](https://github.com/tpope/vim-pathogen):

    cd ~/.vim/bundle
    git clone https://github.com/arkwright/vim-whiteboard.git

Only tested in Vim 7.4 on OS X using MacVim.

**This plugin is very much a prototype. Your mileage may vary!**

## Usage

The `:Whiteboard` command opens two splits, the Input Buffer and the Output
Buffer.

    +-----------------------------+
    |                |   Output   |
    |    Starting    |   Buffer   |
    |     Buffer     |------------|
    |                |   Input    |
    |                |   Buffer   |
    +-----------------------------+

The Input Buffer is saved in your system's `/tmp` directory. Write whatever
code you like within the Input Buffer and press `<CR>` to save the buffer and
pipe its contents to the appropriate script interpreter. In the case of
JavaScript, the `node` executable is used. After executing, the script's output
is displayed in the Output Buffer.

Execute the `:Whiteboard` command again to close all split windows and return
to the layout with which you began!

## Configuration

You can change the name of the invocation command like so:

    :let g:whiteboard_command_name = 'Repl'

## Bugs

Probably lots.

Please open a Github issue if you notice something is amiss.

## Contributing

Pull requests, feature requests, ideas, bug reports, etc., are all welcome.

## Changelog

Uses [Semantic Versioning](http://semver.org/).

**0.1.0** (2014-09-30)

* Initial prototype. Add `:Whiteboard` command.

## Credits

Whiteboard is lovingly crafted by [Robert
Arkwright](https://github.com/arkwright).

This plugin would not have been possible without Steve Losh's incredible book:
[Learn Vimscript the Hard
Way](http://learnvimscriptthehardway.stevelosh.com/).

## License

[Unlicense](http://unlicense.org/)
