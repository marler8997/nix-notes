Syntax
================================================================================

Read This:
https://nixos.wiki/wiki/Nix_Expression_Language

https://nixos.org/nixos/nix-pills/basics-of-language.html

### Nulls, Booleans Integers and Floating Points
```
null
> null
true
> true
false
> false
5
> 5
1.2
> 1.2
```
> Note that floating point precision is limited.

### Strings

Delimited with `double quotes` `"` or `double single quotes` `''`.  Strings can be "anti-quoted" using `${...}`.

### Identifier

An identifier is an "unquoted string" limited to the following regex:
```
[a-zA-Z_][a-zA-Z0-9_'-]*
```

Note that it supports dashes and single quotes, i.e.
```
nix-repl> a-b'c
error: undefined variable `a-b'c'
```

### Paths

* Regular Expression?
* Note that relative paths become absolute when evaluated.

Examples:
```
./hello/world
> /abs/path/to/hello/world
```
```
<nixpkgs/lib>
> /path/to/your/nixpkgs/lib
```

A path using `<path>` uses the `NIX_PATH` environment variable to find it, i.e.

```
$ nix-instantiate --eval -E '<ping>'
error: file `ping' was not found in the Nix search path (add it using $NIX_PATH or -I)
$ NIX_PATH=/bin nix-instantiate --eval -E '<ping>'
/bin/ping
$ nix-instantiate -I /bin --eval -E '<ping>'
/bin/ping
```

`NIX_PATH` functions like `PATH` where entries are separated by colons `:`, however, it also supports indiviual entries using `somename=somepath`.

```
$ NIX_PATH="ping=/bin/ping" nix-instantiate --eval -E '<ping>'
/bin/ping
```

It also matches more complex patters as you would expect:
```
$ NIX_PATH="root=/" nix-instantiate --eval -E '<root>'
/
$ NIX_PATH="root=/" nix-instantiate --eval -E '<root/bin>'
/bin
$ NIX_PATH="root/bin=/bin" nix-instantiate --eval -E '<root/bin>'
/bin
$ NIX_PATH="root/bin=/bin" nix-instantiate --eval -E '<root/bin/ping>'
/bin/ping
```

Note that if the path doesn't exist, it will print an error:
```
$ NIX_PATH="ping=/bin/missing" nix-instantiate --eval -E '<ping>'
error: file `ping' was not found in the Nix search path
```



### URI

```
http://example.org/foo.tar.bz2
```

### Lists

* Enclosed between square brackets
* Not separated by commas
* Can contain any type
```
[ 1 null "hello" http://foo.com ]
```

### Sets
```
{ <key> = <value> ; <key> = <value> ; ... }
```

A set of key-value pairs. (NOTE: I think that keys must be strings?)

* They support the dot `.` operator to access values.
```
{ a = 1; b = 2; }.a
> 1
```

`inherit <id1> <id2> ...;` is shorthand for `<id1> = <id1>; <id2> = <id2>; ...`

### If Expression
```
if <expression> then <true-expression> else <false-expression>
```

### Let Expression
```
let <var> = <value>; <var = <value>; ... in <expression>
```

Example:
```
nix-repl> let a = 3; b = 4; in a + b
7
```

### With Expression
```
with <attribute-set>; <expression>
```

Example:
```
nix-repl> longName = { a = 3; b = 4; }
nix-repl> longName.a + longName.b
7
nix-repl> with longName; a + b
7
```