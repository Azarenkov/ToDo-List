//
//  Helpers.swift
//  ToDo List
//
//  Created by Алексей Азаренков on 23.08.2024.
//

import Foundation

enum Link {
    case todos
    
    var url: URL {
        switch self {
        case .todos:
            return URL(string: "https://dummyjson.com/todos")!
        }
    }
}
