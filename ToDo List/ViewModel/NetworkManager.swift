//
//  ViewModel.swift
//  ToDo List
//
//  Created by Алексей Азаренков on 26.08.2024.
//

import Foundation
import SwiftUI

class NetworkManager: ObservableObject {
            
    func fetchTodosFromURL(completion: @escaping (Result<[Todo], Error>) -> Void) {
        let fetchRequest = URLRequest(url: Link.todos.url)
        
        URLSession.shared.dataTask(with: fetchRequest) { (data, response, error) -> Void in
            if let error = error {
                print("Error in session")
                completion(.failure(error))
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(String(describing: httpResponse?.statusCode))
                
                guard let safeData = data else {
                    if let error = error {
                        completion(.failure(error))
                    }
                    return
                }
                
                if let decodedQuery = try? JSONDecoder().decode(Query.self, from: safeData) {
                    let decodedTodos = decodedQuery.todos
                    completion(.success(decodedTodos))
                }
                
            }
        }
        .resume()
    }
}
