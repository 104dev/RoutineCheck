import Foundation

extension DateFormatter {
    static var customFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd HH:mm"
        return formatter
    }
}
