# libxls-swift

A Swift Package for reading legacy Microsoft Excel files (.xls format) on Apple platforms.

## Overview

libxls-swift wraps [libxls](https://github.com/libxls/libxls) 1.6.3, a C library for parsing Excel files in the Binary Interchange File Format (BIFF). This package provides a Swift-friendly API for reading .xls files on iOS, macOS, tvOS, watchOS, and visionOS.

## Requirements

- iOS 14.0+
- macOS 11.0+
- tvOS 14.0+
- watchOS 7.0+
- visionOS 1.0+
- Swift 5.9+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/youngminz/libxls-swift.git", from: "1.0.0")
]
```

Or in Xcode, go to File > Add Package Dependencies and enter the repository URL.

## Usage

### Opening a Workbook

```swift
import LibXLS

// From file path
let workbook = try XLSWorkbook(filePath: "/path/to/file.xls")

// From Data
let data = try Data(contentsOf: url)
let workbook = try XLSWorkbook(data: data)

// With custom charset (default is UTF-8)
let workbook = try XLSWorkbook(data: data, charset: "UTF-8")
```

### Accessing Sheets

```swift
// Get sheet count
let count = workbook.sheetCount

// Get all sheet names
let names = workbook.sheetNames

// Get sheet by index
let sheet = try workbook.sheet(at: 0)

// Get sheet by name
let sheet = try workbook.sheet(named: "Sheet1")

// Get all sheets
let sheets = workbook.sheets
```

### Reading Cell Data

```swift
let sheet = try workbook.sheet(at: 0)

// Get sheet dimensions
print("Rows: \(sheet.rowCount), Columns: \(sheet.columnCount)")

// Read a specific cell
if let cell = sheet.cell(row: 0, column: 0) {
    // Get string value
    if let string = cell.stringValue {
        print(string)
    }
    
    // Get numeric value
    if let number = cell.doubleValue {
        print(number)
    }
    
    // Check if blank
    if cell.isBlank {
        print("Cell is blank")
    }
}

// Get all rows as strings
let stringRows = sheet.stringRows
for row in stringRows {
    print(row)
}
```

### Error Handling

```swift
do {
    let workbook = try XLSWorkbook(data: data)
} catch XLSError.parseFailed {
    print("Failed to parse the file")
} catch XLSError.unsupportedEncryption {
    print("File uses unsupported encryption")
} catch {
    print("Error: \(error)")
}
```

## API Reference

### XLSWorkbook

| Property/Method | Description |
|----------------|-------------|
| `init(data:charset:)` | Create workbook from Data |
| `init(filePath:charset:)` | Create workbook from file path |
| `sheetCount` | Number of sheets |
| `sheetNames` | Array of sheet names |
| `sheet(at:)` | Get sheet by index |
| `sheet(named:)` | Get sheet by name |
| `sheets` | All sheets as array |

### XLSSheet

| Property/Method | Description |
|----------------|-------------|
| `name` | Sheet name |
| `rowCount` | Number of rows |
| `columnCount` | Number of columns |
| `cell(row:column:)` | Get cell at position |
| `rows` | All cells as 2D array |
| `stringRows` | All cell string values as 2D array |

### XLSCell

| Property/Method | Description |
|----------------|-------------|
| `stringValue` | Cell value as String |
| `doubleValue` | Cell value as Double |
| `intValue` | Cell value as Int |
| `isBlank` | True if cell is blank |
| `isHidden` | True if cell is hidden |
| `row` | Row index |
| `column` | Column index |
| `colspan` | Column span for merged cells |
| `rowspan` | Row span for merged cells |

### XLSError

| Case | Description |
|------|-------------|
| `openFailed` | Failed to open file |
| `seekFailed` | Failed to seek in file |
| `readFailed` | Failed to read file |
| `parseFailed` | Failed to parse file |
| `mallocFailed` | Memory allocation failed |
| `unsupportedEncryption` | Unsupported encryption |
| `nullArgument` | Null argument provided |

## Limitations

- Only reads .xls files (BIFF format, Excel 97-2003)
- Does not support .xlsx files (use a different library)
- Read-only (cannot create or modify files)
- Encrypted files with unsupported encryption will fail to open

## License

This project is licensed under the BSD-2-Clause License - see the [LICENSE](LICENSE) file for details.

This package wraps [libxls](https://github.com/libxls/libxls) which is also licensed under BSD-2-Clause.

## Credits

- [libxls](https://github.com/libxls/libxls) - The underlying C library
