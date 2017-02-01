# USAGE

    xlsx2csv [OPTIONS] EXCEL_WORKBOOK_NAME [SHEET_NAME]

## SYNOPSIS

xlsx2csv is a tool to extract individual Excel sheets as CSV output from an 
Excel workbook in the .xlsx format. CSV content is written to Stdout.

## OPTIONS

```
    -c    display number of sheets in Excel Workbook
    -h    display help
    -l    display license
    -n    display sheet names in Excel W9rkbook
    -v    display version
```

## EXAMPLE

```
    xlsx2csv my-workbook.xlsx "Sheet 1" > sheet1.csv
```

This would get the first sheet from the workbook and save it as a CSV file.

```
    xlsx2csv -c my-workbook.xlsx
```

This will output the number of sheels in the Workbook.

```
    xlsx2csv -n my-workbook.xlsx
```

This will display a list of sheet names, one per line.
Putting it all together in a shell script.

```shell
    for SHEET_NAME in $(xlsx2csv -n my-workbook.xlsx); do
       xlsx2csv my-workbook.xlsx "$SHEET_NAME" > \
           $(slugify "$SHEET_NAME").csv
    done
```

