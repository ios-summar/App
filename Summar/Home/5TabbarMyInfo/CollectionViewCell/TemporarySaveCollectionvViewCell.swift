//
//  TemporarySaveCollectionvViewCell.swift
//  Summar
//
//  Created by plsystems on 2023/02/14.
//

import Foundation
import SnapKit

final class TemporarySaveCollectionvViewCell: UICollectionViewCell, ViewAttributes {
    lazy var feedImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    lazy var contentLabel: UILabel = {
        let view = UILabel()
        view.layer.borderWidth = 1
        view.font = FontManager.getFont(Font.Regular.rawValue).mediumFont
        view.textColor = .black
        view.lineBreakMode = .byTruncatingTail
        view.numberOfLines = 3
        view.sizeToFit()
        return view
    }()
    lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.layer.borderWidth = 1
        view.font = FontManager.getFont(Font.Regular.rawValue).smallFont
        view.textColor = UIColor(r: 115, g: 120, b: 127)
        view.numberOfLines = 1
        view.sizeToFit()
        return view
    }()
    
    func setUpCell(_ model: FeedInfo) {
        
        setUpImg(feedImageView, model.feedImages[0].imageUrl)
        contentLabel.text = model.contents
        dateLabel.text = compareDate(model.lastModifiedDate)
    }
    
    func setUpImg(_ imageView: UIImageView,_ urlString: String?) {
        guard let urlString = urlString else {
            smLog("")
            imageView.image = UIImage(named: "NonProfile")
            return
        }
        
        if urlString.count == 0 {
            smLog("")
            imageView.image = UIImage(named: "NonProfile")
            return
        }
            
        let url = URL(string: urlString)
        //DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
        //DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(
                  with: url,
                  placeholder: nil,
                  options: [.transition(.fade(1.2))],
                  completionHandler: nil
                )
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentViewInit()
        setUI()
        setAttributes()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func contentViewInit() {
        contentView.layer.borderWidth = 1
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 4
    }
    
    func setUI() {
        contentView.addSubview(feedImageView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dateLabel)
    }
    
    func setAttributes() {
        
        feedImageView.snp.makeConstraints {
            
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(106)
        }
        dateLabel.snp.makeConstraints {
            
            $0.bottom.right.equalTo(-10)
            $0.left.equalTo(12)
        }
        contentLabel.snp.makeConstraints {
            
            $0.top.equalTo(feedImageView.snp.bottom).offset(10)
            $0.left.equalTo(12)
            $0.right.equalTo(-12)
        }
    }
}
