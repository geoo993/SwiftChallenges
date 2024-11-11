import UIKit

var fromDate: Date?
var toDate: Date?
var components = Set<DateComponents>()

public enum CalendarQuarter: Int {
    case first
    case second
    case third
    case fourth
}

public enum DateRangeOption: String {
    case thisWeek
    case lastWeek
    case thisMonth
    case lastMonth
    case thisQuarter
    case lastQuarter
}

func simpledate(from string: String, locale: Locale = .autoupdatingCurrent, timeZone: TimeZone = .autoupdatingCurrent) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"
    formatter.timeZone = timeZone
    formatter.locale = locale
    return formatter.date(from: string)
}

final class FilterDateFormatter {
    let calendar: Calendar
    
    init(calendar: Calendar = Calendar.current) {
        self.calendar = calendar
    }
    
    func removeTimestamp(in date: Date = .now) -> Date {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components)!
    }
    
    func lastSevenDays(current: Date = .now) -> Date {
        return calendar.date(byAdding: .day, value: -7, to: current)!
    }
    
    func startOfWeek(current: Date = .now) -> Date {
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: current)
        return calendar.date(from: components)!
    }
    
    func startOfLastWeek(current: Date = .now) -> Date {
        calendar.date(byAdding: .day, value: -7, to: startOfWeek(current: current))!
    }
    
    func endOfLastWeek(current: Date = .now) -> Date {
        calendar.date(byAdding: .day, value: -1, to: startOfWeek(current: current))!
    }
    
    func startOfThisMonth(current: Date = .now) -> Date {
        let components = calendar.dateComponents([.year, .month], from: current)
        return calendar.date(from: components)!
    }
    
    func startOfLastMonth(current: Date = .now) -> Date {
        let previousMonth = calendar.date(byAdding: .month, value: -1, to: current)!
        var component = calendar.dateComponents([.year, .month, .day], from: previousMonth)
        component.day = 1
        return calendar.date(from: component)!
    }

    func endOfLastMonth(current: Date = .now) -> Date {
        calendar.date(byAdding: .day, value: -1, to: startOfThisMonth(current: current))!
    }
    
    func firstMonthOfCurrentQuarter(from current: Date) -> Int {
        let currentMonth = calendar.component(.month, from: current)
        let quarter = (currentMonth - 1) / 3
        return quarter * 3 + 1
    }

    func startOfThisQuarter(current: Date = .now) -> Date {
        let firstMonthOfQuarter = firstMonthOfCurrentQuarter(from: current)
        let currentYear = calendar.component(.year, from: current)
        let components = DateComponents(year: currentYear, month: firstMonthOfQuarter, day: 1)
        return calendar.date(from: components)!
    }
    
    func startOfLastQuarter(current: Date = .now) -> Date {
        let currentQuarter = startOfThisQuarter(current: current)
        return calendar.date(byAdding: .month, value: -3, to: currentQuarter)!
    }
    
    func endOfLastQuarter(current: Date = .now) -> Date {
        calendar.date(byAdding: .day, value: -1, to: startOfThisQuarter(current: current))!
    }
    
    func createDates(from start: Date, to end: Date) -> Set<DateComponents> {
        guard end >= start else { return [] }
        var datesArray: [DateComponents] = [calendar.dateComponents([.year, .month, .day], from: start)]
        print("start:", start.formatted(), ", end:", end.formatted())
        let matching = DateComponents(hour: 0, minute: 0, second: 0)
        calendar.enumerateDates(
            startingAfter: start,
            matching: matching,
            matchingPolicy: .nextTime
        ) { (date, _, stop) in
            if let nextDate = date {
                datesArray.append(calendar.dateComponents([.year, .month, .day], from: nextDate))
                print("date found", nextDate.formatted())
                stop = nextDate >= end
            } else {
                stop = true
            }
        }
        return Set(datesArray)
    }
}

func calculateDateComponent(from option: DateRangeOption) {
    let calendar = Calendar.current
    let formatter = FilterDateFormatter(calendar: calendar)
    print("calendar identifier", calendar.identifier)
    let currentDate = formatter.removeTimestamp(in: .now)

    switch option {
    case .thisWeek:
        let thisMonday = formatter.startOfWeek(current: currentDate)
        let dates = formatter.createDates(from: thisMonday, to: currentDate)
        fromDate = thisMonday
        toDate = currentDate
        components = dates
    case .lastWeek:
        let lastWeek = formatter.startOfLastWeek(current: currentDate)
        let endOflastWeek = formatter.endOfLastWeek(current: currentDate)
        let dates = formatter.createDates(from: lastWeek, to: endOflastWeek)
        fromDate = lastWeek
        toDate = endOflastWeek
        components = dates
    case .thisMonth:
        let thisMonth = formatter.startOfThisMonth(current: currentDate)
        let dates = formatter.createDates(from: thisMonth, to: currentDate)
        fromDate = thisMonth
        toDate = currentDate
        components = dates
    case .lastMonth:
        let lastMonth = formatter.startOfLastMonth(current: currentDate)
        let endOflastMonth = formatter.endOfLastMonth(current: currentDate)
        let dates = formatter.createDates(from: lastMonth, to: endOflastMonth)
        fromDate = lastMonth
        toDate = endOflastMonth
        components = dates
    case .thisQuarter:
        break
    case .lastQuarter:
        break
    }
}


let value = simpledate(from: "2024-04-13T11:42:00")!
let calendar = Calendar.current
let formatter = FilterDateFormatter(calendar: calendar)
print("calendar identifier", calendar.identifier)
let currentDate = formatter.removeTimestamp(in: value)
let lastSevenDay = formatter.lastSevenDays(current: currentDate)
let thisMonday = formatter.startOfWeek(current: currentDate)
let lastWeek = formatter.startOfLastWeek(current: currentDate)
let endlastWeek = formatter.endOfLastWeek(current: currentDate)
let startOfThisMonth = formatter.startOfThisMonth(current: currentDate)
let startOfLastMonth = formatter.startOfLastMonth(current: currentDate)
let endOfLastMonth = formatter.endOfLastMonth(current: currentDate)
let startOfThisQuarter = formatter.startOfThisQuarter(current: currentDate)
let startOfLastQuarter = formatter.startOfLastQuarter(current: currentDate)
let endOfLastQuarter = formatter.endOfLastQuarter(current: currentDate)

print("current date", currentDate.formatted())
print("Last seventh day", lastSevenDay.formatted())
print("This Monday Start", thisMonday.formatted())
print("Last week date Start", lastWeek.formatted())
print("Last week date End", endlastWeek.formatted())
print("This Month Start", startOfThisMonth.formatted())
print("Last Month Start", startOfLastMonth.formatted())
print("Last Month End", endOfLastMonth.formatted())
print("This Quarter Start", startOfThisQuarter.formatted())
print("Last Quarter Start", startOfLastQuarter.formatted())
print("Last Quarter End", endOfLastQuarter.formatted())

