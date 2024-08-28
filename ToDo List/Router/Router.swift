//
//  Router.swift
//  ToDo List
//
//  Created by Алексей Азаренков on 28.08.2024.
//

import SwiftUI

protocol RouterProtocol {
    associatedtype ContentView: View
    static func createModule() -> ContentView
}

class Router: RouterProtocol {
    
    static func createModule() -> some View {
        let viewModel = ViewModel()
        let view = ToListView(viewModel: viewModel)
        let interactor = Interactor()
        let presenter = Presenter()
        
        viewModel.presenter = presenter
        presenter.interactor = interactor
        interactor.presentor = presenter
        
        return view
    }
}
