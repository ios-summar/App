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
    let helper = Helper.shared
    private let cellReuseIdentifier = "collectionCell"
    private let tableCellReuseIdentifier = "tableCell"
    
    var arr: Array<Feed> = []
    
    let Feed1 = Feed()
    let Feed2 = Feed()
    
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
    
    let view3 = UIView()
    let view3TableView : UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderWidth = 1
//        view.backgroundColor = .magenta
        return view
    }()
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _ = [view1, view3].map { self.contentView.addSubview($0)}
        
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
        
        self.view3.addSubview(view3TableView)
        
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview() // 스크롤뷰가 표현될 영역
        }
        
        contentView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
        
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
        
        
        view3.snp.makeConstraints { (make) in
            
            make.top.equalTo(view1.snp.bottom).offset(30)
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.height.equalTo(600)
            make.bottom.equalToSuperview() // 이것이 중요함
        }
        
        view3TableView.snp.makeConstraints { (make) in
            
            make.top.left.bottom.right.equalToSuperview()
        }
        
        //홈화면 이미지 슬라이더
        imgSlider()
        testFeed()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - 이미지 슬라이더
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
    
    // MARK: - 피드
    func testFeed(){
        arr.append(Feed1)
        arr.append(Feed2)
        
        view3TableView.register(HomeTableViewCell.self, forCellReuseIdentifier: tableCellReuseIdentifier)
        
        view3TableView.delegate = self
        view3TableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = view3TableView.dequeueReusableCell(withIdentifier: tableCellReuseIdentifier, for: indexPath) as! HomeTableViewCell
        helper.lineSpacing(cell.introductLabel, 10)
        cell.nickName.text = "욱승"
        cell.major.text = "컴퓨터 / 통신"
        cell.introductLabel.text = "introductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabelintroductLabel"
        return cell
        return UITableViewCell()
    }
    
}
