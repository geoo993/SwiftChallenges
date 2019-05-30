//
//  Describe.swift
//  ViperCore
//
//  Created by Daniel Asher on 14/02/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//
public func describe(_ any: Any) -> String {
    guard let any = deepUnwrap(any) else {
        return "nil"
    }

    if any is Void {
        return "Void"
    }

    if let int = any as? Int {
        return String(int)
    } else if let double = any as? Double {
        return String(double)
    } else if let float = any as? Float {
        return String(float)
    } else if let bool = any as? Bool {
        return String(bool)
    } else if let string = any as? String {
        return "\"\(string)\""
    }

    let indentedString: (String) -> String = {
        $0.components(separatedBy: CharacterSet.newlines).map { $0.isEmpty ? "" : "\r    \($0)" }.joined(separator: "")
    }

    let mirror = Mirror(reflecting: any)

    let properties = Array(mirror.children)

    guard let displayStyle = mirror.displayStyle else {
        return String(describing: any)
    }

    switch displayStyle {
    case .tuple:
        if properties.count == 0 { return "()" }

        var string = "("

        for (index, property) in properties.enumerated() {
            if property.label!.first! == "." {
                string += describe(property.value)
            } else {
                string += "\(property.label!): \(describe(property.value))"
            }

            string += (index < properties.count - 1 ? ", " : "")
        }

        return string + ")"
    case .collection, .set:
        if properties.count == 0 { return "[]" }

        var string = "["

        for (index, property) in properties.enumerated() {
            string += indentedString(describe(property.value) + (index < properties.count - 1 ? ",\r" : ""))
        }

        return string + "\r]"
    case .dictionary:
        if properties.count == 0 { return "[:]" }

        var string = "["

        for (index, property) in properties.enumerated() {
            let pair = Array(Mirror(reflecting: property.value).children)

            string += indentedString("\(describe(pair[0].value)): \(describe(pair[1].value))"
                + (index < properties.count - 1 ? ",\r" : ""))
        }

        return string + "\r]"
    case .enum:
        if let any = any as? CustomDebugStringConvertible {
            return any.debugDescription
        }

        if properties.count == 0 { return "\(mirror.subjectType)." + String(describing: any) }

        var string = "\(mirror.subjectType).\(properties.first!.label!)"

        let associatedValueString = describe(properties.first!.value)

        if associatedValueString.first! == "(" {
            string += associatedValueString
        } else {
            string += "(\(associatedValueString))"
        }

        return string
    case .struct, .class:
        if let any = any as? CustomDebugStringConvertible {
            return any.debugDescription
        }

        if properties.count == 0 { return String(describing: any) }

        var string = "<\(mirror.subjectType)"
        let object = any as AnyObject
        if displayStyle == .class {
            string += ": \(Unmanaged<AnyObject>.passUnretained(object).toOpaque())"
        }

        string += "> {"

        for (index, property) in properties.enumerated() {
            string += indentedString(
                "\(property.label!): \(describe(property.value))" + (index < properties.count - 1 ? ",\r" : "")
            )
        }

        return string + "\r}"
    case .optional: fatalError("deepUnwrap must have failed...")
    @unknown default:
        fatalError("")
    }
}

func deepUnwrap(_ any: Any) -> Any? {
    let mirror = Mirror(reflecting: any)

    if mirror.displayStyle != .optional {
        return any
    }

    if let child = mirror.children.first, child.label == "Some" {
        return deepUnwrap(child.value)
    }

    return nil
}
