//
//  BannerTableViewCell.swift
//  Summar
//
//  Created by mac on 2022/12/22.
//

import UIKit

class BannerTableViewCell: UITableViewCell {
    
    private let cellReuseIdentifier = "collectionCell"
    
    // 이미지 슬라이더
    let view1 = UIView()
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.layer.cornerRadius = 7
        return cv
    }()
    
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        selectionStyle = .none
        backgroundColor = .white
        
//        self.view1.addSubview(collectionView)
//        view1.snp.makeConstraints{(make) in
//            make.top.left.bottom.right.equalToSuperview()
//            make.top.bottom.equalToSuperview()
//            make.left.equalTo(30)
//            make.right.equalTo(-30)
//        }
        collectionView.layer.borderWidth = 1
        collectionView.snp.makeConstraints{(make) in
            make.top.left.bottom.right.equalToSuperview()
            make.top.equalTo(5)
            make.width.equalTo(100)
            make.height.equalTo(80)
            make.bottom.equalTo(-5)
        }
        
        imgSlider()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .clear
//        contentView.layer.borderWidth = 3
        
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
    }

}

extension BannerTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
    }
}
