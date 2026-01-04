import XCTest
@testable import LibXLS

final class LibXLSTests: XCTestCase {
    
    func testVersion() {
        let version = LibXLS.version
        XCTAssertEqual(version, "1.6.3")
    }
    
    func testOpenWorkbookFromFile() throws {
        let testFileURL = Bundle.module.url(forResource: "test2", withExtension: "xls", subdirectory: "Resources")
        XCTAssertNotNil(testFileURL, "Test file should exist")
        
        let workbook = try XLSWorkbook(filePath: testFileURL!.path)
        XCTAssertGreaterThan(workbook.sheetCount, 0)
    }
    
    func testOpenWorkbookFromData() throws {
        let testFileURL = Bundle.module.url(forResource: "test2", withExtension: "xls", subdirectory: "Resources")!
        let data = try Data(contentsOf: testFileURL)
        
        let workbook = try XLSWorkbook(data: data)
        XCTAssertGreaterThan(workbook.sheetCount, 0)
    }
    
    func testSheetNames() throws {
        let testFileURL = Bundle.module.url(forResource: "test2", withExtension: "xls", subdirectory: "Resources")!
        let data = try Data(contentsOf: testFileURL)
        
        let workbook = try XLSWorkbook(data: data)
        let names = workbook.sheetNames
        XCTAssertFalse(names.isEmpty)
    }
    
    func testGetSheetByIndex() throws {
        let testFileURL = Bundle.module.url(forResource: "test2", withExtension: "xls", subdirectory: "Resources")!
        let data = try Data(contentsOf: testFileURL)
        
        let workbook = try XLSWorkbook(data: data)
        let sheet = try workbook.sheet(at: 0)
        XCTAssertFalse(sheet.name.isEmpty)
    }
    
    func testGetSheetByName() throws {
        let testFileURL = Bundle.module.url(forResource: "test2", withExtension: "xls", subdirectory: "Resources")!
        let data = try Data(contentsOf: testFileURL)
        
        let workbook = try XLSWorkbook(data: data)
        let firstName = workbook.sheetNames.first!
        let sheet = try workbook.sheet(named: firstName)
        XCTAssertEqual(sheet.name, firstName)
    }
    
    func testSheetDimensions() throws {
        let testFileURL = Bundle.module.url(forResource: "test2", withExtension: "xls", subdirectory: "Resources")!
        let data = try Data(contentsOf: testFileURL)
        
        let workbook = try XLSWorkbook(data: data)
        let sheet = try workbook.sheet(at: 0)
        
        XCTAssertGreaterThanOrEqual(sheet.rowCount, 0)
        XCTAssertGreaterThanOrEqual(sheet.columnCount, 0)
    }
    
    func testReadCells() throws {
        let testFileURL = Bundle.module.url(forResource: "test2", withExtension: "xls", subdirectory: "Resources")!
        let data = try Data(contentsOf: testFileURL)
        
        let workbook = try XLSWorkbook(data: data)
        let sheet = try workbook.sheet(at: 0)
        
        if sheet.rowCount > 0 && sheet.columnCount > 0 {
            let cell = sheet.cell(row: 0, column: 0)
            XCTAssertNotNil(cell)
        }
    }
    
    func testStringRows() throws {
        let testFileURL = Bundle.module.url(forResource: "test2", withExtension: "xls", subdirectory: "Resources")!
        let data = try Data(contentsOf: testFileURL)
        
        let workbook = try XLSWorkbook(data: data)
        let sheet = try workbook.sheet(at: 0)
        let stringRows = sheet.stringRows
        
        XCTAssertEqual(stringRows.count, sheet.rowCount)
    }
    
    func testInvalidSheetIndex() throws {
        let testFileURL = Bundle.module.url(forResource: "test2", withExtension: "xls", subdirectory: "Resources")!
        let data = try Data(contentsOf: testFileURL)
        
        let workbook = try XLSWorkbook(data: data)
        XCTAssertThrowsError(try workbook.sheet(at: 999))
    }
    
    func testInvalidSheetName() throws {
        let testFileURL = Bundle.module.url(forResource: "test2", withExtension: "xls", subdirectory: "Resources")!
        let data = try Data(contentsOf: testFileURL)
        
        let workbook = try XLSWorkbook(data: data)
        XCTAssertThrowsError(try workbook.sheet(named: "NonExistentSheet"))
    }
    
    func testInvalidData() {
        let invalidData = Data([0x00, 0x01, 0x02, 0x03])
        XCTAssertThrowsError(try XLSWorkbook(data: invalidData))
    }
    
    func testSheetsProperty() throws {
        let testFileURL = Bundle.module.url(forResource: "test2", withExtension: "xls", subdirectory: "Resources")!
        let data = try Data(contentsOf: testFileURL)
        
        let workbook = try XLSWorkbook(data: data)
        let sheets = workbook.sheets
        
        XCTAssertEqual(sheets.count, workbook.sheetCount)
    }
}
