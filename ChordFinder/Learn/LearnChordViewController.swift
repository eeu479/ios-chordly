//
//  LearnChordViewController.swift
//  ChordFinder
//
//  Created by Kyle Thomas on 16/05/2020.
//  Copyright © 2020 Kyle Thomas. All rights reserved.
//

import Foundation
import UIKit
import SnapKit



class LearnChordViewController: UIViewController {
    let button = UIButton()
    var touchableView: LearnChordTouchableView?
    var chord: Chord
    init(chord: Chord) {
        self.chord = chord
        super.init(nibName: nil, bundle: nil)
        self.button.setTitle("Back", for: .normal)
        self.button.titleLabel?.font = UIFont(name: "Rockwell", size: 18)
        self.view.addSubview(self.button)
//        self.button.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        self.button.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(64)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(30)
            make.width.equalTo(90)
        }
        self.button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.touchableView = LearnChordTouchableView(frame: self.view.frame, chord: chord)
        self.view.addSubview(touchableView!)
        touchableView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
}


class LearnChordTouchableView: UIView {
    var touchViews = [UITouch:TouchSpotView]()
    var success: Bool = false
    var chord: Chord?
    
    convenience init(frame: CGRect, chord: Chord) {
        self.init(frame: frame)
        self.chord = chord
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        isMultipleTouchEnabled = true
        let imageView = UIImageView(frame: CGRect(x: (UIScreen.main.bounds.width / 8.7) * 3.1, y: 0, width: (UIScreen.main.bounds.width / 8.7) * 5.6, height: UIScreen.main.bounds.height))
        imageView.image = UIImage(named: "GuitarBG2")
        self.addSubview(imageView)
        imageView.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isMultipleTouchEnabled = true
    }
    
    
    func findChord(fingers: [CGPoint]) {
        guard let c = self.chord else { return }
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
        
        if chord == c.fingers {
            if(!self.success) {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                self.backgroundColor = UIColor.green
            }
            self.success = true
        } else {
            self.success = false
            self.backgroundColor = UIColor.black
        }
        
    }
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            createViewForTouch(touch: touch)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let view = viewForTouch(touch: touch)
            // Move the view to the new location.
            let newLocation = touch.location(in: self)
            view?.center = newLocation
            findChord(fingers: self.getTouches())
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            removeViewForTouch(touch: touch)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            removeViewForTouch(touch: touch)
        }
    }
    
    
    func createViewForTouch( touch : UITouch ) {
        let newView = TouchSpotView()
        newView.bounds = CGRect(x: 0, y: 0, width: 1, height: 1)
        newView.center = touch.location(in: self)
        
        // Add the view and animate it to a new size.
        addSubview(newView)
        UIView.animate(withDuration: 0.1) {
            newView.bounds.size = CGSize(width: 50, height: 50)
        }
        
        // Save the views internally
        touchViews[touch] = newView
    }
    
    func viewForTouch (touch : UITouch) -> TouchSpotView? {
        return touchViews[touch]
    }
    
    func getTouches() -> [CGPoint] {
        return touchViews.map { view in
            return view.value.center
            
        }
    }
    
    func removeViewForTouch (touch : UITouch ) {
        if let view = touchViews[touch] {
            view.removeFromSuperview()
            touchViews.removeValue(forKey: touch)
        }
    }
}
