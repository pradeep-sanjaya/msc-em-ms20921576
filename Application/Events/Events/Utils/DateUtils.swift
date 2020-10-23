import Foundation

class DateUtils {
    static func addDates(to date: Date, days: Int) -> Date? {
        var dayComponent = DateComponents()
        dayComponent.day = days
        let calendar     = Calendar.current
        let nextDate     = calendar.date(byAdding: dayComponent, to: date)
        return nextDate
    }
}
