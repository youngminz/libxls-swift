import Foundation
import Clibxls

public struct XLSCell {
    private let cell: UnsafeMutablePointer<st_cell_data>
    
    internal init(cell: UnsafeMutablePointer<st_cell_data>) {
        self.cell = cell
    }
    
    public var id: UInt16 {
        cell.pointee.id
    }
    
    public var row: Int {
        Int(cell.pointee.row)
    }
    
    public var column: Int {
        Int(cell.pointee.col)
    }
    
    public var isBlank: Bool {
        cell.pointee.id == UInt16(XLS_RECORD_BLANK)
    }
    
    public var isHidden: Bool {
        cell.pointee.isHidden != 0
    }
    
    public var stringValue: String? {
        guard let str = cell.pointee.str else {
            if cell.pointee.id == UInt16(XLS_RECORD_NUMBER) ||
               cell.pointee.id == UInt16(XLS_RECORD_RK) {
                return String(cell.pointee.d)
            }
            return nil
        }
        return String(cString: str)
    }
    
    public var doubleValue: Double? {
        switch Int32(cell.pointee.id) {
        case XLS_RECORD_NUMBER, XLS_RECORD_RK, XLS_RECORD_FORMULA, XLS_RECORD_FORMULA_ALT:
            return cell.pointee.d
        default:
            if let str = stringValue {
                return Double(str)
            }
            return nil
        }
    }
    
    public var intValue: Int? {
        if let d = doubleValue {
            return Int(d)
        }
        return nil
    }
    
    public var colspan: Int {
        Int(cell.pointee.colspan)
    }
    
    public var rowspan: Int {
        Int(cell.pointee.rowspan)
    }
}
