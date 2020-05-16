//
//  ChordDiagramView.swift
//  ChordFinder
//
//  Created by Kyle Thomas on 05/05/2020.
//  Copyright © 2020 Kyle Thomas. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import UPCarouselFlowLayout

class ChordDetailViewController: UIViewController {
    let label = UILabel()
    let button = Button()
    let diagramView = ChordDiagramView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    var viewModel: ChordDetailViewModel
    
    init(name: String, type: ChordType) {
        self.viewModel = ChordDetailViewModel(name: name, type: type)
        super.init(nibName: nil, bundle: nil)
        
        initCollection()
        
        self.viewModel.setDelegate(newDelegate: self)
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.diagramView)
        guard let chord = self.viewModel.getChord() else { return }
        self.button.backgroundColor = UIColor.black
        self.button.setTitleColor(UIColor.white, for: .normal)
        self.button.setTitle("Practice", for: .normal)
        self.button.titleLabel?.font = UIFont(name: "Rockwell", size: 24)
        self.view.addSubview(self.button)
        self.button.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(100)
        }
        self.diagramView.chord = chord
        self.diagramView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(300)
            make.width.equalTo(300)
        }
        
        button.addTarget(self, action: #selector(learnChord), for: .touchUpInside)
        
    }
    
    @objc func learnChord() {
        guard let chord = self.viewModel.getChord() else { return }
        let vc = LearnChordViewController(chord: chord)
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func initCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.isPagingEnabled = true
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
//        self.view.addSubview(collection)
//        
//        collection.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.height.equalTo(100)
//            make.width.equalToSuperview()
//            make.centerX.equalToSuperview()
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension ChordDetailViewController: ViewModelDelegate {
    func didUpdate() {
        
    }
}

extension ChordDetailViewController: UICollectionViewDelegate {
    
    
}

extension ChordDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor.red
        
        return cell
    }
}
