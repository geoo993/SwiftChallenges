// The bridge pattern is used to separate the abstract elements of a class from the implementation details, providing the means to replace the implementation details without modifying the abstraction.
// Bridge is another representative of iOS application design patterns. It’s very similar to the Adapter, but it has a few differences. In case with Bridge, we can modify the source code since we have access to it. The pattern separates the abstraction from the implementation so that they can be changed without corresponding changes in another class.
// The Bridge Pattern decouple an abstraction from its implementation so that the two can vary independently. It really helps when you don’t know what business logic to implement and usually when it's crunch time or when deadlines are approaching you would tend to not touch your abstraction and work more the implementation side of things, as business logic becomes more of a priority or requirement.
// The Bridge Pattern is used to solve a problem programmers refer to as an “exploding class hierarchy.” Exploding class hierarchies occur when the number of classes increases sharply with additional features.


// PART- 1
protocol Switch {
    var appliance: Appliance { get set }
    func turnOn()
}

protocol Appliance {
    func run()
}

final class RemoteControl: Switch {
    var appliance: Appliance
    
    func turnOn() {
        self.appliance.run()
    }
    
    init(appliance: Appliance) {
        self.appliance = appliance
    }
}

final class TV: Appliance {
    func run() {
        print("tv turned on");
    }
}

final class VacuumCleaner: Appliance {
    func run() {
        print("vacuum cleaner turned on")
    }
}

let tvRemoteControl = RemoteControl(appliance: TV())
tvRemoteControl.turnOn()

let fancyVacuumCleanerRemoteControl = RemoteControl(appliance: VacuumCleaner())
fancyVacuumCleanerRemoteControl.turnOn()



// PART-2
import Foundation

protocol GraphicsAPI {
    func drawRectangle(_ x: Int, _ y: Int, _ width: Int, _ height: Int)
    func drawCircle(_ x: Int, _ y: Int, _ radius: Int)
}

public class Shape {
    
    let graphicsApi: GraphicsAPI
    
    init(_ graphicsApi: GraphicsAPI) {
        self.graphicsApi = graphicsApi
    }
    
    func draw() -> Void {
        
    }
}
// Abstration base class. Implementing this base class we could extend abstraction and make concrete classes what will be used in other parts of project. In following example, Shape is base abstraction class and Circle and Rectangle is concrete classes of our abstraction. Notice the draw() method, actually the figure isn’t drawn rather linked up with other class invoking method of that class.
public class Circle : Shape {
    var x: Int = 0
    var y: Int = 0
    var radius: Int = 0
    
    convenience init(_ x: Int, _ y: Int, _ radius: Int, _ graphicsApi: GraphicsAPI) {
        self.init(graphicsApi)
        self.x = x
        self.y = y
        self.radius = radius
    }
    
    override func draw() -> Void {
        self.graphicsApi.drawCircle(self.x, self.y, self.radius)
    }
}

public class Rectangle : Shape {
    var x: Int = 0
    var y: Int = 0
    var width: Int = 0
    var height: Int = 0
    
    convenience init(_ x: Int, _ y: Int, _ width: Int, _ height: Int, _ graphicsApi: GraphicsAPI) {
        self.init(graphicsApi)
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
    
    override func draw() -> Void {
        self.graphicsApi.drawRectangle(x, y, width, height)
    }
}

// Now implementor classes need to be implemented based on business logic/implementation choice.
// this is how the bridge patterns helps as it seperates the abstraction elements of a class from the implementetion detail. it is good for run time binding of implementation such as drawrect and drawcircle.
// you may noticed we have 2 concrete implementation classes. You can choose any of them at runtime. For example, you can draw Circle and Rectangle using either DirectXAPI/OpenGLAPI at runtime.
class DirectXAPI : GraphicsAPI {
    
    func drawRectangle(_ x: Int, _ y: Int, _ width: Int, _ height: Int) {
        print("Rectangle drawn by DirectXAPI API");
    }
    
    func drawCircle(_ x: Int, _ y: Int, _ radius: Int) {
        print("Circle drawn by DirectXAPI API");
    }
}

public class OpenGLAPI : GraphicsAPI {
    
    func drawRectangle(_ x: Int, _ y: Int, _ width: Int, _ height: Int) {
        print("Rectangle drawn by OpenGL API")
    }
    
    func drawCircle(_ x: Int, _ y: Int, _ radius: Int) {
        print("Circle drawn by OpenGL API")
    }
}

// Bridge pattern is good for run time binding of implementation
var openGLApi: OpenGLAPI = OpenGLAPI()
var directXApi: DirectXAPI = DirectXAPI()

var circle: Circle = Circle(10, 10, 10, openGLApi)
circle.draw()

circle = Circle(10, 5, 4, directXApi)
circle.draw()

var rect: Rectangle = Rectangle(10, 10, 10, 10, openGLApi)
rect.draw()

rect = Rectangle(10, 10, 10, 10, directXApi)
rect.draw()
