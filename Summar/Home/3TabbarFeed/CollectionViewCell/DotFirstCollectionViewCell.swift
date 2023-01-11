//
//  DotFirstCollectionViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/29.
//

import UIKit

class DotFirstCollectionViewCell: UICollectionViewCell {
    
    lazy var shapeLayer : CAShapeLayer = {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        shapeLayer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        shapeLayer.name = "DashBorder"
        shapeLayer.position = CGPoint(x: 50, y: 50)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1).cgColor
        shapeLayer.lineWidth = 1.5
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [2,4]
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 100, height: 100), cornerRadius: 10).cgPath
        return shapeLayer
    }()
    
    lazy var view : UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = false
        view.layer.addSublayer(self.shapeLayer)
        view.clipsToBounds = true
        view.layer.zPosition = 999
        return view
    }()
    
    let btn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
//        btn.addTarget(self, action: #selector(addImg), for: .touchUpInside)
        return btn
    }()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ExampleImage")
        return imageView
    }()
    
    let label1 : UILabel = {
        let UILabel = UILabel()
        UILabel.text = "대표 이미지"
        UILabel.textColor = UIColor.fontColor
        UILabel.numberOfLines = 0
        UILabel.font = .boldSystemFont(ofSize: 14)
        UILabel.sizeToFit()
        UILabel.textAlignment = .center
        return UILabel
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        _ = [view].map {
            addSubview($0)
        }
        
        _ = [label1, imageView].map {
            view.addSubview($0)
//            view.sendSubviewToBack($0)
        }
        
        view.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(25)
//            make.right.equalTo(-25)
            make.width.height.equalTo(100)
        }
        
        imageView.snp.makeConstraints{(make) in
            make.top.equalTo(38)
            make.centerX.equalToSuperview()
        }
        
        label1.snp.makeConstraints{(make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        
    }
    
    func addImg(_ img: UIImage){
        view.image = img
        
        shapeLayer.removeFromSuperlayer()
        _ = [label1, imageView].map {
            $0.alpha = 0.0
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
