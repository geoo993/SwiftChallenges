import Foundation

// ======== PART ONE
//Consider a Landmark structure that stores the name and founding year of a landmark:
//Adding Codable to the inheritance list for Landmark triggers an automatic conformance that satisfies all of the protocol requirements from Encodable and Decodable:

struct Landmark: Codable {
    var name: String
    var foundingYear: Int
    
    // Landmark now supports the Codable methods init(from:) and encode(to:),
    // even though they aren't written as part of its declaration.
}

/*
 Adopting Codable on your own types enables you to serialize them to and from any of the built-in data formats, and any formats provided by custom encoders and decoders. For example, the Landmark structure can be encoded using both the PropertyListEncoder and JSONEncoder classes, even though Landmark itself contains no code to specifically handle property lists or JSON.
 
 The same principle applies to custom types made up of other custom types that are codable. As long as all of its properties are Codable, any custom type can also be Codable.
 
 */

 //The example below shows how automatic Codable conformance applies when a location property is added to the Landmark structure:
struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
}

struct Landmark2: Codable {
    // Double, String, and Int all conform to Codable.
    var name: String
    var foundingYear: Int
    
    // Adding a property of a custom Codable type maintains overall Codable conformance.
    var location: Coordinate
}

/*
 Built-in types such as Array, Dictionary, and Optional also conform to Codable whenever they contain codable types. You can add an array of Coordinate instances to Landmark, and the entire structure will still satisfy Codable.
 
 The example below shows how automatic conformance still applies when adding multiple properties using built-in codable types within Landmark:
 
 */
struct Landmark3: Codable {
    var name: String
    var foundingYear: Int
    var location: Coordinate
    
    // Landmark is still codable after adding these properties.
    var vantagePoints: [Coordinate]
    var metadata: [String: String]
    var website: URL?
}

/*
In some cases, you may not need Codable's support for bidirectional encoding and decoding. For example, some apps only need to make calls to a remote network API and do not need to decode a response containing the same type. Declare conformance to Encodable if you only need to support the encoding of data. Conversely, declare conformance to Decodable if you only need to read data of a given type.

The examples below show alternative declarations of the Landmark structure that only encode or decode data:
*/
struct LandmarkEnco: Encodable {
    var name: String
    var foundingYear: Int
}
struct LandmarkDeco: Decodable {
    var name: String
    var foundingYear: Int
}

/*
 Codable types can declare a special nested enumeration named CodingKeys that conforms to the CodingKey protocol. When this enumeration is present, its cases serve as the authoritative list of properties that must be included when instances of a codable type are encoded or decoded. The names of the enumeration cases should match the names you've given to the corresponding properties in your type.
 
 Omit properties from the CodingKeys enumeration if they won't be present when decoding instances, or if certain properties shouldn't be included in an encoded representation. A property omitted from CodingKeys needs a default value in order for its containing type to receive automatic conformance to Decodable or Codable.
 
 The example below uses alternative keys for the name and foundingYear properties of the Landmark structure when encoding and decoding:
 */

struct Landmark4: Codable {
    var name: String
    var foundingYear: Int
    var location: Coordinate
    var vantagePoints: [Coordinate]
    
    // Ommited: this property is not included in the CodingKeys enum and hence will not be encoded/decoded.
    var currency: String = "$"
    
    enum CodingKeys: String, CodingKey {
        // Creating a different encoded representation of data.
        // Their encoded representation have are specified differently
        case name = "title"
        case foundingYear = "founding_date"
        
        // Main encoding keys
        case location
        case vantagePoints
    }
}


/*
 If the structure of your Swift type differs from the structure of its encoded form, you can provide a custom implementation of Encodable and Decodable to define your own encoding and decoding logic.
 
 In the examples below, the Coordinate structure is expanded to support an elevation property that's nested inside of an additionalInfo container:
 
 */
struct Coordinate2 {
    var latitude: Double
    var longitude: Double
    var elevation: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case additionalInfo
    }
    
    enum AdditionalInfoKeys: String, CodingKey {
        case elevation
    }
}

/*
 Because the encoded form of the Coordinate type contains a second level of nested information, the type's adoption of the Encodable and Decodable protocols uses two enumerations that each list the complete set of coding keys used on a particular level.
 
 In the example below, the Coordinate structure is extended to conform to the Decodable protocol by implementing its required initializer, init(from:):
 
 */
extension Coordinate2: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decode(Double.self, forKey: .latitude)
        longitude = try values.decode(Double.self, forKey: .longitude)
        
        let additionalInfo = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
        elevation = try additionalInfo.decode(Double.self, forKey: .elevation)
    }
}

/*
 The initializer populates a Coordinate instance by using methods on the Decoder instance it receives as a parameter. The Coordinate instance's two properties are initialized using the keyed container APIs provided by the Swift standard library.
 
 The example below shows how the Coordinate structure can be extended to conform to the Encodable protocol by implementing its required method, encode(to:):
 
 */
extension Coordinate2: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        
        var additionalInfo = container.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
        try additionalInfo.encode(elevation, forKey: .elevation)
    }
}

// ======= PART TWO
print("\nPart Two")
/*
 As you can see, in particular, it has become extremely simple to play with JSON after Apple has launched Encodable and Decodable.
 There are two protocols to encode and decode. These are Encodable and Decodable.
 Codable is just a type alias to represent both of these protocols.
 
 typealias Codable = Decodable & Encodable.
 
 Obviously, you can use this type alias to both encode and decode.
 
 in addition, CodingKeys allows you to use specific variable names to represent your JSON keys.

 */


// Our JSON fragment is as follows.
let rawData = """
{
    "job_information": {
        "title": "iOS Developer",
        "salary": 5000
    },
    "firstname": "John",
    "lastname": "Doe",
    "age": 20
}
""".data(using: .utf8)!

// And
struct Job: Decodable {
    var title: String
    var salary: Float
    
    init(title: String, salary: Float) {
        self.title = title
        self.salary = salary
    }
    
    enum CodingKeys: String, CodingKey {
        case title, salary
    }
}

struct Person: Decodable {
    var job: Job
    var firstName: String
    var lastName: String
    var age: Int
    
    init(job: Job, firstName: String, lastName: String, age: Int) {
        self.job = job
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    // omitted in endoding and decoding and only serve as jSON Keys
    enum CodingKeys: String, CodingKey {
        case job = "job_information"
        case firstName = "firstname"
        case lastName = "lastname"
        
        case age
    }
}

let person = try JSONDecoder().decode(Person.self, from: rawData)
print(person)
print(person.job)
print(person.firstName) // John
print(person.lastName) // Doe
print(person.job.title) // iOS Developer


// A type that can encode itself to an external representation.


struct Human: Encodable {
    var firstname: String
    var lastname: String
    var age: Int
    
    init(firstname: String, lastname: String, age: Int) {
        self.firstname = firstname
        self.lastname = lastname
        self.age = age
    }
}

struct People: Encodable {
    var members: [Human]
    
    init(members: [Human]) {
        self.members = members
    }
}

let people = People(members: [Human(firstname: "John", lastname: "Doe", age: 20), Human(firstname: "Joe", lastname: "Ra", age: 22)])
let encoded = try JSONEncoder().encode(people)
print(String(data: encoded, encoding: .utf8)!)


/// ======== PART THREE
print("\nPart Three")
/*

 To encode and decode a custom type, we need to make it Codable.
 
 The simplest way to make a type codable is to declare its properties using types that are already Codable.
 Built-in Codable types — String, Int, Double, Data, URL.
 Array, Dictionary, Optional are Codable if they contain Codable types.
 */

struct Photo: Codable
{
    //String, URL, Bool and Date conform to Codable.
    var title: String
    var url: URL
    var isSample: Bool
    
    //The Dictionary is of type [String:String] and String already conforms to Codable.
    var metaData: [String:String]
    
    //PhotoType and Size are also Codable types
    var type: PhotoType
    var size: Size
}

struct Size: Codable
{
    var height: Double
    var width: Double
}

enum PhotoType: String, Codable
{
    case flower
    case animal
    case fruit
    case vegetable
}

/*
 
So, now that we have seen what Codable is, let’s see how to actually use it to encode and decode our own custom types
 
 You can use JSONEncoder to convert your codable type into Data.
 
 JSONEncoder’s encode(_:) method returns a JSON-encoded representation of the codable type.
 
*/

let photoObject = Photo(title: "Hibiscus", url: URL(string: "https://www.flowers.com/hibiscus")!, isSample: false, metaData: ["color" : "red"], type: .flower, size: Size(height: 200, width: 200))
let encodedData = try JSONEncoder().encode(photoObject)

print(String(data: encodedData, encoding: .utf8)!)


/*
 Just like JSONEncoder, there exist JSONDecoder that can be used to decode your JSON data back into your codable type.
 
 JSONDecoder’s decode(_:from:) method returns a value of the codable type you specify, decoded from a JSON object.
 
 */
let jsonString = """
{
    "type":"fruit",
    "size":{
        "width":150,
        "height":150
    },
    "title":"Apple",
    "url":"https:\\/\\/www.fruits.com\\/apple",
    "isSample":true,
    "metaData":{
        "color":"green"
    }
}
"""
if let jsonData = jsonString.data(using: .utf8)
{
    let photoObject = try JSONDecoder().decode(Photo.self, from: jsonData)
    print(photoObject.type.rawValue)
    print(photoObject.size)
    print(photoObject.title)
    print(photoObject.url)
    print(photoObject.isSample)
    print(photoObject.metaData)
}


/*
 There might be some questions ❓❓coming to your mind,
 
 What if I want to omit some properties of the Codable Type from the serialization process?
 How to encode/decode if some of the keys 🔑 included in the serialized data doesn’t match the property names of the Codable Type?
 Well, Apple provided solution for that too — enum CodingKeys.
 
 Codable types can declare a special nested enumeration named CodingKeys that conforms to the CodingKey protocol. When this enumeration is present, its cases serve as the authoritative list of properties that must be included when instances of a codable type are encoded or decoded.
 
 Things to note about CodingKeys:
 
 1)  It has a Raw Type — String and conform to CodingKey protocol.
 2)  The names of the enum cases should exactly match 💯 the property names of the Codable Type.
 3)  Answer to 1st Question ✅— Omit the properties from CodingKeys if you want to omit them from encoding/decoding process. A property omitted from CodingKeys needs a default value.
 4)  Answer to 2nd Question ✅ — Raw Value is the thing you need if the property names of Codable Type doesn’t match the keys in the serialized data. Provide alternative keys by specifying String as the raw-value type for the CodingKeys enumeration. The string you use as a raw value for each enumeration case is the key name used during encoding and decoding.

 */

struct Photo2: Codable
{
    //String, URL, Bool and Date conform to Codable.
    var title: String
    var url: URL
    var isSample: Bool
    
    //The Dictionary is of type [String:String] and String already conforms to Codable.
    var metaData: [String:String]
    
    //PhotoType and Size are also Codable types
    var type: PhotoType
    var size: Size

    //This property is not included in the CodingKeys enum and hence will not be encoded/decoded.
    var format: String = "png"
    
    enum CodingKeys: String, CodingKey
    {
        // providing different encoded representation
        case title = "name"
        case url = "link"
        
        // keeping same encoded representation
        case isSample
        case metaData
        case type
        case size
    }
}
