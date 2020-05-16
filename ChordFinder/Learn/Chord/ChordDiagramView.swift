//
//  ChordDiagramView.swift
//  ChordFinder
//
//  Created by Kyle Thomas on 08/05/2020.
//  Copyright © 2020 Kyle Thomas. All rights reserved.
//

import Foundation
import UIKit

class ChordDiagramView: UIView {
    
    var chord: Chord? {
        didSet {
            self.addFingers()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    var imageBackground: UIImageView = UIImageView()
    var fingerView: UIView = UIView()
    func setupView() {
        self.imageBackground.image = UIImage(named: "ChordDiagramBG")
        self.addSubview(self.imageBackground)
        self.imageBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.addSubview(self.fingerView)
        self.fingerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.fingerView.backgroundColor = UIColor.clear
    }
    func addFingers() {
        let width: CGFloat = self.frame.width
        let height: CGFloat = self.frame.height
        self.fingerView.subviews.forEach({ subview in
            subview.removeFromSuperview()
        })
        
        guard let c = self.chord else { return }
        for finger in c.fingers {
            if finger.value != 0 {
                var x: CGFloat = 0
                switch finger.key {
                case "E":
                    x = (width / 7)
                case "A":
                    x = ((width / 7) * 2)
                case "D":
                    x = ((width / 7) * 3)
                case "G":
                    x = ((width / 7) * 4)
                case "B":
                    x = ((width / 7) * 5)
                case "e":
                    x = ((width / 7) * 6)
                default:
                    x = 0
                }
                
                let y: CGFloat = ((height / 4) * CGFloat(finger.value)) - (height / 8)
                
                createView(point: CGPoint(x: x, y: y))
            }
        }
    }
    
    func createView( point : CGPoint ) {
       let newView = TouchSpotView()
       newView.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
       newView.center = point
     
       // Add the view and animate it to a new size.
       addSubview(newView)
    }
}


