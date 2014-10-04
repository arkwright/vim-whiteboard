# Whiteboard

A scratch pad for experimenting with scripts within Vim.

## Why?

I want the full editing power of Vim while I experiment and iterate with a
small bit of code. I want the output of my experimental script to be piped
back into Vim.

## Installation

Use your plugin manager of choice.

If you are using [Pathogen](https://github.com/tpope/vim-pathogen):

    cd ~/.vim/bundle
    git clone https://github.com/arkwright/vim-whiteboard.git

It is **strongly recommended** that you configure the
`g:whiteboard_temp_directory` option (see _Configuration_ below), othewise
Whiteboard might throw an error if it cannot write to your system's temp
directory.

Tested in Vim 7.4 on OS X and Windows using MacVim/gvim.

## Usage

### :Whiteboard

The `:Whiteboard` command opens two splits, the Input Buffer and the Output
Buffer.

    +-----------------------------+
    |                |   Input    |
    |    Starting    |   Buffer   |
    |     Buffer     |------------|
    |                |   Output   |
    |                |   Buffer   |
    +-----------------------------+

The Input Buffer is saved in your system's `/tmp` directory. Write whatever
code you like within the Input Buffer and press `<CR>` to save the buffer and
pipe its contents to the appropriate script interpreter. After executing, the
script's output is displayed in the Output Buffer.

Execute the `:Whiteboard` command again to close all split windows and return
to the layout with which you began!

`:Whiteboard [interpreter]` can be used to invoke a Whiteboard with a specific
interpreter. For example, call `:Whiteboard javascript` to select a JavaScript
interpreter. `[interpreter]` can be either the interpreter's nickname, or its
file extension (e.g. `js`).

The following interpreters are supported out of the box, assuming you have the
appropriate {command} installed on your system:

* JavaScript {node} via `javascript` or `js`.
* Python {python} via `python` or `py`.
* Ruby {ruby} via `ruby` or `rb`.
* PHP {php} via `php`.

### :Whiteboard!

The `:Whiteboard!` command opens a Whiteboard and uses the current buffer as
the Input Buffer. The appropriate interpreter will automatically be selected
based on the starting buffer's file extension. You will end up with two
vertical splits, like this:

    +---------------------------+
    |              |            |
    |   Starting/  |   Output   |
    |   Input      |   Buffer   |
    |   Buffer     |            |
    |              |            |
    +---------------------------+

Calling `:Whiteboard! [interpreter]` on an unnamed buffer will cause that
buffer to be saved in your system's `/tmp` directory, with a filetype
appropriate for the selected interpreter. This enables the following workflow:

    :tabnew
    :Whiteboard! php

...and now you can start hacking on a simple PHP script!

## Configuration

Stick any of the following in your `.vimrc`. Default values are listed below.

You can change the name of the invocation command.

    :let g:whiteboard_command_name = 'Whiteboard'

You can set a default interpreter.

    :let g:whiteboard_default_interpreter = 'javascript'

You can change the default width of the Whiteboard buffers.

    :let g:whiteboard_buffer_width = 80

You can change the temporary directory location. This is the directory where
Whiteboard stores all of the Input Buffer files it creates. Out-of-the-box,
Whiteboard will attempt to detect your system's tempoary directory. However,
you will find it much more useful to manually specify where you want these
temporary files stored. Whiteboard does not delete the temporary files it
creates so that you may recover any code that you wrote and accidentally
discarded. **Don't forget to add a trailing slash!**

    :let g:whiteboard_temp_directory = '~/tmp/'

You can add your own custom interpreters by creating a dictionary of
dictionaries. These will be merged with the default interpreter configurations,
with _your settings taking precedence_. The first-level keys are interpreter
nicknames. All of the second-level keys are _required_. `extension` is the file
extension associated with this type of interpreter (e.g. `js` for a JavaScript
interpreter). `command` is the shell command to execute; the Input Buffer
contents will be saved as a file whose the path will be appended to `command`
and executed as a shell command to interpret the script.

    :let g:whiteboard_interpreters = {}
    :let g:whiteboard_interpreters.javascript = { 'extension': 'js', 'command': 'node' }

## Bugs

Probably lots.

Please open a Github issue if you notice something is amiss.

## Contributing

Pull requests, feature requests, ideas, bug reports, etc., are all welcome.

## Changelog

Uses [Semantic Versioning](http://semver.org/).

**0.3.0** (2014-10-3)

* Add `:Whiteboard!` variant, which uses the current buffer as the Input
  Buffer.
* Add Windows support.
* Add option to customize temporary directory location.
* Force input buffer split location to be left/above.

**0.2.0** (2014-10-1)

* Add four default interpreter configurations for JavaScript, Python, PHP, and
  Ruby.
* Add ability to customize interpreter configuration.
* Add ability to invoke specific interpreters via `:Whiteboard [interpreter]` command.
* Add user configuration options for default interpreter, and buffer width.

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
