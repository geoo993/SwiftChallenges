
// The goal of the principle is that subtypes should be immediately subtitutable for their base types

class Rectangle {
    var width: Int
    var height: Int
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
    func setWidth(width: Int) {
        self.width = width
    }
    func setHeight (height: Int) {
        self.height = height
    }
    func getWidth() -> Int {
        return width
    }
    func getHeight() -> Int {
        return height
    }
    func area() -> Int {
        return width * height
    }
}

// let say somehwere down the line you decide to use inheritance to create anoter shape from rectangle
class Square: Rectangle {
    convenience init(size: Int) {
        self.init(width: size, height: size)
    }
    
    // we redefine how width is implemented, and what we have just done is we voilated the LSP by changing the behavior of the base class and when ever the Rectangle is subtituted for the Square, we will not have the same result when we get the width and height because we have broken the setWidth and setHeight mechanics
    override func setWidth(width: Int) {
        super.setWidth(width: width)
        self.width = width
        self.height = width
    }
    override func setHeight(height: Int) {
        super.setHeight(height: height)
        self.width = height
        self.height = height
    }
}

// using factory design pattern to help us avoid voilating the liskov subtitution principle
struct RectangleFactory {
    static func createRectangle(width: Int, height: Int) -> Rectangle {
        return Rectangle(width: width, height: height)
    }
    static func createSquare(size: Int) -> Rectangle {
        return Rectangle(width: size, height: size)
    }
}

func process(rect: Rectangle) {
    let width = rect.getWidth()
    rect.setHeight(height: 10)
    
    print("expected area = \(width * 10), result area \(rect.area()) ")
}

let rectangle = Rectangle(width: 3, height: 4)
process(rect: rectangle)

// LSP is voilated
let square = Square(size: 5)
process(rect: square)

// no voilation of LSP
let newSquare = RectangleFactory.createSquare(size: 5)
// this is how we should be able to substitute a derived class anywhere a base class is expected without ch
process(rect: newSquare)
