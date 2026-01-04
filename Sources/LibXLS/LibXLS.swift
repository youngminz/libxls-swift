import Clibxls

public enum LibXLS {
    public static var version: String {
        guard let version = xls_getVersion() else {
            return "unknown"
        }
        return String(cString: version)
    }
}
