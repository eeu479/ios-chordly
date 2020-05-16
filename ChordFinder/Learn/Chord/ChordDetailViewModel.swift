//
//  ChordDetailViewModel.swift
//  ChordFinder
//
//  Created by Kyle Thomas on 08/05/2020.
//  Copyright © 2020 Kyle Thomas. All rights reserved.
//

import Foundation

enum ChordType: String {
    case major = ""
    case minor = "minor"
}

protocol ViewModelDelegate {
    func didUpdate()
}

class ChordDetailViewModel {
    var type: ChordType
    var name: String
    var delegate: ViewModelDelegate?
    
    init(name: String = "", type: ChordType = .major, delegate: ViewModelDelegate? = nil) {
        self.name = name
        self.type = type
        self.delegate = delegate
    }
    
    func getChord() -> Chord? {
        return ChordStore.shared.find(chordName: self.name, chordType: self.type)
    }
    
    func setDelegate(newDelegate: ViewModelDelegate) {
        self.delegate = newDelegate
    
    }
    
    func setType(newType: ChordType) {
        self.type = newType
        self.delegate?.didUpdate()
    }
}
