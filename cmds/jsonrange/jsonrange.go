//
// jsonrange iterates over an array or map returning either a JSON expression
// or map keep to stdout
//
package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"path"
	"strings"

	// my packages
	"github.com/rsdoiel/cli"
	"github.com/rsdoiel/jsontools"
)

var (
	usage = `USAGE: %s [OPTIONS] JSON_EXPRESSION `

	description = `
SYSNOPSIS

%s turns either the JSON expression that is a map or array into delimited
elements suitable for processing in a "for" style loop in Bash. If the
JSON expression is an array then the elements of the array are returned else
if the expression is a map/object then the keys or attribute names are turned.

+ EXPRESSION can be an empty string contains a JSON array or map.
`

	examples = `
EXAMPLES

Working with a map

    %s '{"name": "Doe, Jane", "email":"jane.doe@example.org", "age": 42}'

This would yield

    name
	email
	age

Working with an array

    %s '["one", 2, {"label":"three","value":3]]'

would yield

    one
	2
	{"label":"three","value":3}

Checking the length of a map or array

    %s -length '["one","two","three"]'

would yield

    3

Limitting the number of items returned

    %s -limit 2 '[1,2,3,4,5]'

would yield

    1
	2
`

	// Basic Options
	showHelp    bool
	showLicense bool
	showVersion bool

	// Application Specific Options
	showLength bool
	delimiter  = "\n"
	limit      int
)

func srcKeys(inSrc string, limit int) ([]string, error) {
	data := map[string]interface{}{}
	if err := json.Unmarshal([]byte(inSrc), &data); err != nil {
		return nil, err
	}
	result := []string{}
	i := 0
	for keys := range data {
		result = append(result, keys)
		if limit > 0 && i == limit {
			return result, nil
		}
		i++
	}
	return result, nil
}

func srcVals(inSrc string, limit int) ([]string, error) {
	data := []interface{}{}
	if err := json.Unmarshal([]byte(inSrc), &data); err != nil {
		return nil, err
	}
	result := []string{}
	for i, val := range data {
		outSrc, err := json.Marshal(val)
		if err != nil {
			return nil, err
		}
		result = append(result, fmt.Sprintf("%s", outSrc))
		if limit != 0 && i == limit {
			return result, nil
		}
	}
	return result, nil
}

func init() {
	// Standard Options
	flag.BoolVar(&showHelp, "h", false, "display help")
	flag.BoolVar(&showLicense, "l", false, "display license")
	flag.BoolVar(&showVersion, "v", false, "display version")

	// Application Options
	flag.BoolVar(&showLength, "length", false, "return the number of keys or values")
	flag.StringVar(&delimiter, "d", "\n", "set delimiter for range output")
	flag.IntVar(&limit, "limit", 0, "limit the number of items output")
}

func getLength(inSrc string) (int, error) {
	if strings.HasPrefix(inSrc, "{") {
		data := map[string]interface{}{}
		if err := json.Unmarshal([]byte(inSrc), &data); err != nil {
			return 0, err
		}
		return len(data), nil
	}
	data := []interface{}{}
	if err := json.Unmarshal([]byte(inSrc), &data); err != nil {
		return 0, err
	}
	return len(data), nil
}

func main() {
	appName := path.Base(os.Args[0])
	flag.Parse()

	args := flag.Args()

	// Configuration and command line interation
	cfg := cli.New(appName, "JSONTOOLS", fmt.Sprintf(jsontools.LicenseText, appName, jsontools.Version), jsontools.Version)
	cfg.UsageText = fmt.Sprintf(usage, appName)
	cfg.DescriptionText = fmt.Sprintf(description, appName)
	cfg.ExampleText = fmt.Sprintf(examples, appName, appName)

	if showHelp == true {
		fmt.Println(cfg.Usage())
		os.Exit(0)
	}

	if showLicense == true {
		fmt.Println(cfg.License())
		os.Exit(0)
	}

	if showVersion == true {
		fmt.Println(cfg.Version())
	}

	if len(args) != 1 {
		fmt.Println(cfg.Usage())
	}

	// OK, let's see what keys/values we're going to output...
	src := args[0]
	switch {
	case showLength:
		l, err := getLength(src)
		if err != nil {
			fmt.Fprintf(os.Stderr, "%s", err)
			os.Exit(1)
		}
		fmt.Printf("%d", l)
	case strings.HasPrefix(src, "{"):
		elems, err := srcKeys(src, limit-1)
		if err != nil {
			fmt.Fprintf(os.Stderr, "%s", err)
			os.Exit(1)
		}
		fmt.Println(strings.Join(elems, delimiter))
	case strings.HasPrefix(src, "["):
		elems, err := srcVals(src, limit-1)
		if err != nil {
			fmt.Fprintf(os.Stderr, "%s", err)
			os.Exit(1)
		}
		fmt.Println(strings.Join(elems, delimiter))
	default:
		fmt.Fprintf(os.Stderr, "Cannot iterate over %q", src)
		os.Exit(1)
	}
}
