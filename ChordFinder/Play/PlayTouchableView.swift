//
//  TouchableView.swift
//  ChordFinder
//
//  Created by Kyle Thomas on 29/04/2020.
//  Copyright © 2020 Kyle Thomas. All rights reserved.
//

import Foundation
import UIKit

class SquareView: UIView {
    override init(frame: CGRect) {
       super.init(frame: frame)
       isUserInteractionEnabled = false
    }
    
    func lightUp() {
        self.backgroundColor = UIColor.red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PlayTouchableView: UIView {
  var touchViews = [UITouch:TouchSpotView]()
    
    
  override init(frame: CGRect) {
     super.init(frame: frame)
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
     }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
     for touch in touches {
        removeViewForTouch(touch: touch)
     }
    for view in self.subviews {
        if view as? UIImageView == nil {
            view.removeFromSuperview()
        }
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

class TouchSpotView : UIView {
   override init(frame: CGRect) {
      super.init(frame: frame)
      backgroundColor = UIColor.lightGray
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   // Update the corner radius when the bounds change.
   override var bounds: CGRect {
      get { return super.bounds }
      set(newBounds) {
         super.bounds = newBounds
         layer.cornerRadius = newBounds.size.width / 2.0
      }
   }
}
