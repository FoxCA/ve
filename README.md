# Pantheon ve
ve is a Text Editor utility that can read files according to the P/File:1 standard.
## Usage
`ve [-w <break-limit>] <file>`
## Modes
ve, similarly to vi and vim, has modes. The default mode is normal mode. There are also visual and insert modes.
### Normal mode
In normal mode, keys can perform several actions. You cannot insert characters in this mode, but you can edit the file via Verbs and Commands.
You can type in a command by pressing `:`.
### Insert mode
You can access this mode by pressing `i` in Normal mode. In this mode, all keys will be typed into the file. You can return into normal mode by pressing the Escape key.
### Visual mode
In visual mode, that can be accessed by pressing `v` in Normal mode, you can highlight words, copy, cut and paste, and select text.
## Verbs
A ve Verb is a command that is not preceded by `:`. Verbs take ve Objects, that define positions in the text. An example would be the `d` Verb, that means delete. The verb alone doesn't delete anything, but combined with a line Object, you can delete a whole line.
### List of ve Verbs
#### `a`
Undo.
#### `Number+c`
Move to tab number.
#### `d+Object`
Takes an object and deletes/cuts it.
#### `Number+g`
Goes to a line number.
#### `i`
Goes into Insert mode.
#### `m+Mark`
Marks a position in a mark register.
#### `o`
Pastes the cut clipboard contents.
#### `p`
Pastes the copy clipboard contents.
#### `q+Macro`
Records a macro and stores it.
#### `r+Character`
Replaces the character in the current position with another.
#### `s`
Redo.
#### `Number+t`
Opens a tab number.
#### `v`
Goes into Visual mode.
#### `x`
Goes to the next result of a search.
#### `y+Object`
Takes the object and copies it.
#### `z`
Goes to the previous result of a search.
#### `J`
Join the line on which the cursor is with the line below.
#### `Q+Macro`
Runs a macro.
#### Objects
Pressing an object alone will take you to the position. For example, using the `-` line Object will take you to the start of the line and such.
## Visual Verbs
### List of ve Visual Verbs
#### `c`
Copy selected text.
#### `d`
Delete selected text.
#### `s[+Mark|+Object]`
Selects from the current cursor position to a Mark or Object.
#### `x`
Cut selected text.
#### `D`
Deselects all text
#### `S+Register`
Stores selected text into register.
## Objects
An object is the argument to a ve Verb.
### List of ve Objects
#### `e`
Jump forwards to the end of a word.
#### `h`
Character at the left of the cursor.
#### `j`
Character below the cursor, or last character of the line below if the line is shorter.
#### `k`
Character above the cursor, or last character of the line above if the line is shorter.
#### `l`
Character at the right of the cursor.
#### `w`
Jump forward to the start of a word.
#### `E`
Jump backwards to the end of a word.
#### `F`
End of the document. Footer.
#### `H`
Start of the document. Header.
#### `W`
Jump backwards to the start of a word.
#### `.`
Whole word.
#### `-` or repeated Verb
Whole line.
#### `'+Mark`
Mark register
#### `"+Register`
Register
##### Special registers
`"c` - Visual clipboard
`"x` - Cut clipboard
#### `{`
Start of paragraph.
#### `}`
End of paragraph.
#### `1`
Start of line.
#### `2`
End of line.
## Commands
Commands are preceeded by `:`, `/` or `?`
### List of ve Commands
#### `/pattern`
Searches forward for a pattern.
#### `?pattern`
Searches backwards for a pattern.
#### `:r+Literal+Literal`
Replaces a string globally.
#### `:rp+Pattern+ReplacePattern`
Replaces a pattern globally.
#### `:w`
Writes the file
#### `:q[a]`
Quits the current tab, if all tabs are closed, quits ve. To close all tabs, use the a suffix.
#### `:/+Literal`
Executes a string as Lua.
## Literals
Literals are enclosed in parentheses. They represent a string.
## Patterns
Patterns are enclosed in `/`s. They represent a Lua pattern.
## ReplacePatterns
ReplacePatterns are enclosed in `#`s. They represent a Lua replace pattern.
## Marks
There are 26 mark registers, one for each letter of the alphabet. They store file positions and they can be accessed with `'x`.
## Registers
There are 26 registers as well, they store Literals. They can be accessed with `"x`.
##### Special registers
`"c` - Visual/copy clipboard
`"x` - Cut clipboard
