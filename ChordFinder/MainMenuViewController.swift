//
//  MainMenuViewController.swift
//  ChordFinder
//
//  Created by Kyle Thomas on 04/05/2020.
//  Copyright © 2020 Kyle Thomas. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class Button: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard var tempFrame = self.titleLabel?.frame else { return }
        tempFrame.size.height = self.bounds.size.height;
        tempFrame.origin.y = self.titleEdgeInsets.top + 5;
        self.titleLabel?.frame = tempFrame;
    }
}


class MainMenuViewController: UIViewController {
    let backgroundImage = UIImageView()
    let titleLabel = UILabel()
    let button = Button()
    let editChordsButton = Button()
    let titleContainer = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.alpha = 0
        self.view.backgroundColor = UIColor.black
        self.titleLabel.text = "CHORDLY"
        self.titleLabel.font = UIFont(name: "Rockwell", size: 60)
        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = UIColor.white
        
        self.view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.centerX.equalTo(UIScreen.main.bounds.width / 2)
            make.width.equalTo((UIScreen.main.bounds.width / 8.7) * 5.6)
        }
        backgroundImage.image = UIImage(named: "GuitarBG2")
        
        self.view.addSubview(self.titleContainer)
        self.titleContainer.backgroundColor = UIColor.black
        self.titleContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(150)
        }
        self.titleContainer.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(20)
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(100)
        }
        addButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 1
            
        })
    }
    
    func addButtons() {
        button.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("Play", for: .normal)
        self.view.addSubview(button)
        
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(start), for: .touchUpInside)
        
        
        editChordsButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        editChordsButton.setTitleColor(UIColor.black, for: .normal)
        editChordsButton.setTitle("Learn", for: .normal)
        self.view.addSubview(editChordsButton)
        
        editChordsButton.layer.cornerRadius = 20
        editChordsButton.clipsToBounds = true
        editChordsButton.addTarget(self, action: #selector(editChords), for: .touchUpInside)
        
        button.titleLabel?.font = UIFont(name: "Rockwell", size: 44)
        editChordsButton.titleLabel?.font = UIFont(name: "Rockwell", size: 44)
        
        
        button.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(230)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        editChordsButton.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(230)
            make.top.equalTo(self.button.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func editChords() {
        let editChords = ChordViewController()
        let navigation = UINavigationController(rootViewController: editChords)
        navigation.modalPresentationStyle = .fullScreen
        editChords.title = "Learn"
        editChords.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeEdit))
        self.present(navigation, animated: true, completion: nil)
    }
    
    @objc func closeEdit() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func start() {
        UIView.animate(withDuration: 0.5, animations: {
            self.backgroundImage.snp.updateConstraints { update in
                update.centerX.equalTo(UIScreen.main.bounds.width - ((UIScreen.main.bounds.width / 8.7) * 5.6) / 2)
            }
            self.view.layoutIfNeeded()
        }) { complete in
            if(complete) {
                self.present(PlayViewController(), animated: false, completion: nil)
            }
        }
    }
}
