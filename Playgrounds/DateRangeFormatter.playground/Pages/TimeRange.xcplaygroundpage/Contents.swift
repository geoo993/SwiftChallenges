import Foundation

let seconds: Double = 60
let interval: TimeInterval = 60 * seconds
let formatter = DateComponentsFormatter()
formatter.allowedUnits = [.hour, .minute]
formatter.zeroFormattingBehavior = .pad

let startTimeList = [0..<24]
    .flatMap { $0 }
    .map { interval * Double($0) }
    .compactMap(formatter.string(from:))
print(startTimeList)

let endTimeList = [1..<25]
    .flatMap { $0 }
    .map {
        let time = interval * Double($0)
        return $0 >= 24 ? time - seconds : time
    }
    .compactMap(formatter.string(from:))
print(endTimeList)
