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
    
    @State var fetchItems: [Item] = []
    @State var showNewView = false

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
                .onDelete(perform: deleteItems)
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
                    DispatchQueue.main.async {
                        fetchTodosFromURL()
                    }
                }
            })
            Text("Select an item")
        }
        .sheet(isPresented: $showNewView, onDismiss: {
            withAnimation {
            }
        }) {
            NewTodoView()
                .presentationDetents([.height(CGFloat(375))])
        }
        


    }
    
    private func showNewSheet() {
        showNewView.toggle()
    }
    
    private func fetchTodosFromURL() {
        let fetchRequest = URLRequest(url: Link.todos.url)
        
        URLSession.shared.dataTask(with: fetchRequest) { (data, response, error) -> Void in
            if error != nil {
                print("Error in session")
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(String(describing: httpResponse?.statusCode))
                
                guard let safeData = data else { return }
                
                if let decodedQuery = try? JSONDecoder().decode(Query.self, from: safeData) {
                    var decodedTodos = decodedQuery.todos
                    for todo in decodedTodos {
                        addItem(itemData: todo)
                    }
                }
                
            }
        }
        .resume()
    }
    
    private func addItem(itemData: Todo) {
        let newItem = Item(context: viewContext)
        newItem.text = itemData.todo
        newItem.completed = itemData.completed
        newItem.timestamp = Date()
        do {
            try viewContext.save()
            shouldGetJson = false
        } catch let error{
            print(error)
        }

        
    }

    private func deleteItems(offsets: IndexSet) {
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

let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView()
}
