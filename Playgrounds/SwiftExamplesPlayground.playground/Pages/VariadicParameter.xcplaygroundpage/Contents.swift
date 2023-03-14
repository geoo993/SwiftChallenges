//: [Previous](@previous)

import Foundation


public enum ExerciseConfigElement: String {
    case enableProgress
    case setProgressValue
    case showTopBar
    case hideTopBar
    case showBottomBar
    case hideBottomBar
    case showExitButton
    case showProgressBar
    case showHelpButton
}

public struct ExerciseConfig {
    public let elements: [ExerciseConfigElement]

    public init(_ elements: [ExerciseConfigElement] ) {
        self.elements = elements
    }
    public init(_ elements: ExerciseConfigElement...) {
        self.elements = elements
    }
    public init() {
        self.elements = []
    }
}

func update(with configElement: ExerciseConfigElement...) {
    let config = ExerciseConfig(configElement)
    config.elements.forEach {
        print($0.rawValue)
    }
}

update(with: .showExitButton, .enableProgress, .hideBottomBar)
