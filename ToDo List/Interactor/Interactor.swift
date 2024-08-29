//
//  Interractor.swift
//  ToDo List
//
//  Created by Алексей Азаренков on 28.08.2024.
//

import Foundation
import CoreData
import SwiftUI

protocol InteractorProtocol: AnyObject {
    func fetchTodosFromURL(completion: @escaping (Result<[Todo], Error>) -> Void)
    func addItem(itemData: Todo, viewContext: NSManagedObjectContext)
    func updateData(entity: Item, viewContext: NSManagedObjectContext, title: String, text: String, completed: Bool)
    func addTodo(viewContext: NSManagedObjectContext, title: String, discription: String)
    func deleteItems(offsets: IndexSet, items: FetchedResults<Item>, viewContext: NSManagedObjectContext)
}

class Interactor: InteractorProtocol {
    
    weak var presentor: PresenterProtocol?
    
// MARK: - Получение данных при помоши URLSession
    func fetchTodosFromURL(completion: @escaping (Result<[Todo], any Error>) -> Void) {
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
    
// MARK: - Сохранение полученных данных из Rest API в CoreData
    func addItem(itemData: Todo, viewContext: NSManagedObjectContext) {
        let newItem = Item(context: viewContext)
        newItem.text = itemData.todo
        newItem.completed = itemData.completed
        newItem.timestamp = Date()
        do {
            try viewContext.save()
        } catch let error{
            print(error)
        }
    }

//  MARK: - Изменение данных в CoreData
    func updateData(entity: Item, viewContext: NSManagedObjectContext, title: String, text: String, completed: Bool) {
        let id = entity.objectID
        do {
            if let item = try viewContext.existingObject(with: id) as? Item {
                item.title = title
                item.text = text
                item.completed = completed
                try viewContext.save()
            }
        } catch let error {
            print(error)
        }
    }

//  MARK: - Создание данных в CoreData
    func addTodo(viewContext: NSManagedObjectContext, title: String, discription: String) {
        let newItem = Item(context: viewContext)
        newItem.title = title
        newItem.text = discription
        newItem.timestamp = Date()
        newItem.completed = false
        
            
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
//  MARK: - Удаление данных в CoreData
    func deleteItems(offsets: IndexSet, items: FetchedResults<Item>, viewContext: NSManagedObjectContext) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
