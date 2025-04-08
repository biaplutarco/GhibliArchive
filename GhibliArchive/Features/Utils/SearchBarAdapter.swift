//
//  SearchBarAdapter.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import UIKit
import Combine

final class SearchBarAdapter {
    static func bindSearchTextPublisher(
        from searchBar: UISearchBar,
        to publisher: CurrentValueSubject<String, Never>,
        storeIn cancellables: inout Set<AnyCancellable>
    ) {
        NotificationCenter.default.publisher(
            for: UISearchTextField.textDidChangeNotification,
            object: searchBar.searchTextField
        )
        .compactMap { ($0.object as? UISearchTextField)?.text }
        .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
        .removeDuplicates()
        .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        .sink { publisher.send($0) }
        .store(in: &cancellables)
    }
}
