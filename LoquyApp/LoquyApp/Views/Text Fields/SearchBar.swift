//
//  SearchBar.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 7/19/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import SwiftUI

// credit: https://stackoverflow.com/users/13303419/nicolas-mandica

struct SearchBar: UIViewRepresentable {

    @Binding var text: String
    var onTextChanged: (String) -> Void
    @Binding var isEditing: Bool
    
    
    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String
        var onTextChanged: (String) -> Void

        @Binding var isEditing: Bool
        
        init(text: Binding<String>, onTextChanged: @escaping (String) -> Void, isEditing: Binding<Bool>) {
            _text = text
            self.onTextChanged = onTextChanged
            _isEditing = isEditing
        }

        // Show cancel button when the user begins editing the search text
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = true
            isEditing = true
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
            onTextChanged(text)
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            text = ""
            searchBar.showsCancelButton = false
            searchBar.endEditing(true)
            isEditing = false
            // Send back empty string text to search view, trigger self.model.searchResults.removeAll()
            onTextChanged(text)
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text, onTextChanged: onTextChanged, isEditing: $isEditing)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search for podcasts"
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        searchBar.showsCancelButton = false
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

