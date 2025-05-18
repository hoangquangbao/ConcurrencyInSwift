//
//  DoCatchTryThrowsBootcamp.swift
//  ConcurrencyInSwift
//
//  Created by Bao Hoang on 11/5/25.
//

import SwiftUI

class DoCatchTryThrowsBootcampDataManager {
    
    let isActive: Bool = true
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("New Text!", nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("New Text!")
        } else {
            return .failure(URLError(.badURL))
        }
    }
    
    func getTitle3() throws -> String {
        if isActive {
            return "New Text!"
        } else {
            throw URLError(.badURL)
        }
    }
    
    func getTitle4() throws -> String {
        throw URLError(.badURL)
    }
}

class DoCatchTryThrowsBootcampViewModel: ObservableObject {
    @Published var text = "Starting text..."
    @Published var text2 = "Starting text2..."
    @Published var text3 = "Starting text3..."

    let dataManager = DoCatchTryThrowsBootcampDataManager()
    
    func fetchTitle() {
        let retVal = dataManager.getTitle()
        if let newText = retVal.title {
            text = newText
        } else if let error = retVal.error {
            text = error.localizedDescription
        }
    }
    
    func fetchTitle2() {
        let retVal2 = dataManager.getTitle2()
        switch retVal2 {
        case .success(let newText):
            text2 = newText
        case .failure(let error):
            text2 = error.localizedDescription
        }
    }
    
    func fetchTitle3() {
        do {
            text3 =  try dataManager.getTitle4()
            //TRY: if one of these tries fails then immediately go into the catch block
            text3 = try dataManager.getTitle3()
        } catch {
            text3 = error.localizedDescription
        }
        
        do {
            let newText =  try? dataManager.getTitle4()
            if let newText = newText {
                text3 = newText
            }
            //TRY as option: if one of these tries fails, still execute
            text3 = try dataManager.getTitle3()
        } catch {
            text3 = error.localizedDescription
        }
    }
}

struct DoCatchTryThrowsBootcamp: View {
    
    @StateObject var viewModel = DoCatchTryThrowsBootcampViewModel()
    
    var body: some View {
        CustomTextView(text: viewModel.text) {
            viewModel.fetchTitle()
        }
        
        CustomTextView(text: viewModel.text2) {
            viewModel.fetchTitle2()
        }
        
        CustomTextView(text: viewModel.text3) {
            viewModel.fetchTitle3()
        }
    }
}

struct CustomTextView: View {
    var text: String
    var action: () -> Void
    
    var body: some View {
        Text(text)
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .frame(width: 200, height: 100)
            .background(.blue)
            .cornerRadius(10)
            .onTapGesture(perform: action)
    }
}

#Preview {
    DoCatchTryThrowsBootcamp()
}
