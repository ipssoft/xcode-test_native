//
//  CompleterService.swift
//  test_native
//
//  Created by ihor on 10.11.2021.
//

import Foundation
import Combine
import MapKit

class CompleterService: NSObject, ObservableObject, MKLocalSearchCompleterDelegate{
    enum CompleterStatus: Equatable{
        case idle
        case noResult
        case isSearching
        case error(String)
        case result
    }

    @Published var queryFragment: String = ""
    @Published private(set) var status: CompleterStatus = .idle
    @Published private(set) var searchResults: [MKLocalSearchCompletion] = []
    
    private var qC: AnyCancellable?
    private let searchCompleter: MKLocalSearchCompleter!
    init(completerService: MKLocalSearchCompleter = MKLocalSearchCompleter()){
        self.searchCompleter = completerService
        super.init()
        self.searchCompleter.delegate = self
        self.searchCompleter.region = MKCoordinateRegion(.world)
        self.searchCompleter.resultTypes = MKLocalSearchCompleter.ResultType([.address])
        qC = $queryFragment
            .receive(on: DispatchQueue.main)
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main, options: nil)
            .sink(receiveValue: {fragment in
                self.status = .isSearching
                if !fragment.isEmpty{
                    self.searchCompleter.queryFragment = fragment
                }else{
                    self.status = .idle
                    self.searchResults = []
                }
            })
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchResults = searchCompleter.results //.filter({$0.subtitle == ""})
        self.status = searchCompleter.results.isEmpty ? .noResult: .result
        print(self.status)
        print(self.searchResults)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.status = .error(error.localizedDescription)
    }
    
}
