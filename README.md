# ShellGrammarGenerator (SGG)



##### This shell script converts .yacc files into a parser friendly c file

#### Usage:

```
-i --input  (required), used to specify the grammar file (in yacc format). If not set, will display an error
-o --output (optional), if not set, grammar_converter will output into grammar.c and grammar.h files
-h --help   (help) Will display help
```

Everything before %% in the grammar file is configuration

#### Examples:

These two lines here are two ways to call the grammar converter
```bash
sh grammar_converter.sh -i <GRAMMAR_FILE> -o <OUTPUT_FILE>
./grammar_converter.sh --input <GRAMMAR_FILE> --output <OUTPOUT_FILE>
```

An exemple grammar.yacc file can be found [here](examples/grammar.yacc.example)

#### Contributing

I'm far from being a shell/C expert and suspect there are many ways to improve this converter– if you have ideas on how to make the ShellGrammarConverter easier to maintain (and faster), don't hesitate to fork and send pull requests!

You can also take a look through the open issues and help where you can.




















#### Writing a .yacc file for SGG

##### % Required:

Every % type needs to be spaced out by at least one \n (see example file)

No tab/whitespace before line

At least one
```bash
%token XXX
```
Which will tell the generator to replace this word with the template+token (see below for example)

One
```bash
%tokentemplate XXX
```

#tokentemplatepasobligatoire
Which will result in this :
```bash
%token WORD

%tokentemplate E_TOKEN_

//Given this:
XXX XXX XXX WORD XXX

//Will result in this:

XXX XXX XXX E_TOKEN_WORD XXX
```

One 
```bash
%fileincludename XXX
```
Which will give the name for the header file generated.

if you dont want any include in the .c file, just place this :

```bash
%include
```
Else, put the name of your header file like so:

```bash
%include stdio.h
%include myinclude.h
```

You need to specify the start of the program:
```bash
%start program
```

then you specify the end of the generator options by placing this:

```bash
%%
```

After this use the default yacc grammar (Posix)

