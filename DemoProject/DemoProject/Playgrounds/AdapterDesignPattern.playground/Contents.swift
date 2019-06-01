// The adapter pattern is used to provide a link between two otherwise incompatible types by wrapping the "adaptee" with a class that supports the interface required by the client.
// We can implement adapter pattern in two ways.
// The first one is object adapter which uses composition.
// Then there is an adaptee instance in adapter to do the job like the following figure and code tell us.

// PART-1
protocol NewCoordinates {
    var latitude: Double { get }
    var longitude: Double { get }
}

//Adaptee
struct OldCoordinates {
    let lat: Float
    let long: Float
    
    init(lat: Float, long: Float) {
        self.lat = lat
        self.long = long
    }
}

//Adapter: The adapter  uses multiple inheritance to connect the latest target and adaptee.
struct Location: NewCoordinates {
    
    private let target: OldCoordinates
    
    var latitude: Double {
        return Double(target.lat)
    }
    
    var longitude: Double {
        return Double(target.long)
    }
    
    init(_ target: OldCoordinates) {
        self.target = target
    }
}

let target = OldCoordinates(lat: 51.403971, long: -0.085503)
let newFormat = Location(target)

newFormat.latitude
newFormat.longitude



// PART-2
import EventKit
/*
 Suppose you want to implement a calendar and event management functionality in your iOS application. To do this, you should integrate the EventKit framework and adapt the Event model from the framework to the model in your application. An Adapter can wrap the model of the framework and make it compatible with the model in your application.
 */
// Models
protocol Event: class {
    var title: String { get }
    var startDate: String { get }
    var endDate: String { get }
}

extension Event {
    var description: String {
        return "Name: \(title)\nEvent start: \(startDate)\nEvent end: \(endDate)"
    }
}

class LocalEvent: Event {
    var title: String
    var startDate: String
    var endDate: String
    
    init(title: String, startDate: String, endDate: String) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
    }
}

// Adapter
class EKEventAdapter: Event {
    private var event: EKEvent
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return dateFormatter
    }()
    
    var title: String {
        return event.title
    }
    var startDate: String {
        return dateFormatter.string(from: event.startDate)
    }
    var endDate: String {
        return dateFormatter.string(from: event.endDate)
    }
    
    init(event: EKEvent) {
        self.event = event
    }
}

// Usage
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"

let eventStore = EKEventStore()
let event = EKEvent(eventStore: eventStore)
event.title = "Adapter Design Pattern"
event.startDate = dateFormatter.date(from: "05/12/2019 10:00")
event.endDate = dateFormatter.date(from: "05/12/2019 22:30")

let adapter = EKEventAdapter(event: event)
print(adapter.description)
