import Foundation
import Clibxls

public final class XLSWorkbook {
    private let workbook: UnsafeMutablePointer<xlsWorkBook>
    
    public init(data: Data, charset: String = "UTF-8") throws {
        var error: xls_error_t = LIBXLS_OK
        
        let workbook = data.withUnsafeBytes { (buffer: UnsafeRawBufferPointer) -> UnsafeMutablePointer<xlsWorkBook>? in
            guard let baseAddress = buffer.baseAddress else { return nil }
            let bytes = baseAddress.assumingMemoryBound(to: UInt8.self)
            return xls_open_buffer(bytes, buffer.count, charset, &error)
        }
        
        guard error == LIBXLS_OK, let wb = workbook else {
            throw XLSError(code: error)
        }
        
        self.workbook = wb
    }
    
    public init(filePath: String, charset: String = "UTF-8") throws {
        var error: xls_error_t = LIBXLS_OK
        
        guard let workbook = xls_open_file(filePath, charset, &error) else {
            throw XLSError(code: error)
        }
        
        guard error == LIBXLS_OK else {
            xls_close_WB(workbook)
            throw XLSError(code: error)
        }
        
        self.workbook = workbook
    }
    
    deinit {
        xls_close_WB(workbook)
    }
    
    public var sheetCount: Int {
        Int(workbook.pointee.sheets.count)
    }
    
    public var sheetNames: [String] {
        var names: [String] = []
        for i in 0..<sheetCount {
            if let sheet = workbook.pointee.sheets.sheet?[i],
               let name = sheet.name {
                names.append(String(cString: name))
            }
        }
        return names
    }
    
    public func sheet(at index: Int) throws -> XLSSheet {
        guard index >= 0 && index < sheetCount else {
            throw XLSError.readFailed
        }
        return try XLSSheet(workbook: workbook, index: Int32(index))
    }
    
    public func sheet(named name: String) throws -> XLSSheet {
        guard let index = sheetNames.firstIndex(of: name) else {
            throw XLSError.readFailed
        }
        return try sheet(at: index)
    }
    
    public var sheets: [XLSSheet] {
        (0..<sheetCount).compactMap { try? sheet(at: $0) }
    }
}
