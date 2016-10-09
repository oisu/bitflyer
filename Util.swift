//
//  Util.swift
//  bitFlyer
//
//  Created by Hiroaki Miura on 2016/10/07.
//  Copyright © 2016 oisu. All rights reserved.
//

import Foundation
import SwiftyBeaver
import SwiftMoment

class Util {
    private init() {}

    struct Date {
        static func getTime(dateString: String, format: String) -> String? {
            if let m = moment(dateString, dateFormat: format) {
                return m.format("h:mm:ss")
            }
            return nil
        }
    }
}

typealias Logger = SwiftyBeaver

extension Logger {
    class func initWithConsole() {
        let console = ConsoleDestination()
        addDestination(console)
    }
    class func print(_ message: Any,
                     level: Level = .debug,
                     _ path: String = #file,
                     _ function: String = #function,
                     line: Int = #line) {

        switch message {

        case is Error:
            let error = message as? Error
            SwiftyBeaver.error("\n[😢Error] \n\n\(error?.localizedDescription)\n", path, function, line: line)

        case is String:
            SwiftyBeaver.debug(message, path, function, line: line)

        default:
            SwiftyBeaver.debug("\n[🚽Dump] \n", path, function, line: line)
            _ = Swift.dump(message)
            Swift.print("")
        }
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }

    func localizedWithComment(comment: String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
    }
}
