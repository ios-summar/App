//
//  DotFirstCollectionViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/29.
//

import UIKit

class DotFirstCollectionViewCell: UICollectionViewCell {
    lazy var view : UIImageView = {
        let view = UIImageView()
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        shapeLayer.bounds = shapeRect
        shapeLayer.name = "DashBorder"
        shapeLayer.position = CGPoint(x: 50, y: 50)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1).cgColor
        shapeLayer.lineWidth = 1.5
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [2,4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 10).cgPath
        
        view.layer.masksToBounds = false
        view.layer.addSublayer(shapeLayer)
        return view
    }()
    
    let btn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(addImg), for: .touchUpInside)
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
        
        _ = [btn, label1, imageView].map {
            view.addSubview($0)
        }
        
        view.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(25)
//            make.right.equalTo(-25)
            make.width.height.equalTo(100)
        }
        
        btn.snp.makeConstraints{(make) in
            make.edges.equalToSuperview()
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
    
    @objc func addImg(){
        print(#file , #function)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
