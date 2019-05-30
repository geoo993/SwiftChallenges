
import protocol ViperCore.Then
import XCGLogger
extension XCGLogger: Then {}

let log = XCGLogger.default

let printlog = XCGLogger.default.then {
    $0.setup(showLogIdentifier: false, showFunctionName: true, showThreadName: false, showLevel: false,
             showFileNames: true, showLineNumbers: true, showDate: true)
    $0.dateFormatter = DateFormatter().then {
        $0.dateFormat = "HH:mm:ss.SSS"
    }
}

extension XCGLogger {
    // swiftlint:disable:next prefer_log
    func print(functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line,
               _ value: Any...) {
        printlog.info(functionName, fileName: fileName, lineNumber: lineNumber,
                      closure: { value.map { "\($0)" }.joined(separator: " ") })
    }

    func error(functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line,
               _ value: Any...) {
        let message = value.map { "\($0)" }.joined(separator: " ")
        log.error(functionName, fileName: fileName, lineNumber: lineNumber,
                  closure: { message })
        assertionFailure(message)
    }

    func warning(functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line,
                 _ value: Any...) {
        log.warning(functionName, fileName: fileName, lineNumber: lineNumber,
                    closure: { value.map { "\($0)" }.joined(separator: " ") })
    }

    func info(functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line,
              _ value: Any...) {
        log.info(functionName, fileName: fileName, lineNumber: lineNumber,
                 closure: { value.map { "\($0)" }.joined(separator: " ") })
    }

    func debug(functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line,
               _ value: Any...) {
        log.debug(functionName, fileName: fileName, lineNumber: lineNumber,
                  closure: { value.map { "\($0)" }.joined(separator: " ") })
    }

    func verbose(functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line,
                 _ value: Any...) {
        log.verbose(functionName, fileName: fileName, lineNumber: lineNumber,
                    closure: { value.map { "\($0)" }.joined(separator: " ") })
    }
}
