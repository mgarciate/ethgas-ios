//
//  HotViewModelProtocol.swift
//  ethgas-ios
//
//  Created by mgarciate on 13/5/22.
//

import Foundation

protocol HotViewModelProtocol: ObservableObject {
    var hotEntries: [IndexPath: HotEntry?] { get set }
    var typeSelected: Int { get set }
    
    func removeObserver()
    func fetchData()
    func valueSelected(_ value: Int)
}
