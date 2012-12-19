# temporal-coupling

temporal-coupling is a small tool intended to explore how files are
coupled together. Instead of parsing and analyzing code statically,
it looks at what files are changed and committed together.

The premise is that files that change at the same time are coupled. In
certain cases, like a class and its unit tests, this coupling would
be expected and a good sign. In other cases, such as two seemingly
unrelated classes, the high amount of coupling could be a code smell.

# How to use

Checkout a copy of this repository, then execute the following:

```bash
./bin/temporal-coupling --repo $PWD --since 2012-01-01
```

This minimal invocation will provide statistics for this project
itself - you will likely want to specify a more interesting
repository. After it collects data, you will be shown a few pieces of
information:

1. Most modified files
2. Most modified pairs of files
3. Common pairs of the most modified files

## Ignoring uninteresting files

`--exclude-file REGEX` will allow you to ignore files that match a
Ruby regular expression. For example, in a Ruby application that uses
Bundler, you might not care about how often the dependencies change,
i.e. when `Gemfile` and `Gemfile.lock` are modified.

```bash
./bin/temporal-coupling --repo /path/to/ruby-app/.git --since 2012-01-01 --exclude-file '^Gemfile'
```

You can use `--exclude-file` multiple times in a single execution.
