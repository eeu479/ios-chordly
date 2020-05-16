//
//  PlayViewController.swift
//  ChordFinder
//
//  Created by Kyle Thomas on 29/04/2020.
//  Copyright © 2020 Kyle Thomas. All rights reserved.
//

import UIKit
import AVFoundation

struct Chord {
    var name: String
    var fingers: [String: Int]
    var speech: String
    
    init(name: String, fingers: [String: Int], speech: String = "") {
        self.name = name
        self.fingers = fingers
        self.speech = speech
    }
}


class PlayViewController: UIViewController {
    var touchableView: PlayTouchableView?
    var findButton = UIButton(frame: CGRect(x: 16, y: UIScreen.main.bounds.height - 200, width: 100, height: 100))
    var chordLabel = UILabel(frame: CGRect(x: 16, y: UIScreen.main.bounds.height - 400, width: 100, height: 100))
    
    let backButton = UIButton()
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
        self.findButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        self.chordLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        self.backButton.setTitle("Go Back", for: .normal)
        self.backButton.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(self.backButton)
        
        self.backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        self.backButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        self.backButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.touchableView = PlayTouchableView(frame: self.view.frame)
        // Do any additional setup after loading the view.
        guard let tv = self.touchableView else { return }
        self.view.addSubview(tv)
        self.becomeFirstResponder()
        self.view.addSubview(self.findButton)
        self.findButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        self.findButton.setTitle("FIND", for: .normal)
        self.findButton.backgroundColor = UIColor.white
        self.findButton.setTitleColor(UIColor.black, for: .normal)
        self.chordLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        self.chordLabel.textColor = UIColor.white
        
        self.view.addSubview(self.chordLabel)
    }
        
//    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
//        if motion == .motionShake {
//            if let t = self.touchableView?.getTouches() as? [CGPoint] {
//                findChord(fingers: t)
//            }
//
//
//        }
//    }
    
    @objc func buttonPressed() {
        if let t = self.touchableView?.getTouches() {
            findChord(fingers: t)
        }
    }
    
    func findChord(fingers: [CGPoint]) {
        
        var played: [String: Int] = [:]

        var _ = fingers.forEach({ (finger) in
            let string = getString(input: finger.x)
            let fret = getFret(input: finger.y)
            
            played[string] = fret
        })

        let  strings = ["E", "A", "D", "G", "B", "e"]

        var chord: [String: Int] = [:]
        var _ = strings.forEach({ (string) in
            if let p = played[string] {
                chord[string] = p
            } else {
                chord[string] = 0
            }
        })


        var found = false
        for c in ChordStore.shared.chords {
            if c.fingers == chord {
                found = true
                print("FINAL CHORD IS: ", c.name)
                let utterance = AVSpeechUtterance(string: " \(c.speech) ")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                utterance.rate = 0.3

                let synthesizer = AVSpeechSynthesizer()
                synthesizer.speak(utterance)
                self.chordLabel.text = c.name
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            } else {
                if !found {
                    print("Couldn't find chord, please try again.")
                    self.chordLabel.text = "N/A"
                }
            }
        }
    }


//    var newChords: [Chord] = [
//        Chord(name: "A", fingers: ["E": 0, "A": 0, "D": 2, "G": 2, "B": 2, "e": 0], speech: "Eh"),
//        Chord(name: "B", fingers: ["E": 0, "A": 2, "D": 4, "G": 4, "B": 4, "e": 3], speech: "Bee"),
//        Chord(name: "C", fingers: ["E": 0, "A": 3, "D": 2, "G": 0, "B": 1, "e": 0], speech: "See"),
//        Chord(name: "D", fingers: ["E": 0, "A": 0, "D": 0, "G": 3, "B": 2, "e": 3], speech: "Dee"),
//        Chord(name: "E", fingers: ["E": 0, "A": 2, "D": 2, "G": 1, "B": 0, "e": 0], speech: "Ee"),
//        Chord(name: "G", fingers: ["E": 3, "A": 2, "D": 0, "G": 0, "B": 0, "e": 3], speech: "Jee"),
//    ]

    var input = ["E": 1, "A": 3, "D": 2, "G": 1, "B": 1, "a": 1]


    // 6 strings

    //var stringSize = width / 6

    //Frets. 4 frets. height / 6 (only use 4)


    //var fingers: [CGPoint] = [CGPoint(x: 271.0, y: 124.66665649414062), CGPoint(x: 164.66665649414062, y: 228.0), CGPoint(x: 96.33332824707031, y: 356.6666564941406)]
    var width: CGFloat = UIScreen.main.bounds.width
    var height: CGFloat = UIScreen.main.bounds.height
    var widthMultiplyer: CGFloat = 0.1066
    var heightMultiplyer: CGFloat = 0.229
    func getString(input: CGFloat) -> String {
        switch input {
        case width - (width * (widthMultiplyer * 6)) ... width - (width * (widthMultiplyer * 5)):
            return "E"
        case width - (width * (widthMultiplyer * 5)) ... width - (width * (widthMultiplyer * 4)):
            return "A"
        case width - (width * (widthMultiplyer * 4)) ... width - (width * (widthMultiplyer * 3)):
            return "D"
        case width - (width * (widthMultiplyer * 3)) ... width - (width * (widthMultiplyer * 2)):
            return "G"
        case width - (width * (widthMultiplyer * 2)) ... width - (width * (widthMultiplyer)):
            return "B"
        case width - (width * (widthMultiplyer)) ... width:
            return "e"
        default: return ""
        }
    }

    func getFret(input: CGFloat) -> Int {
        switch input {
        case 0 ... (height * (heightMultiplyer)):
            return 1
        case (height * (heightMultiplyer)) ... (height * (heightMultiplyer * 2)):
            return 2
        case (height * (heightMultiplyer * 2)) ... (height * (heightMultiplyer * 3)):
            return 3
        case (height * (heightMultiplyer * 3)) ... (height * (heightMultiplyer * 4)):
            return 4
        default: return 0
        }
    }

    

}

