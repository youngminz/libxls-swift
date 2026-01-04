import Foundation
import Clibxls

public final class XLSSheet {
    private let worksheet: UnsafeMutablePointer<xlsWorkSheet>
    private let workbook: UnsafeMutablePointer<xlsWorkBook>
    
    internal init(workbook: UnsafeMutablePointer<xlsWorkBook>, index: Int32) throws {
        self.workbook = workbook
        
        guard let ws = xls_getWorkSheet(workbook, index) else {
            throw XLSError.readFailed
        }
        
        let parseResult = xls_parseWorkSheet(ws)
        guard parseResult == LIBXLS_OK else {
            xls_close_WS(ws)
            throw XLSError(code: parseResult)
        }
        
        self.worksheet = ws
    }
    
    deinit {
        xls_close_WS(worksheet)
    }
    
    public var name: String {
        for i in 0..<Int(workbook.pointee.sheets.count) {
            if let sheet = workbook.pointee.sheets.sheet?[i],
               sheet.filepos == worksheet.pointee.filepos,
               let name = sheet.name {
                return String(cString: name)
            }
        }
        return ""
    }
    
    public var rowCount: Int {
        Int(worksheet.pointee.rows.lastrow) + 1
    }
    
    public var columnCount: Int {
        Int(worksheet.pointee.rows.lastcol) + 1
    }
    
    public func cell(row: Int, column: Int) -> XLSCell? {
        guard row >= 0, column >= 0 else { return nil }
        guard let cell = xls_cell(worksheet, UInt16(row), UInt16(column)) else {
            return nil
        }
        return XLSCell(cell: cell)
    }
    
    public var rows: [[XLSCell?]] {
        var result: [[XLSCell?]] = []
        for rowIndex in 0..<rowCount {
            var rowCells: [XLSCell?] = []
            for colIndex in 0..<columnCount {
                rowCells.append(cell(row: rowIndex, column: colIndex))
            }
            result.append(rowCells)
        }
        return result
    }
    
    public var stringRows: [[String?]] {
        rows.map { row in
            row.map { $0?.stringValue }
        }
    }
}
