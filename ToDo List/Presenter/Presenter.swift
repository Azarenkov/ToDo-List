//
//  Presenter.swift
//  ToDo List
//
//  Created by Алексей Азаренков on 28.08.2024.
//

import Foundation
import CoreData
import SwiftUI

protocol PresenterProtocol: AnyObject {
//    func didFetchTodosFromUrlAndSave(viewContext: NSManagedObjectContext)
////    func didAddItem()
//    func didUpdateData(entity: Item, viewContext: NSManagedObjectContext, title: String, text: String, completed: Bool)
//    func didAddTodo(viewContext: NSManagedObjectContext, title: String, discription: String)
//    func didDeleteItems(offsets: IndexSet, items: FetchedResults<Item>, viewContext: NSManagedObjectContext)
//    func didGetDataWithError(error: String, showAlert: Bool) -> (error: String, showAlert: Bool)
}

protocol ViewProtocol: AnyObject {
    
}


class Presenter: PresenterProtocol {
       
    weak var view: ViewProtocol?
    
    var interactor: InteractorProtocol?
        
//  MARK: - Получение данных по Rest API и сохранение в CoreData
    func fetchTodosFromUrlAndSave(viewContext: NSManagedObjectContext, completion: @escaping (String, Bool) -> Void) {
        interactor?.fetchTodosFromURL(completion: { result in
            switch result {
            case .success(let todos):
                print(todos)
                for todo in todos {
                    self.interactor?.addItem(itemData: todo, viewContext: viewContext)
                    UserDefaults.standard.set(false, forKey: "shouldGetJson")
                }
            case .failure(let error):
                print(error)
                completion("\(error.localizedDescription)", true)
            }
        })
    }
    
//  MARK: - Изменение данных в CoreData при обращении из View
    func updateData(entity: Item, viewContext: NSManagedObjectContext, title: String, text: String, completed: Bool) {
        interactor?.updateData(entity: entity, viewContext: viewContext, title: title, text: text, completed: completed)
    }
    
//  MARK: - Создание данных в CoreData при обращении из View
    func addTodo(viewContext: NSManagedObjectContext, title: String, discription: String) {
        interactor?.addTodo(viewContext: viewContext, title: title, discription: discription)
    }
    
//  MARK: - Удаление данных в CoreData при обращении из View
    func deleteItems(offsets: IndexSet, items: FetchedResults<Item>, viewContext: NSManagedObjectContext) {
        interactor?.deleteItems(offsets: offsets, items: items, viewContext: viewContext)
    }
}
