# ShellGrammarGenerator



#####This shell script converts .yacc files into a parser friendly c file

#### Usage:

```
-i --input  (required), used to specify the grammar file (in yacc format). If not set, will display an error
-o --output (optional), if not set, grammar_converter will output into grammar.c and grammar.h files
-h --h      (help) Will display help
```

#### Examples:
```bash
sh grammar_converter.sh -i GRAMMAR_FILE -o OUTPUT_FILE
./ grammar_converter.sh
```

An exemple grammar.yacc file can be found [here](grammar.yacc.example)

#### Contributing

I'm far from being a shell/C expert and suspect there are many ways to improve this converter– if you have ideas on how to make the ShellGrammarConverter easier to maintain (and faster), don't hesitate to fork and send pull requests!

You can also take a look through the open issues and help where you can.