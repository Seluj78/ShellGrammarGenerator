# ShellGrammarGenerator


```yacc
%token  WORD
%token  NEWLINE
%token  IO_NUMBER
%token  DLESS  DGREAT  LESSAND  GREATAND  LESSGREAT
%start  program
%%
program          : linebreak complete_commands linebreak
| linebreak
;
complete_commands: complete_commands newline_list complete_command
|                                complete_command
;
complete_command : list separator_op
| list
;
list             : list separator_op and_or
|                   and_or
;
and_or           : pipeline
;
pipeline         : pipe_sequence
;
pipe_sequence    :                             command
| pipe_sequence '|' linebreak command
;
command          : simple_command
;
simple_command   : cmd_prefix cmd_word cmd_suffix
| cmd_prefix cmd_word
| cmd_prefix
| cmd_name cmd_suffix
| cmd_name
;
cmd_name         : WORD
;
cmd_word         : WORD
;
cmd_prefix       :            io_redirect
| cmd_prefix io_redirect
;
cmd_suffix       :            io_redirect
| cmd_suffix io_redirect
|            WORD
| cmd_suffix WORD
;
io_redirect      :           io_file
| IO_NUMBER io_file
|           io_here
| IO_NUMBER io_here
;
io_file          : '<'       filename
| LESSAND   filename
| '>'       filename
| GREATAND  filename
| DGREAT    filename
| LESSGREAT filename
;
filename         : WORD
;
io_here          : DLESS     here_end
;
here_end         : WORD
;
newline_list     :              NEWLINE
| newline_list NEWLINE
;
linebreak        : newline_list
| /* empty */
;
separator_op     : ';'
;
separator        : separator_op linebreak
| newline_list
;
sequential_sep   : ';' linebreak
| newline_list
;
```
