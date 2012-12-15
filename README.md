# temporal-coupling

temporal-coupling is a small tool intended to explore how files are
coupled together. Instead of parsing and analyzing code statically,
it looks at what files are changed and committed together.

The premise is that files that change at the same time are coupled. In
certain cases, like a class and it's unit tests, this coupling would
be expected and a good sign. In other cases, such as two seemingly
unrelated classes, the high amount of coupling could be a code smell.

# How to use

Checkout a copy of this repository, then execute the following:

```bash
./bin/temporal-coupling --repo .git --since 2012-01-01
```

This minimal invocation will provide statistics for this project
itself - you will likely want to specify a more interesting
repository. After it collects data, you will be shown a few pieces of
information:

1. Most modified files
2. Most modified pairs of files
3. Common pairs of the most modified files
