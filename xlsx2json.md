
# USAGE

    xlsx2json [OPTIONS] EXCEL_FILENAME
 
## SYNOPSIS

xlsx2json reads an workbook .xlsx file and returns each row as a JSON object (or array of objects). If a JavaScript file and callback name are provided then that will be used to generate the resulting JSON content.

## JAVASCRIPT

The callback function in JavaScript should return an object that looks like

```
     {"path": ..., "source": ..., "error": ...}
```

The "path" property should contain the desired filename to use for storing
the JSON blob. If it is empty the output will only be displayed to standard out.

The "source" property should be the final version of the object you want to
turn into a JSON blob.

The "error" property is a string and if the string is not empty it will be
used as an error message and cause the processing to stop.

A simple JavaScript Examples:

```shell
    /* counter.js - Add column Counter saving i in the JSON output. */
    var i = 0;

    /* 
     * callback is the default name looked for when processing.
     *  the command line option -callback lets you used a different name.
     */
    function callback(row) {
        i += 1;
        if (i > 10) {
            /* Stop if processing more than 10 rows. */
            return {"error": "too many rows..."}
        }
        /* Add a counter column and save the current value of i */
        row.Counter = i
        return {
            "path": "data/" + i + ".json",
            "source": row,
            "error": ""
        }
    }
```


```
    -c    The name of the JavaScript function to use as a callback
    -callback    The name of the JavaScript function to use as a callback
    -h    display help
    -help    display help
    -i    Run with an interactive repl
    -interactive    Run with an interactive repl
    -j    JavaScript filename
    -js    JavaScript filename
    -l    display license
    -license    display license
    -s    Specify the number of the sheet to process
    -sheet    Specify the number of the sheet to process
    -v    display version
    -version    display version
```

## EXAMPLES

```
    xlsx2json myfile.xlsx

    xlsx2json counter.js myfile.xlsx

    xlsx2json -callback row2obj row2obj.js myfile.xlsx

    xlsx2json -i myfile.xlsx
```

