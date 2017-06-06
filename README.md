#ShellGrammarGenerator (SGG for short)

###This script converts a yacc file into a 3D array and a header file for a modular C parser

####SGG Usage example:

[![asciicast](https://asciinema.org/a/65nymkq3pw2n61v354kz2ezo6.png)](https://asciinema.org/a/65nymkq3pw2n61v354kz2ezo6)

#### Usage:

```bash
-i --input  (required), used to specify the grammar file (in yacc format). If not set, will display an error
-o --output (optional), if not set, grammar_converter will output into grammar.c and grammar.h files
-h --help   (help) Will display help
```


#### Examples:
These two lines here are two ways to call the grammar converter
```bash
bash ShellGrammarGenerator.sh -i <GRAMMAR_FILE> -o <OUTPUT_FILE>
./ShellGrammarGenerator.sh --input <GRAMMAR_FILE> --output <OUTPOUT_FILE>
```

A grammar.yacc example file can be found [here](examples/grammar.yacc.example)

#### Writing a .yacc file for SGG

##### % Required:

Every % is on its own line. Example:
```bash
%token XXX
%token YYY
```
Is correct

```bash
%token XXX YYY
%token XXX %token YYY
```
Isn't correct

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

