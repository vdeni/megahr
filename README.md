#  Lexical decision times for nouns from the Croatian Psycholinguistic Database

 <p xmlns:cc="http://creativecommons.org/ns#"
 xmlns:dct="http://purl.org/dc/terms/"><span property="dct:title">Code for
 "Lexical decision times for nouns from the Croatian Psycholinguistic
 Database"</span> by <span property="cc:attributionName">Denis Vlašiček</span>
 is licensed under <a
 href="https://creativecommons.org/licenses/by/4.0/?ref=chooser-v1"
 target="_blank" rel="license noopener noreferrer"
 style="display:inline-block;">CC BY 4.0<img
 style="height:22px!important;margin-left:3px;vertical-align:text-bottom;"
 src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"
 alt=""><img
 style="height:22px!important;margin-left:3px;vertical-align:text-bottom;"
 src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"
 alt=""></a></p>

This repository contains analysis code for the manuscript "Lexical decision
times for nouns from the Croatian Psycholinguistic Database".

Unfortunately, no Makefile is provided for the repository because I wasn't able
to make it play nicely with the version of Stan/`cmdstanr` that was being used.
The code wouldn't run when using `make` but worked completely fine when run
through the terminal.

The analyses reported here rely on
[this publicly available dataset](https://doi.org/10.23669/PEVB54).
