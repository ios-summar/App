//
//  TemporarySaveCollectionvViewCell.swift
//  Summar
//
//  Created by plsystems on 2023/02/14.
//

import Foundation
import SnapKit

final class TemporarySaveCollectionvViewCell: UICollectionViewCell, ViewAttributes {
    let helper = Helper.shared
    let fontManager = FontManager.shared
    
    let feedImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    lazy var contentLabel: UILabel = {
        let view = UILabel()
        view.font = self.fontManager.getFont(Font.Regular.rawValue).smallFont
        view.textColor = .black
        view.lineBreakMode = .byTruncatingTail
        view.numberOfLines = 3
        view.sizeToFit()
        return view
    }()
    lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.font = self.fontManager.getFont(Font.Regular.rawValue).smallFont
        view.textColor = UIColor(r: 115, g: 120, b: 127)
        view.numberOfLines = 1
        view.sizeToFit()
        return view
    }()
    
    func setUpCell(_ model: FeedInfo) {
        smLog("\n \(model) \n")
//        smLog("\(model.feedImages.count == 0)")
        
        if model.feedImages.count != 0 {
            setUpImg(feedImageView, model.feedImages[0].imageUrl)
        }else {
            feedImageView.image = UIImage(named: "NoExsitTemporarySaveImage")
        }
        
        contentLabel.text = model.contents
        helper.lineSpacing(contentLabel, 5)
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
                imageView.contentMode = .scaleAspectFill
                imageView.kf.setImage(
                    with: url,
                    placeholder: nil,
                    options: [.transition(.fade(1.2))],
                    completionHandler: { result in
                    switch(result) {
                        case .success(let imageResult):
                        let resized = resize(image: imageResult.image, newWidth: 200) //TEST
                        imageView.image = resized
                        imageView.isHidden = false
                        case .failure(let error):
                            imageView.isHidden = true
                        }
                    })
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
        contentView.layer.borderColor = UIColor.Gray02.cgColor
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 7
    }
    
    func setUI() {
        
        contentView.addSubview(feedImageView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dateLabel)
    }
    
    func setAttributes() {
        
        feedImageView.snp.makeConstraints {
            
            $0.left.right.top.equalTo(contentView)
            $0.bottom.equalTo(contentView.snp.centerY)
        }
        contentLabel.snp.makeConstraints {
            
            $0.top.equalTo(feedImageView.snp.bottom).offset(10)
            $0.left.equalTo(12)
            $0.right.equalTo(-12)
//            $0.bottom.equalTo(dateLabel.snp.top).offset(-5)
        }
        dateLabel.snp.makeConstraints {
            
            $0.bottom.right.equalTo(-10)
            $0.left.equalTo(12)
        }
    }
}
