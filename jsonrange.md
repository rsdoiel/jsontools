
# USAGE

    jsonrange [OPTIONS] JSON_EXPRESSION 

## SYSNOPSIS

jsonrange turns either the JSON expression that is a map or array into delimited
elements suitable for processing in a "for" style loop in Bash. If the
JSON expression is an array then the elements of the array are returned else
if the expression is a map/object then the keys or attribute names are turned.

+ EXPRESSION can be an empty string contains a JSON array or map.

```
    -d    set delimiter for range output
    -h    display help
    -l    display license
    -length    return the number of keys or values
    -limit    limit the number of items output
    -v    display version
```

## EXAMPLES

Working with a map

```
    jsonrange '{"name": "Doe, Jane", "email":"jane.doe@example.org", "age": 42}'
```

This would yield

```
    name
    email
    age
```

Working with an array

```
    jsonrange '["one", 2, {"label":"three","value":3]]'
```

would yield

```
    one
    2
    {"label":"three","value":3}
```

Checking the length of a map or array

```
    jsonrange -length '["one","two","three"]'
```
would yield

```
    3
```

Limitting the number of items returned

```
    jsonrange -limit 2 '[1,2,3,4,5]'
```

would yield

```
    1
    2
```

