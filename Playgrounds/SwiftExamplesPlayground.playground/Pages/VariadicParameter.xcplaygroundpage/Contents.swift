//: [Previous](@previous)

import Foundation


public enum ExerciseConfigElement {
    case enableProgress(Bool)
    case setProgressValue(Double)
    case showTopBar(animated: Bool)
    case hideTopBar(animated: Bool)
    case showBottomBar(animated: Bool)
    case hideBottomBar(animated: Bool)
    case showExitButton(Bool)
    case showProgressBar(Bool)
    case showHelpButton(Bool)
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
    print(config)
}
