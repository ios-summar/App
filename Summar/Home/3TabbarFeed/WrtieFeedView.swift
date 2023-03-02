//
//  WrtieFeedView.swift
//  Summar
//
//  Created by mac on 2022/12/22.
//

import Foundation
import UIKit
import BSImagePicker
import Photos

protocol ImagePickerDelegate : AnyObject {
    func openPhoto(completion: @escaping([UIImage]?) -> ())
    func showImageFullScreen(_ imageArr: [UIImage])
    func showAlert(_ message: String)
}

protocol RemoveAction: AnyObject {
    func buttonTapped(_ sender: UIButton)
}

final class WriteFeedView : UIView, UITextViewDelegate, RemoveAction{
    let helper = Helper.shared
    let fontManager = FontManager.shared
    let viewModel = WriteFeedViewModel()
    
    weak var delegate : ImagePickerDelegate?
    weak var popDelegate : PopDelegate?
    var allChangeImg: Bool = false
    
    var resultArr = [UIImage]()
    var feedImageSeqArr = [Int]()
    var tempFeedImageSeqArr = [Int]()
    // 피드 수정 Case
    var feedInfo: FeedInfo? {
        didSet {
            setUpWriteFeedView(feedInfo)
        }
    }
    
    private let cellReuseIdentifier = "FeedCollectionCell"
    private let EmptyCellReuseIdentifier = "EmptyCollectionCell"
    private let DotCellReuseIdentifier = "DotCollectionCell"
    private let DotFirstCellReuseIdentifier = "DotFirstCollectionCell"
    
    let textViewPlaceHolder = "피드 내용은 2,000자 이내로 입력 가능합니다."
    
    let btnWidth : CGFloat = {
        var btnWidth = UIScreen.main.bounds.width
        return btnWidth - 50
    }()
    
    // 슬라이더
    let view1 = UIView()
    lazy var collectionViewScroll : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        cv.register(EmptyCollectionViewCell.self, forCellWithReuseIdentifier: EmptyCellReuseIdentifier)
        cv.register(DotCollectionViewCell.self, forCellWithReuseIdentifier: DotCellReuseIdentifier)
        cv.register(DotFirstCollectionViewCell.self, forCellWithReuseIdentifier: DotFirstCellReuseIdentifier)
        cv.backgroundColor = .white
        return cv
    }()
    
    let view2 : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.textFieldColor
        return view
    }()
    
    lazy var view2TextView : UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.textFieldColor
        textView.font = self.fontManager.getFont(Font.Regular.rawValue).mediumFont
        textView.text = textViewPlaceHolder
        textView.textColor = .lightGray
        textView.delegate = self
        return textView
    }()
    
    let switch1 : UISwitch = {
        let sw = UISwitch()
        sw.isOn = true
        sw.onTintColor = .summarColor2
        return sw
    }()
    
    let switch2 : UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = .summarColor2
        return sw
    }()
    
    lazy var leftLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.fontColor
        label.text = "댓글기능 켜기"
        label.textAlignment = .left
        label.font = self.fontManager.getFont(Font.Regular.rawValue).smallFont
        return label
    }()
    
    lazy var rightLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.fontColor
        label.text = "피드 비공개하기"
        label.textAlignment = .left
        label.font = self.fontManager.getFont(Font.Regular.rawValue).smallFont
        return label
    }()
    
    lazy var registerBtn : UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .summarColor2
        button.setTitle("등록", for: .normal)
        button.addTarget(self, action: #selector(insertFeed(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var temporarySaveBtn : UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.fontColor, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.init(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        button.setTitle("임시저장", for: .normal)
        button.addTarget(self, action: #selector(tempSave(_:)), for: .touchUpInside)
        return button
    }()
    
    func setUpWriteFeedView(_ feedInfo: FeedInfo?) {
        
        temporarySaveBtn.removeFromSuperview()
        registerBtn.setTitle("수정", for: .normal)
        registerBtn.snp.makeConstraints {
            
            $0.left.equalTo(self.safeAreaLayoutGuide).offset(20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            $0.right.equalTo(self.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(60)
        }
        
        smLog("\(feedInfo)")

        if let feedImages = feedInfo?.feedImages {
            for x in 0 ..< feedImages.count {
                guard let imageURL = feedImages[x].imageUrl, let feedImgSeq = feedImages[x].feedImageSeq else {return}
                
                setImage(imageURL)
                self.feedImageSeqArr.append(feedImgSeq)
            }
            
            tempFeedImageSeqArr = feedImageSeqArr
        }
        
        if let contents = feedInfo?.contents {
            view2TextView.text = contents
            view2TextView.textColor = .black
        }
        
        if let commentYn = feedInfo?.commentYn, let secretYn = feedInfo?.secretYn {
            switch1.isOn = commentYn
            switch2.isOn = secretYn
        }
    }
    
    func setImage(_ urlString: String) {
        let url = URL(string: urlString)
        //DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
        //DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                UIImageView().kf.indicatorType = .activity
                UIImageView().kf.setImage(
                  with: url,
                  placeholder: nil,
                  options: [.transition(.fade(1.2))],
                  completionHandler: { result in
                  switch(result) {
                      case .success(let imageResult):
                            let resized = resize(image: imageResult.image, newWidth: 100)
                            self.resultArr.append(resized)
                            self.collectionViewScroll.reloadData()
                      case .failure(let error):
                            print(error)
                      }
                  })
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        configureUI()
        configureDelegate()
    }
    
    func configureDelegate() {
        collectionViewScroll.delegate = self
        collectionViewScroll.dataSource = self
    }
    
    func configureUI() {
        _ = [view1, view2, switch1, switch2, leftLabel, rightLabel, registerBtn, temporarySaveBtn].map {
            addSubview($0)
//            $0.layer.borderWidth = 1
        }
        self.view1.addSubview(collectionViewScroll)
        self.view2.addSubview(view2TextView)
        
        view1.snp.makeConstraints{(make) in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(150)
        }
        
        collectionViewScroll.snp.makeConstraints{(make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        view2.snp.makeConstraints{(make) in
            make.top.equalTo(view1.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(btnWidth)
            make.bottom.equalTo(leftLabel.snp.top).offset(-20)
        }
        
        view2TextView.snp.makeConstraints{(make) in
            make.top.left.equalTo(20)
            make.bottom.right.equalTo(-20)
        }
        
        leftLabel.snp.makeConstraints{(make) in
            make.bottom.equalTo(registerBtn.snp.top).offset(-20)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.centerX).offset(-10)
            make.height.equalTo(switch1.snp.height)
        }
        
        switch1.snp.makeConstraints{(make) in
            make.centerY.equalTo(leftLabel)
            make.right.equalTo(leftLabel.snp.left).offset(-20)
        }
        
        rightLabel.snp.makeConstraints{(make) in
            make.centerY.equalTo(leftLabel)
            make.left.equalTo(switch2.snp.right).offset(20)
            make.right.equalTo(-20)
            make.height.equalTo(switch1.snp.height)
        }
        
        switch2.snp.makeConstraints{(make) in
            make.centerY.equalTo(leftLabel)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.centerX).offset(10)
            make.height.equalTo(switch1.snp.height)
        }
        
        registerBtn.snp.makeConstraints{(make) in
            make.left.equalTo(self.safeAreaLayoutGuide.snp.centerX).offset(10)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.right.equalTo(-20)
            make.height.equalTo(60)
        }
        
        temporarySaveBtn.snp.makeConstraints{(make) in
            make.right.equalTo(self.safeAreaLayoutGuide.snp.centerX).offset(-10)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.left.equalTo(20)
            make.height.equalTo(60)
        }
    }
    
    func reset() {
        view2TextView.text = "피드 내용은 2,000자 이내로 입력 가능합니다."
        view2TextView.textColor = .lightGray
        resultArr = []
        collectionViewScroll.reloadData()
    }
    
    // MARK: - PlaceHolder 작업
    func textViewDidBeginEditing(_ textView: UITextView) {
        smLog("\(textView.text!)")
        smLog("\(textViewPlaceHolder)")
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
    
    @objc func insertFeed(_ sender: Any) {
        if resultArr.count == 0 || (view2TextView.text == "피드 내용은 2,000자 이내로 입력 가능합니다." || view2TextView.text == "") {
//            helper.showAlert(vc: self, message: "이미지 추가 혹은 피드내용을 채우고 피드 등록이 가능합니다")
            self.delegate?.showAlert("이미지 추가 혹은 피드 내용을 채우고 피드 등록이 가능합니다.")
        }else {
            registerFeed("insertFeed", sender)
        }
        
    }
    
    @objc func tempSave(_ sender: Any) {
        if resultArr.count == 0 && (view2TextView.text == "피드 내용은 2,000자 이내로 입력 가능합니다." || view2TextView.text == "") {
//            helper.showAlert(vc: self, message: "이미지 추가 혹은 피드내용을 채우고 임시저장이 가능합니다.")
            self.delegate?.showAlert("이미지 추가 혹은 피드 내용을 채우고 임시저장이 가능합니다.")
        }else {
            registerFeed("tempSave", sender)
        }
    }
    
    func registerFeed(_ index: String, _ sender: Any) {
        let btn = sender as? UIButton
        var requestBody = Dictionary<String, Any>()
        
        requestBody["commentYn"] = switch1.isOn
        requestBody["secretYn"] = switch2.isOn
        if index == "insertFeed" {
            requestBody["tempSaveYn"] = false
        }else {
            requestBody["tempSaveYn"] = true
        }
        
        if view2TextView.text != "피드 내용은 2,000자 이내로 입력 가능합니다." || view2TextView.text != "" {
            requestBody["contents"] = view2TextView.text
        }else {
            requestBody["contents"] = nil
        }
        
        LoadingIndicator.showLoading()
        
        guard let text = btn?.titleLabel?.text else {return}
        switch text { // 등록, 임시저장, 수정 case로 나뉨
        case "등록", "임시저장" :
            smLog("")
            requestBody["userSeq"] = getMyUserSeq()
            
            viewModel.insertFeed(requestBody, resultArr)
            viewModel.didFinishFetch = {
                self.popDelegate?.popScreen()
                LoadingIndicator.hideLoading()
            }
            
        case "수정":
            if let feedInfo = feedInfo {
                smLog("임시저장, 수정")
                guard let feedSeq = feedInfo.feedSeq else {return}
                requestBody["feedSeq"] = feedSeq
                
                let deleteImageSeqs = feedImageSeqArr.filter { !tempFeedImageSeqArr.contains($0) }
                
                if allChangeImg { // 이미지 추가하기로 덮어쓴 상황
                    
                    requestBody["deleteImageSeqs"] = feedImageSeqArr
                }else { // 이미지를 추가 안하고 이미지만 삭제
                    if deleteImageSeqs.count != 0 { // 한개라도 삭제
                        requestBody["deleteImageSeqs"] = deleteImageSeqs
                    }else { // 하나도 삭제 안함
                        requestBody["deleteImageSeqs"] = nil
                    }
                    requestBody["insertImages"] = nil
                }
                
                
                viewModel.updateFeed(requestBody, resultArr)
                viewModel.didFinishUpdateFetch = {
                    smLog("")
                    self.popDelegate?.popScreen()
                    LoadingIndicator.hideLoading()
                }
                
            }else {
                requestBody["userSeq"] = getMyUserSeq()
                
                viewModel.insertFeed(requestBody, resultArr)
                viewModel.didFinishUpdateFetch = {
                    if text == "임시저장" {
                        toast("임시 저장한 포트폴리오는 마이 써머리 탭에서 확인 가능합니다.")
                    }
                    
                    self.popDelegate?.popScreen()
                    LoadingIndicator.hideLoading()
                }
            }

        default:
            LoadingIndicator.hideLoading()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension WriteFeedView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - 피드 작성 collectionView 슬라이더
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if resultArr.count == 0 { // 초기 셋팅
            return 12
        }else {
            return resultArr.count + 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 { // 첫번째 cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! FeedCollectionViewCell
            return cell
        }
        
        if resultArr.count == 0 {  // 초기 셋팅
            
            if indexPath.row != 11 {
                if indexPath.row == 1 { // 두번째 cell
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DotFirstCellReuseIdentifier, for: indexPath) as! DotFirstCollectionViewCell
                    cell.removeImg()
                    cell.delegate = self
                    
                    return cell
                }else { // 1, 2번째 cell 제외한 나머지 cell
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DotCellReuseIdentifier, for: indexPath) as! DotCollectionViewCell
                    cell.removeImg()
                    cell.delegate = self
                    
                    return cell
                }
            }else { // empty cell로 padding
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCellReuseIdentifier, for: indexPath) as! EmptyCollectionViewCell
                return cell
            }
            
        }else { // 이미지 피커 이후
            if indexPath.row != resultArr.count + 1 {
                if indexPath.row == 1 { // 두번째 cell
                    if resultArr.count >= 1 {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DotFirstCellReuseIdentifier, for: indexPath) as! DotFirstCollectionViewCell
                        cell.addImg(resultArr[0])
                        cell.delegate = self
                        
                        return cell
                    }else {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DotFirstCellReuseIdentifier, for: indexPath) as! DotFirstCollectionViewCell
                        cell.delegate = self
                        
                        return cell
                    }
                }else { // 1,2번째 cell 제외한 나머지 cell 2..3..4..5..6..
                    // resultArr.count 2 indexPath.row 2
                    print("resultArr.count => \(resultArr.count)")
                    print("indexPath.row - 1 => \(indexPath.row - 1)")
                    if resultArr.count > indexPath.row - 1 {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DotCellReuseIdentifier, for: indexPath) as! DotCollectionViewCell
                        cell.addImg(resultArr[indexPath.row - 1])
                        cell.delegate = self
                        
                        return cell
                    }else {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DotCellReuseIdentifier, for: indexPath) as! DotCollectionViewCell
                        cell.delegate = self
                        
                        return cell
                    }
                }
            }else { // empty cell로 padding
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCellReuseIdentifier, for: indexPath) as! EmptyCollectionViewCell
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row != 11 {
            return CGSize(width: 100, height: 100)
        }else {
            return CGSize(width: 25, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.delegate?.openPhoto(completion: {(imageArr) in
                guard let resultArr = imageArr else{ return }
                self.resultArr = resultArr
                self.allChangeImg = true
                
                self.collectionViewScroll.reloadData()
            })
        }else {
            if resultArr.count != 0 {
                self.delegate?.showImageFullScreen(self.resultArr)
            }
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? DotFirstCollectionViewCell {
            guard let indexPath = collectionViewScroll.indexPath(for: cell) else {return}
            
            resultArr.remove(at: indexPath.row - 1)
            tempFeedImageSeqArr.remove(at: indexPath.row - 1)
            
            self.collectionViewScroll.reloadData()
        }else if let cell = sender.superview?.superview as? DotCollectionViewCell {
            guard let indexPath = collectionViewScroll.indexPath(for: cell) else {return}
            
            resultArr.remove(at: indexPath.row - 1)
            tempFeedImageSeqArr.remove(at: indexPath.row - 1)
            
            self.collectionViewScroll.reloadData()
        }else {
            smLog("nil")
        }
    }
    
}
