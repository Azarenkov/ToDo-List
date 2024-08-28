//
//  CoreDataViewModel.swift
//  ToDo List
//
//  Created by Алексей Азаренков on 28.08.2024.
//

import Foundation
import SwiftUI
import CoreData

class CoreDataViewModel: ObservableObject {
    
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
