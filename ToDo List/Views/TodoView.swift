//
//  TodosView.swift
//  ToDo List
//
//  Created by Алексей Азаренков on 23.08.2024.
//

import SwiftUI

struct TodoView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State var todo: Item
    @State private var title: String
    @State private var text: String
    @State private var completed: Bool
    
    init(todo: Item) {
        self._todo = State(initialValue: todo)
        self._title = State(initialValue: todo.title ?? "")
        self._text = State(initialValue: todo.text ?? "")
        self._completed = State(initialValue: todo.completed)
    }
    
    var body: some View {
        VStack(spacing: 25) {
            VStack {
                HStack {
                    Text("Your Title")
                        .font(.title3)
                        .bold()
                    Spacer()
                }
                
                TextField("", text: $title)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray4), lineWidth: 2)
                    }
            }
            
            VStack {
                HStack {
                    Text("Your Description")
                        .font(.title3)
                        .bold()
                    Spacer()
                }
                
                TextEditor(text: $text)
                    .frame(height: 100)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray4), lineWidth: 2)
                    }
            }
            
            VStack {
                HStack {
                    Text("Creating Time")
                        .font(.title3)
                        .bold()
                    Spacer()
                }
                
                HStack {
                    Text(todo.timestamp ?? Date(timeIntervalSince1970: 0), formatter: itemFormatter)
                    Spacer()
                }
            }
                        
            VStack {
                Toggle(isOn: $completed) {
                    Text("Is Complited?")
                        .font(.title3)
                        .bold()
                }
            }
            Spacer()
        }
        .toolbar {
            ToolbarItem {
                Button {
                    updateData(entity: todo)
                    dismiss()
                } label: {
                    Text("Save")
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
    
    private func updateData(entity: Item) {
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
}

#Preview {
    ContentView()
}
