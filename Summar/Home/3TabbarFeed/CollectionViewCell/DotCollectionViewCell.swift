//
//  DotCollectionViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/29.
//

import UIKit

class DotCollectionViewCell: UICollectionViewCell {
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
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ExampleImage")
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        _ = [view].map {
            addSubview($0)
        }
        
        _ = [imageView].map {
            view.addSubview($0)
        }
        
        view.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(25)
            make.width.height.equalTo(100)
        }
        
        imageView.snp.makeConstraints{(make) in
            make.top.equalTo(38)
            make.centerX.equalToSuperview()
        }
        
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
