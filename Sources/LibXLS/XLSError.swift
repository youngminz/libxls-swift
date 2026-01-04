import Foundation
import Clibxls

public enum XLSError: Error, Equatable {
    case openFailed
    case seekFailed
    case readFailed
    case parseFailed
    case mallocFailed
    case unsupportedEncryption
    case nullArgument
    case unknown(UInt32)
    
    init(code: xls_error_t) {
        switch code {
        case LIBXLS_ERROR_OPEN:
            self = .openFailed
        case LIBXLS_ERROR_SEEK:
            self = .seekFailed
        case LIBXLS_ERROR_READ:
            self = .readFailed
        case LIBXLS_ERROR_PARSE:
            self = .parseFailed
        case LIBXLS_ERROR_MALLOC:
            self = .mallocFailed
        case LIBXLS_ERROR_UNSUPPORTED_ENCRYPTION:
            self = .unsupportedEncryption
        case LIBXLS_ERROR_NULL_ARGUMENT:
            self = .nullArgument
        default:
            self = .unknown(code.rawValue)
        }
    }
    
    public var localizedDescription: String {
        switch self {
        case .openFailed:
            return "Failed to open file"
        case .seekFailed:
            return "Failed to seek in file"
        case .readFailed:
            return "Failed to read file"
        case .parseFailed:
            return "Failed to parse file"
        case .mallocFailed:
            return "Memory allocation failed"
        case .unsupportedEncryption:
            return "File uses unsupported encryption"
        case .nullArgument:
            return "Null argument provided"
        case .unknown(let code):
            return "Unknown error (code: \(code))"
        }
    }
}
