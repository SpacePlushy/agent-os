## Data processing and Excel integration best practices

### Python Data Processing

- **Pandas for DataFrames**: Use pandas as primary tool for tabular data manipulation and analysis
- **NumPy for Arrays**: Use NumPy for numerical computations and array operations
- **Type Safety**: Use Pydantic or Pandera for DataFrame schema validation
- **Memory Efficiency**: Use appropriate dtypes; `category` for low-cardinality strings, `int32` instead of `int64` when possible
- **Chunk Processing**: Process large files in chunks using `pd.read_csv(chunksize=...)`
- **Lazy Evaluation**: Consider Polars or Dask for out-of-memory datasets

### Excel File Operations

#### Reading Excel Files

- **openpyxl**: Use for reading/writing `.xlsx` files (Excel 2010+)
```python
import openpyxl
wb = openpyxl.load_workbook('data.xlsx')
ws = wb['Sheet1']
value = ws['A1'].value
```

- **Pandas read_excel**: Best for reading entire sheets into DataFrames
```python
df = pd.read_excel('data.xlsx', sheet_name='Sheet1', engine='openpyxl')
```

- **xlrd**: Only for legacy `.xls` files (Excel 97-2003); prefer converting to `.xlsx`
- **Read Performance**: For large files, `openpyxl` with `read_only=True` is faster
- **Multiple Sheets**: Read all sheets with `pd.read_excel(file, sheet_name=None)`

#### Writing Excel Files

- **Pandas to_excel**: Simple way to write DataFrames to Excel
```python
df.to_excel('output.xlsx', sheet_name='Data', index=False, engine='openpyxl')
```

- **openpyxl for Formatting**: Use when you need cell formatting, styles, formulas
```python
from openpyxl.styles import Font, PatternFill
ws['A1'].font = Font(bold=True, size=14)
ws['A1'].fill = PatternFill(start_color='FFFF00', fill_type='solid')
```

- **ExcelWriter for Multiple Sheets**: Write multiple DataFrames to different sheets
```python
with pd.ExcelWriter('output.xlsx', engine='openpyxl') as writer:
    df1.to_excel(writer, sheet_name='Sheet1', index=False)
    df2.to_excel(writer, sheet_name='Sheet2', index=False)
```

- **XlsxWriter**: Alternative to openpyxl with rich formatting capabilities

#### Advanced Excel Integration (xlwings)

- **xlwings Use Cases**: When you need bidirectional Excel ” Python communication
- **Live Excel Control**: Automate Excel from Python; read/write while Excel is open
- **User-Defined Functions**: Create Python functions callable from Excel formulas
- **Excel Macros**: Replace VBA macros with Python code
- **Interactive Reports**: Build interactive Excel reports populated by Python

```python
import xlwings as xw

# Open workbook and write data
wb = xw.Book('report.xlsx')
wb.sheets['Data'].range('A1').value = df
wb.save()
wb.close()
```

### Data Validation

- **Input Validation**: Validate all user-provided data before processing
- **Schema Validation**: Use Pydantic models or Pandera schemas to enforce structure
```python
import pandera as pa

schema = pa.DataFrameSchema({
    "name": pa.Column(str),
    "age": pa.Column(int, pa.Check.between(0, 120)),
    "email": pa.Column(str, pa.Check.str_matches(r'^[\w\.-]+@[\w\.-]+\.\w+$'))
})

df = schema.validate(df)  # Raises error if invalid
```

- **Missing Data**: Explicitly handle missing values; don't assume NaN handling
- **Data Types**: Verify data types match expectations; convert when necessary
- **Range Checks**: Validate numeric values are within acceptable ranges
- **Uniqueness**: Check for duplicate keys/IDs when required

### Data Transformation

- **Method Chaining**: Chain pandas operations for readability
```python
result = (df
    .dropna(subset=['important_column'])
    .query('age >= 18')
    .assign(full_name=lambda x: x['first_name'] + ' ' + x['last_name'])
    .groupby('category')
    .agg({'value': 'sum', 'count': 'size'})
)
```

- **Vectorization**: Use vectorized operations instead of loops; dramatically faster
- **Apply Sparingly**: Avoid `.apply()` when vectorized alternative exists
- **Categorical Data**: Convert string columns with repeated values to `category` dtype
- **Date Handling**: Use `pd.to_datetime()` for date parsing; work in datetime64 dtype

### Performance Optimization

- **Profile First**: Use `%%timeit` in Jupyter or `cProfile` to identify bottlenecks
- **Avoid Iteration**: Replace loops with vectorized operations
- **Query vs Boolean Indexing**: `.query()` can be faster for complex conditions
- **Copy vs View**: Understand when pandas returns view vs copy; avoid unnecessary copies
- **Numba**: Use `@numba.jit` for hot numerical loops
- **Parallel Processing**: Use `multiprocessing` or `joblib` for CPU-bound tasks
- **Database for Large Data**: Use SQLite/PostgreSQL instead of in-memory for huge datasets

### Data Export

- **CSV Export**: Use `df.to_csv()` for simple, portable data export
```python
df.to_csv('output.csv', index=False, encoding='utf-8')
```

- **Parquet**: Use for efficient storage of large datasets
```python
df.to_parquet('data.parquet', engine='pyarrow', compression='snappy')
```

- **JSON**: Use for hierarchical or nested data
```python
df.to_json('data.json', orient='records', indent=2)
```

- **SQL**: Export to database for integration with other systems
```python
df.to_sql('table_name', con=engine, if_exists='replace', index=False)
```

### Excel Best Practices

- **Avoid Excel for Storage**: Excel is UI tool, not database; use CSV/Parquet for data storage
- **Validation on Import**: Always validate Excel data; users make mistakes
- **Handle Blank Rows**: Excel files often have blank rows; filter them out
- **Column Names**: Use first row as headers; clean column names (remove spaces, special chars)
- **Date Formats**: Excel dates can be tricky; parse explicitly with format string
- **Large Files**: For files >100MB, consider splitting or using database
- **Read-Only Mode**: Use `read_only=True` when you only need to read data

### Error Handling

- **Graceful Failures**: Catch file I/O errors; provide helpful error messages
```python
try:
    df = pd.read_excel('data.xlsx')
except FileNotFoundError:
    logger.error("File not found: data.xlsx")
    raise
except ValueError as e:
    logger.error(f"Invalid data format: {e}")
    raise
```

- **Validation Errors**: Report validation errors with row/column context
- **Partial Success**: Allow partial processing with error reporting when appropriate
- **User Feedback**: Provide progress updates for long-running operations

### Data Pipeline Patterns

- **Extract-Transform-Load (ETL)**:
  1. Extract: Read from source (Excel, CSV, API, database)
  2. Transform: Clean, validate, enrich, aggregate
  3. Load: Write to destination (database, file, API)

- **Idempotent Operations**: Design pipelines to be re-runnable without side effects
- **Logging**: Log each stage; include row counts, validation results, errors
- **Checkpointing**: Save intermediate results for long pipelines
- **Testing**: Test with representative sample data; include edge cases

### Excel Automation Workflow

```python
import pandas as pd
import openpyxl
from openpyxl.styles import Font, Alignment

def create_formatted_report(data_df, output_path):
    """Create formatted Excel report from DataFrame"""

    # Write data using pandas
    with pd.ExcelWriter(output_path, engine='openpyxl') as writer:
        data_df.to_excel(writer, sheet_name='Report', index=False)

        # Access workbook for formatting
        workbook = writer.book
        worksheet = writer.sheets['Report']

        # Format header row
        for cell in worksheet[1]:
            cell.font = Font(bold=True, size=12)
            cell.alignment = Alignment(horizontal='center')

        # Auto-size columns
        for column in worksheet.columns:
            max_length = 0
            column_letter = column[0].column_letter
            for cell in column:
                if len(str(cell.value)) > max_length:
                    max_length = len(cell.value)
            worksheet.column_dimensions[column_letter].width = max_length + 2

    return output_path
```

### Data Quality Checks

- **Completeness**: Check for missing required fields
- **Accuracy**: Validate values against known ranges or patterns
- **Consistency**: Ensure related fields are logically consistent
- **Uniqueness**: Verify unique constraints where applicable
- **Timeliness**: Check data freshness for time-sensitive data
- **Data Profiling**: Generate statistics (min, max, mean, distinct values) for validation

### Common Data Issues

- **Mixed Types**: Excel columns with mixed data types (numbers as strings)
- **Merged Cells**: Pandas doesn't handle merged cells; they appear as NaN
- **Hidden Rows/Columns**: Not automatically skipped; may need manual handling
- **Formulas**: openpyxl can read formula results or formulas themselves
- **Special Characters**: Handle encoding issues (UTF-8 vs Windows-1252)
- **Excel Limits**: Excel has row limit (1,048,576); column limit (16,384)

### Testing Data Pipelines

- **Unit Tests**: Test individual transformation functions with sample data
- **Integration Tests**: Test full pipeline with realistic data
- **Schema Tests**: Verify output schema matches expectations
- **Data Quality Tests**: Assert data quality metrics meet thresholds
- **Regression Tests**: Ensure changes don't break existing functionality
- **Edge Cases**: Test with empty data, single row, extreme values

### Documentation

- **Data Dictionary**: Document meaning of each column, valid values, units
- **Pipeline Documentation**: Describe each transformation step and its purpose
- **Sample Data**: Provide sample input and expected output
- **Dependencies**: List all required libraries and versions
- **Error Codes**: Document error codes and their meanings
- **Performance Benchmarks**: Document expected processing times for different data sizes

### Tools & Libraries Summary

- **openpyxl**: Read/write .xlsx, cell formatting, formulas
- **xlwings**: Live Excel automation, UDFs, macro replacement
- **pandas**: DataFrame operations, read/write Excel/CSV
- **XlsxWriter**: Write-only, fast, rich formatting
- **pyarrow**: Fast Parquet I/O
- **Polars**: Modern, fast DataFrame library (alternative to pandas)
- **Dask**: Parallel computing, larger-than-memory datasets
- **Pandera**: DataFrame validation and schema enforcement
