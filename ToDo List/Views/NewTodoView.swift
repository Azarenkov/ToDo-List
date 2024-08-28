//
//  NewTodoView.swift
//  ToDo List
//
//  Created by Алексей Азаренков on 24.08.2024.
//

import SwiftUI

struct NewTodoView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var discription = ""
    
    @ObservedObject var viewModel: ViewModel

    
    var body: some View {
        
        VStack(spacing: 30) {
            
            HStack {
                Text("New ToDo")
                    .font(.title)
                    .bold()
                Spacer()
            }
            
            VStack {
                HStack {
                    Text("Your Title")
                        .font(.title3)
                        .bold()
                    Spacer()
                }
                
                TextField("", text: $title)
                    .padding(.horizontal, 10)
                    .frame(height: 40)
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
                
                TextEditor(text: $discription)
                    .frame(height: 100)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray4), lineWidth: 2)
                    }
            }
            
            Button {
//                coreDataVM.addTodo(viewContext: viewContext, title: title, discription: discription)
                viewModel.addTodo(viewContext: viewContext, title: title, discription: discription)
                dismiss()
            } label: {
                Text("Save")
            }
            .buttonStyle(.bordered)

        }
        .padding()
        .padding(.top, 30)
    }
}

//#Preview {
//    NewTodoView()
//}
