//
//  HomeView.swift
//  Summar
//
//  Created by mac on 2022/12/14.
// https://hryang.tistory.com/7 => scrollview programmatically

import Foundation
import UIKit

class HomeView: UIView{
    static let shared = HomeView()
    private let cellReuseIdentifier = "collectionCell"
    
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
    var timer : Timer?
    var currentCelIndex = 0
    
    
    // 이미지 슬라이더
    let view1 = UIView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    let screenSize: CGRect = UIScreen.main.bounds
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.layer.cornerRadius = 7
        return cv
    }()
    let view1InView : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.4
        view.layer.cornerRadius = 5
        return view
    }()
    let sliderProgressBar : UIProgressView = {
        let sliderProgressBar = UIProgressView()
        sliderProgressBar.translatesAutoresizingMaskIntoConstraints = false
        sliderProgressBar.trackTintColor = .black
        sliderProgressBar.progressTintColor = .white
        return sliderProgressBar
    }()
    let sliderLabel : UILabel = {
        let sliderLabel = UILabel()
        sliderLabel.textColor = .white
        sliderLabel.sizeToFit()
        return sliderLabel
    }()
    // 이미지 슬라이더
    
    let view2 = UIView()
    let view2Label : UILabel = {
        let label = UILabel()
        label.text = "써머 메이트 추천 포트폴리오"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        label.sizeToFit()
        return label
    }()
    let view2UIImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "questionmark.circle")
        imageView.sizeToFit()
        imageView.tintColor = .black
        return imageView
    }()
    
    let view2SubView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.summarColor2
        view.layer.cornerRadius = 5
        return view
    }()
    let polygon : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "triangle.fill")
        view.tintColor = UIColor.summarColor2
        return view
    }()
    let view2SubViewLabel : UILabel = {
        let label = UILabel()
        label.text = "동종 직무군의 전공 과목 데이터를 분석하여 추천합니다."
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.sizeToFit()
        return label
    }()
    
    let view3 = UIView()
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _ = [view1, view2, view3, view2SubView].map { self.contentView.addSubview($0)}
        
        //이미지 슬라이더 view1
        addSubview(scrollView) // 메인뷰에
        self.view1.addSubview(collectionView)
        self.view1.addSubview(view1InView)
        self.scrollView.addSubview(contentView)
        self.view1InView.addSubview(sliderLabel)
        self.view1InView.addSubview(sliderProgressBar)
        sliderLabel.text = "\(currentCelIndex + 1) / \(arrProductPhotos.count)"
        sliderProgressBar.progress =  Float( Float(currentCelIndex + 1) / Float(arrProductPhotos.count))
        //
        
        //써머 메이트 추천 포트폴리오
        self.view2.addSubview(view2Label)
        self.view2.addSubview(view2UIImageView)
        //
        
        //동종 직무군의 전공 과목 데이터를 분석하여 추천합니다.
        self.view2SubView.addSubview(polygon)
        self.view2SubView.addSubview(view2SubViewLabel)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview() // 스크롤뷰가 표현될 영역
        }
        
        contentView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
        
//        view1.layer.borderWidth = 1
//        view1.layer.borderColor = UIColor.black.cgColor
        
//        view2.backgroundColor = .black
//        view2.layer.borderWidth = 1
//        view2.layer.borderColor = UIColor.black.cgColor
        
        
        view3.backgroundColor = .blue
        
        
        view1.snp.makeConstraints { (make) in
            
            make.top.equalTo(scrollView.snp.top).offset(30)
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.height.equalTo(400)
        }
        
        collectionView.snp.makeConstraints { (make) in
            
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        view1InView.snp.makeConstraints{(make) in
            
            make.bottom.equalTo(view1.snp.bottom).offset(-20)
            make.left.equalTo(view1.snp.left).offset(20)
            make.width.equalTo(163)
            make.height.equalTo(36)
        }
        
        sliderLabel.snp.makeConstraints{(make) in
            
            make.centerY.equalTo(view1InView.snp.centerY)
            make.right.equalTo(view1InView.snp.right).offset(-10)
        }
        
        sliderProgressBar.snp.makeConstraints{(make) in
            
            make.centerY.equalTo(view1InView.snp.centerY)
            make.left.equalTo(view1InView.snp.left).offset(10)
            make.right.equalTo(sliderLabel.snp.left).offset(-10)
        }
        
        //써머 메이트 추천 포트폴리오
        view2.snp.makeConstraints { (make) in
            
            make.top.equalTo(view1.snp.bottom).offset(30)
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.height.equalTo(40)
        }
        
        view2Label.snp.makeConstraints { (make) in
            
//            make.top.equalTo(view2.snp.bottom).offset(30)
            make.centerY.equalTo(view2.snp.centerY)
            make.left.equalTo(view2.snp.left)
//            make.trailing.equalTo(-30)
//            make.height.equalTo(400)
        }
        
        view2UIImageView.snp.makeConstraints { (make) in
            
//            make.top.equalTo(view2.snp.bottom).offset(30)
            make.centerY.equalTo(view2.snp.centerY)
            make.right.equalTo(view2.snp.right)
            make.height.equalTo(view2.snp.height)
            make.width.equalTo(view2.snp.height)
//            make.trailing.equalTo(-30)
//            make.height.equalTo(400)
        }
        
        view2SubView.snp.makeConstraints { (make) in
            
            make.top.equalTo(view2.snp.bottom).offset(25)
            make.leading.equalTo(30)
            make.trailing.equalTo(-20)
            make.height.equalTo(50)
        }
        
        view2SubViewLabel.snp.makeConstraints { (make) in

            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            
        }

        //동종 직무군의 전공 과목 데이터를 분석하여 추천합니다.
        polygon.snp.makeConstraints { (make) in
            
            make.top.equalTo(view2SubView.snp.top).offset(-15)
            make.centerX.equalTo(view2UIImageView.snp.centerX)
            make.width.equalTo(20)
            make.height.equalTo(20)
//            make.right.equalTo(view2SubView.snp.right)
        }
        
        
        view3.snp.makeConstraints { (make) in
            
            make.top.equalTo(view2SubView.snp.bottom).offset(120)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
            make.bottom.equalToSuperview() // 이것이 중요함
        }
        
        //홈화면 이미지 슬라이더
        imgSlider()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProductPhotos.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! HomeCollectionViewCell
        cell.imgProudctPhoto.image = arrProductPhotos[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func imgSlider(){
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        startTimer()
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(moveToNextIndex), userInfo: nil, repeats: true)
    }
        
    @objc func moveToNextIndex(){
        if (currentCelIndex == arrProductPhotos.count - 1){
            currentCelIndex = 0
        }else {
            currentCelIndex += 1
        }
        
        collectionView.scrollToItem(at: IndexPath(item: currentCelIndex, section: 0), at: .centeredHorizontally, animated: true)
        
        sliderLabel.text = "\(currentCelIndex + 1) / \(arrProductPhotos.count)"
        sliderProgressBar.progress = Float( Float(currentCelIndex + 1) / Float(arrProductPhotos.count))
    }
    
}
