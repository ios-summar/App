//
//  DotCollectionViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/29.
//

import UIKit

final class DotCollectionViewCell: UICollectionViewCell, ViewAttributes {
    
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
        view.layer.cornerRadius = 10
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var btn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "FeedWrite"), for: .normal)
        btn.backgroundColor = .clear
        btn.isUserInteractionEnabled = true
//        btn.addTarget(self, action: #selector(touchXmark), for: .touchUpInside)
        btn.layer.cornerRadius = 12
        return btn
    }()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ExampleImage")
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)

        setUI()
        setAttributes()
    }
    
    func setUI() {
        
        contentView.addSubview(view)
        view.addSubview(imageView)
    }
    
    func setAttributes() {
        view.snp.makeConstraints{(make) in
            make.centerX.centerY.equalToSuperview()
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
        
        contentView.addSubview(btn)
        btn.snp.makeConstraints {
            $0.width.height.equalTo(25)
            $0.top.equalToSuperview()
            $0.right.equalToSuperview()
        }
        imageView.alpha = 0.0
    }
    
    func removeImg() {
        view.image = nil
        view.layer.addSublayer(self.shapeLayer)
        imageView.alpha = 1.0
    }
    
    @objc func touchXmark() {
        smLog("")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
