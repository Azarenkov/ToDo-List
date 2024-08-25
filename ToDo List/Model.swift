//
//  Model.swift
//  ToDo List
//
//  Created by Алексей Азаренков on 23.08.2024.
//

import Foundation

struct Todo: Decodable, Hashable {
    let id: Int
    let todo: String
    let completed: Bool
}

struct Query: Decodable {
    let todos: [Todo]
}
