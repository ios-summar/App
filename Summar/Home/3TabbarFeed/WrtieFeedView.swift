//
//  WrtieFeedView.swift
//  Summar
//
//  Created by mac on 2022/12/22.
//

import Foundation
import UIKit

class WriteFeedView : UIView, UITextViewDelegate {
    static let shared = WriteFeedView()
    
    private let cellReuseIdentifier = "FeedCollectionCell"
    let textViewPlaceHolder = "피드 내용은 2,000자 이내로 입력 가능합니다."
    
    let btnWidth : CGFloat = {
        var btnWidth = UIScreen.main.bounds.width
        return btnWidth - 50
    }()
    
    // 슬라이더
    let view1 = UIView()
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = true
        cv.layer.cornerRadius = 7
        return cv
    }()
    
    let view2 : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.textFieldColor
        return view
    }()
    
    lazy var view2TextView : UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.textFieldColor
        textView.font = .systemFont(ofSize: 20)
        textView.text = textViewPlaceHolder
        textView.textColor = .lightGray
        textView.delegate = self
        return textView
    }()
    
    let switch1 : UISwitch = {
        let sw = UISwitch()
        sw.isOn = true
        sw.onTintColor = .summarColor2
        return sw
    }()
    
    let switch2 : UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = .summarColor2
        return sw
    }()
    
    let leftLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.fontColor
        label.text = "댓글기능 켜기"
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    let rightLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.fontColor
        label.text = "피드 비공개하기"
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    let registerBtn : UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 3
        button.backgroundColor = .summarColor2
        button.setTitle("등록", for: .normal)
        return button
    }()
    
    let temporarySaveBtn : UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.fontColor, for: .normal)
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor.init(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        button.setTitle("임시저장", for: .normal)
        return button
    }()
    
    
    var arrProductPhotos = [
        UIImage(systemName: "doc"),
        UIImage(systemName: "doc.fill"),
        UIImage(systemName: "doc.circle"),
        UIImage(systemName: "square.and.arrow.up"),
        UIImage(systemName: "square.and.arrow.up.circle"),
        UIImage(systemName: "square.and.arrow.up.circle.fill"),
        UIImage(systemName: "square.and.arrow.up.trianglebadge.exclamationmark"),
        UIImage(systemName: "square.and.arrow.down")
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        _ = [view1, view2, switch1, switch2, leftLabel, rightLabel, registerBtn, temporarySaveBtn].map {
            addSubview($0)
//            $0.layer.borderWidth = 1
        }
        self.view1.addSubview(collectionView)
        self.view2.addSubview(view2TextView)
        
        view1.snp.makeConstraints{(make) in
            make.top.equalTo(30)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        collectionView.snp.makeConstraints{(make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        view2.snp.makeConstraints{(make) in
            make.top.equalTo(view1.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(btnWidth)
        }
        
        view2TextView.snp.makeConstraints{(make) in
            make.top.left.equalTo(20)
            make.bottom.right.equalTo(-20)
        }
        
        leftLabel.snp.makeConstraints{(make) in
            make.top.equalTo(view2.snp.bottom).offset(30)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.centerX).offset(-10)
            make.height.equalTo(switch1.snp.height)
        }
        
        switch1.snp.makeConstraints{(make) in
            make.centerY.equalTo(leftLabel)
            make.right.equalTo(leftLabel.snp.left).offset(-20)
        }
        
        rightLabel.snp.makeConstraints{(make) in
            make.centerY.equalTo(leftLabel)
            make.left.equalTo(switch2.snp.right).offset(20)
            make.height.equalTo(switch1.snp.height)
        }
        
        switch2.snp.makeConstraints{(make) in
            make.centerY.equalTo(leftLabel)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.centerX).offset(10)
            make.height.equalTo(switch1.snp.height)
        }
        
        registerBtn.snp.makeConstraints{(make) in
            make.left.equalTo(self.safeAreaLayoutGuide.snp.centerX).offset(10)
            make.bottom.equalTo(-30)
            make.right.equalTo(-20)
            make.height.equalTo(60)
        }
        
        temporarySaveBtn.snp.makeConstraints{(make) in
            make.right.equalTo(self.safeAreaLayoutGuide.snp.centerX).offset(-10)
            make.bottom.equalTo(-30)
            make.left.equalTo(20)
            make.height.equalTo(60)
        }
        
        
        imgSlider()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension WriteFeedView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - 이미지 슬라이더
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! FeedCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func imgSlider(){
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}
