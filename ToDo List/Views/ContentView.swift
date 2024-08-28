//
//  ContentView.swift
//  ToDo List
//
//  Created by Алексей Азаренков on 23.08.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)], animation: .default)
    private var items: FetchedResults<Item>
    
    @AppStorage("shouldGetJson") var shouldGetJson = true
    
    @State private var showNewView = false
    @State private var showAlert = false
    @State private var errorMessage = ""

    @ObservedObject var networkManager = NetworkManager()
    @ObservedObject var coreDataVM = CoreDataViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { todo in
                    HStack {
                        Image(systemName: todo.completed ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.blue)
                        
                        NavigationLink {
                            TodoView(todo: todo)
                            
                        } label: {
                            VStack(alignment: .leading) {
                                Text(todo.title ?? "")
                                Text(todo.timestamp ?? Date(timeIntervalSince1970: 0), formatter: itemFormatter)
                                    .font(.caption2)
                            }
                        }
                    }
                    
                }
                .onDelete(perform: { indexSet in
                    coreDataVM.deleteItems(offsets: indexSet, items: items, viewContext: viewContext)
                })
            }

            .navigationTitle("ToDo List")
        
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: showNewSheet) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .onAppear(perform: {
                if shouldGetJson {
//                    DispatchQueue.main.async {
//                        networkManager.fetchTodosFromURL { result in
//                            switch result {
//                            case .success(let todos):
//                                for todo in todos {
//                                    addItem(itemData: todo)
//                                }
//                            case.failure(let error):
//                                print(error)
//                                errorMessage = ("\(error)")
//                                showAlert.toggle()
//                            }
//                        }
//                    }
                    DispatchQueue.main.async {
                        networkManager.fetchTodosFromURL { result in
                            switch result {
                            case .success(let todos):
                                for todo in todos {
                                    coreDataVM.addItem(itemData: todo, viewContext: viewContext)
                                    shouldGetJson = false
                                }
                            case.failure(let error):
                                print(error)
                                errorMessage = ("\(error)")
                                showAlert.toggle()
                            }
                        }
                    }
                }
            })
            Text("Select an item")
        }
        .sheet(isPresented: $showNewView, content: {
            NewTodoView()
                .presentationDetents([.height(CGFloat(375))])
        })
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }

    }
    
    private func showNewSheet() {
        showNewView.toggle()
    }
        
}

let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView()
}
