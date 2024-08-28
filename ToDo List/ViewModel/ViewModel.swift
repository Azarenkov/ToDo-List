//
//  ContentViewModel.swift
//  ToDo List
//
//  Created by Алексей Азаренков on 28.08.2024.
//

import Foundation
import CoreData
import SwiftUI

class ViewModel: ObservableObject {
    
    var presenter: Presenter?
    
    func fetchTodosFromUrlAndSave(viewContext: NSManagedObjectContext, completion: @escaping (String, Bool) -> Void) {
        DispatchQueue.main.async {
            self.presenter?.fetchTodosFromUrlAndSave(viewContext: viewContext) { error, showAlert in
                completion(error, showAlert)
            }
        }
    }
    
    func updateData(entity: Item, viewContext: NSManagedObjectContext, title: String, text: String, completed: Bool) {
        presenter?.updateData(entity: entity, viewContext: viewContext, title: title, text: text, completed: completed)
    }
    
    func addTodo(viewContext: NSManagedObjectContext, title: String, discription: String) {
        presenter?.addTodo(viewContext: viewContext, title: title, discription: discription)
    }
    
    func deleteItems(offsets: IndexSet, items: FetchedResults<Item>, viewContext: NSManagedObjectContext) {
        presenter?.deleteItems(offsets: offsets, items: items, viewContext: viewContext)
    }
}
