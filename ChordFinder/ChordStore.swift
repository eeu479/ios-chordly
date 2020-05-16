//
//  ChordStore.swift
//  ChordFinder
//
//  Created by Kyle Thomas on 05/05/2020.
//  Copyright © 2020 Kyle Thomas. All rights reserved.
//

import Foundation

class ChordStore {
    static var shared = ChordStore()
    
    init() {
        self.chords.append(contentsOf: [
            Chord(name: "A", fingers: ["E": 0, "A": 0, "D": 2, "G": 2, "B": 2, "e": 0], speech: "Eh"),
            Chord(name: "Aminor", fingers: ["E": 0, "A": 0, "D": 2, "G": 2, "B": 1, "e": 0], speech: "Eh Minor"),
            Chord(name: "B", fingers: ["E": 0, "A": 2, "D": 4, "G": 4, "B": 4, "e": 0], speech: "Bee"),
            Chord(name: "C", fingers: ["E": 0, "A": 3, "D": 2, "G": 0, "B": 1, "e": 0], speech: "See"),
            Chord(name: "D", fingers: ["E": 0, "A": 0, "D": 0, "G": 2, "B": 3, "e": 2], speech: "Dee"),
            Chord(name: "E", fingers: ["E": 0, "A": 2, "D": 2, "G": 1, "B": 0, "e": 0], speech: "Ee"),
            Chord(name: "G", fingers: ["E": 3, "A": 2, "D": 0, "G": 0, "B": 0, "e": 3], speech: "Jee"),
        ])
    }
    
    func add(chord: Chord) {
        chords.append(chord)
    }
    
    
    func getBaseChords() -> [Chord] {
        return chords.filter( { chord in
            return chord.name.count == 1
        })
    }
    
    func find(chordName: String, chordType: ChordType) -> Chord? {
        var results = self.chords.filter( { chord in
            return chord.name == chordName + chordType.rawValue
        })
        return results.first
    }
    
    func remove(chordName: String) {
        chords.removeAll(where: { c in
            return chordName == c.name
        })
    }
    
    var chords: [Chord] = []
}
