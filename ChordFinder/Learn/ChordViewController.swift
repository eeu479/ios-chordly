//
//  ChordViewController.swift
//  ChordFinder
//
//  Created by Kyle Thomas on 05/05/2020.
//  Copyright © 2020 Kyle Thomas. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ChordViewController: UIViewController {
    
    let collection: UICollectionView
    let addButton = Button()
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        self.collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.collection)
        self.collection.backgroundColor = UIColor.white
        
        self.collection.register(ChordViewCell.self, forCellWithReuseIdentifier: "ChordViewCell")
        self.collection.delegate = self
        self.collection.dataSource = self
        
        self.addButton.backgroundColor = UIColor.black
        self.addButton.setTitleColor(UIColor.white, for: .normal)
        self.addButton.setTitle("Add Chord", for: .normal)
        self.addButton.titleLabel?.font = UIFont(name: "Rockwell", size: 24)
        self.view.addSubview(self.addButton)
        self.addButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(100)
        }
        self.collection.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(self.addButton.snp.top)
        }
    }
}

extension ChordViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chord = ChordStore.shared.getBaseChords()[indexPath.item]
        let vc = ChordDetailViewController(name: chord.name, type: .major)
        vc.title = chord.name
        self.navigationController?.pushViewController(vc, animated: true)

    }
}

extension ChordViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChordViewCell", for: indexPath) as? ChordViewCell else { return UICollectionViewCell() }
        cell.nameLabel.text = ChordStore.shared.getBaseChords()[indexPath.item].name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ChordStore.shared.getBaseChords().count
    }
}


class ChordViewCell: UICollectionViewCell {
    let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        self.setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        frame.size.width = UIScreen.main.bounds.width
        layoutAttributes.frame = frame
        return layoutAttributes
    }
    
    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = true
        let backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
        backgroundImage.image = UIImage(named: "Wood")
        self.contentView.addSubview(backgroundImage)
        NSLayoutConstraint(item: backgroundImage, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: backgroundImage, attribute: .left, relatedBy: .equal, toItem: self.contentView, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: backgroundImage, attribute: .right, relatedBy: .equal, toItem: self.contentView, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: backgroundImage, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: backgroundImage, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100).isActive = true

        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalToSuperview()
        }
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont(name: "Rockwell", size: 124)
        nameLabel.textAlignment = .center
    }
}


class NestedCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AddChord: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
