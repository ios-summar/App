//
//  DotCollectionViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/29.
//

import UIKit

class DotCollectionViewCell: UICollectionViewCell {
    
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
        view.layer.cornerRadius = 10
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
//            view.sendSubviewToBack($0)
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
    
    func addImg(_ img: UIImage){
        view.image = img
        
        shapeLayer.removeFromSuperlayer()
        _ = [imageView].map {
            $0.alpha = 0.0
        }
    }
    
    func removeImg() {
        view.image = nil
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
