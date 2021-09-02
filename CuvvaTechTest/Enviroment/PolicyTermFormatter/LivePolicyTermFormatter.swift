import Foundation

struct LivePolicyTermFormatter: PolicyTermFormatter {
    
    func durationString(for: TimeInterval) -> String {
        let hours = `for` / 3600
        if hours == 0 {
            return "Cancelled Policy"
        }
        var hoursValue = 1
        if hours <= 12 {
            switch hours {
            case 0...1:
                hoursValue = 1
            case 1...2:
                hoursValue = 2
            case 2...3:
                hoursValue = 3
            case 3...6:
                hoursValue = 6
            case 6...12:
                hoursValue = 12
            default:
                hoursValue = 1
            }
            return "\(hoursValue) Hour Policy"
        } else {
            let day = Int(hours / 24)
            return "\(day + 1) Day Policy"
        }
    }
    
    func durationRemainingString(for: PolicyTerm, relativeTo: Date) -> String {
        guard relativeTo.isInRange(`for`.startDate, endDate: `for`.endDate) else {
            return "0 minutes"
        }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.weekOfMonth, .day, .hour, .minute]
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 2
        formatter.allowsFractionalUnits = true
        formatter.zeroFormattingBehavior = .default

        let remainingTime = (`for`.startDate + `for`.duration) - relativeTo
        return formatter.string(from: remainingTime) ?? ""
    }
    
    func durationRemainingPercent(for: PolicyTerm, relativeTo: Date) -> Double {
        guard `for`.startDate.compare(relativeTo) == .orderedAscending
                || `for`.startDate.compare(relativeTo) == .orderedSame,
              `for`.duration > 0 else {
                  return 1.0
              }

        let dateInterval = DateInterval(start: `for`.startDate, end: relativeTo)
        let remainingDuration = `for`.duration - dateInterval.duration
        guard remainingDuration > 0, `for`.duration > 0 else {
            return 0.0
        }

        return remainingDuration / `for`.duration
    }

    func policyDateString(for: Date) -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: `for`)
        let daySuffix: String

        switch day {
        case 11...13: daySuffix = "th"
        default:
            switch day % 10 {
            case 1: daySuffix = "st"
            case 2: daySuffix = "nd"
            case 3: daySuffix = "rd"
            default: daySuffix = "th"
            }
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "E, d'\(daySuffix)' MMM yyyy 'at' h:mma"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"

        return formatter.string(from: `for`)
    }
}
