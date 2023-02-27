//
//  DotFirstCollectionViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/29.
//

import UIKit

final class DotFirstCollectionViewCell: UICollectionViewCell, ViewAttributes {
    let fontManager = FontManager.shared
    
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
    
    let view = UIView()
    
    lazy var imageView : UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = false
        view.layer.addSublayer(self.shapeLayer)
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var btn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "FeedWrite"), for: .normal)
        btn.backgroundColor = .clear
        btn.isUserInteractionEnabled = true
        btn.addTarget(self, action: #selector(touchXmark), for: .touchUpInside)
        btn.layer.cornerRadius = 12
        btn.layer.borderWidth = 1
        
        return btn
    }()
    
    let ExampleImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ExampleImage")
        return imageView
    }()
    
    lazy var label1 : UILabel = {
        let UILabel = UILabel()
        UILabel.text = "대표 이미지"
        UILabel.textColor = UIColor.fontColor
        UILabel.numberOfLines = 0
        UILabel.font = self.fontManager.getFont(Font.Bold.rawValue).mediumFont
        UILabel.sizeToFit()
        UILabel.textAlignment = .center
        return UILabel
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setUI()
        setAttributes()
    }
    
    func setUI() {
        
        addSubview(view)
        
        view.addSubview(imageView)
        view.addSubview(label1)
        view.addSubview(ExampleImage)
    }
    
    func setAttributes() {
        
        view.snp.makeConstraints {
            
            $0.centerY.equalToSuperview()
            $0.left.equalTo(25)
            $0.width.height.equalTo(100)
        }
        imageView.snp.makeConstraints{
            
            $0.edges.equalTo(view)
        }
        ExampleImage.snp.makeConstraints{
            
            $0.top.equalTo(38)
            $0.centerX.equalToSuperview()
        }
        label1.snp.makeConstraints{
            
            $0.top.equalTo(ExampleImage.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    func addImg(_ img: UIImage){
        imageView.image = img
        shapeLayer.removeFromSuperlayer()
        
        view.addSubview(btn)
        view.bringSubviewToFront(btn)
        btn.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.top.equalTo(view.snp.top)
            $0.right.equalTo(view.snp.right)
        }
        
        _ = [label1, ExampleImage].map {
            $0.alpha = 0.0
        }
    }
    
    func removeImg() {
        imageView.image = nil
        imageView.layer.addSublayer(self.shapeLayer)
        _ = [label1, ExampleImage].map {
            $0.alpha = 1.0
        }
    }
    
    @objc func touchXmark() {
        smLog("")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
