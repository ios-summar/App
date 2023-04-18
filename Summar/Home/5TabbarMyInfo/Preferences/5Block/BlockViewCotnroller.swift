//
//  BlockViewCotnroller.swift
//  Summar
//
//  Created by plsystems on 2023/03/23.
//

import Foundation
import UIKit
import Kingfisher

protocol ReloadTableView : AnyObject {
    func getBlockUsers()
}

final class BlockViewCotnroller: UIViewController, ViewAttributes{
    let fontManager = FontManager.shared
    let viewModel = BlockViewModel()
    
    var blockList: [Info]?
    
    // MARK: - NavigationBar Title
    lazy var titleLabel : UILabel = {
        let title = UILabel()
        title.text = "차단 목록"
        title.font = self.fontManager.getFont(Font.Bold.rawValue).extraLargeFont
        title.textColor = UIColor.black
        title.sizeToFit()
        return title
    }()
    
    // MARK: - TableView
    lazy var blockTableView: UITableView = {
        
        let view = UITableView()
        view.alpha = 0.0
        view.register(BlockTableViewCell.self, forCellReuseIdentifier: "BlockTableViewCell")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = false
        
        // 테이블뷰 왼쪽 마진 없애기
        view.separatorStyle = .none
        view.estimatedRowHeight = 130
        view.rowHeight = UITableView.automaticDimension
        view.tag = 1
        return view
    }()
    lazy var notExist : UIImageView = {
        
        let imageView = UIImageView()
        imageView.alpha = 0.0
        imageView.image = UIImage(systemName: "person.2.slash.fill")
        imageView.tintColor = UIColor.imageViewColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var notExistLabel: UILabel = {
        
        let label = UILabel()
        label.alpha = 0.0
        label.textColor = .black
        label.font = self.fontManager.getFont(Font.SemiBold.rawValue).mediumFont
        label.text = "차단한 사용자가 없습니다."
        label.sizeToFit()
        return label
    }()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getBlockUsers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
        setAttributes()
    }
    
    func setNavigationBar() {
        
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItem = self.navigationItem.makeSFSymbolButton(self, action: #selector(topBtnAction(_:)), uiImage: UIImage(systemName: "arrow.backward")!, tintColor: .black)
    }
    
    func setUI() {
        
        self.view.backgroundColor = .white
        self.view.addSubview(blockTableView)
        self.view.addSubview(notExist)
        self.view.addSubview(notExistLabel)
    }
    
    func setAttributes() {
        
        blockTableView.snp.makeConstraints {
            
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        notExist.snp.makeConstraints {
            
            $0.top.equalTo(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(150)
        }
        notExistLabel.snp.makeConstraints {
            
            $0.top.equalTo(notExist.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
    
    func getBlockUsers() {
        viewModel.getBlockedUsers { value in
            if value?.count != 0 { // 차단된 사용자가 있음
                
                self.blockList = value
                self.blockTableView.alpha = 1.0
                self.notExist.alpha = 0.0
                self.notExistLabel.alpha = 0.0
            }else { // 차단된 사용자가 없음
                smLog("차단된 사용자가 없음")
                
                self.blockTableView.alpha = 0.0
                self.notExist.alpha = 1.0
                self.notExistLabel.alpha = 1.0
            }
            
            self.blockTableView.delegate = self
            self.blockTableView.dataSource = self
            self.blockTableView.reloadData()
        }
    }
    
    @objc func topBtnAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - BlockViewCotnroller
extension BlockViewCotnroller: UITableViewDelegate, UITableViewDataSource, ReloadTableView {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let blockList = blockList else {return 0}
        
        return blockList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockTableViewCell", for: indexPath) as! BlockTableViewCell
        guard let blockList = blockList else {return UITableViewCell()}

        cell.delegate = self
        cell.setUpCell(blockList[indexPath.row])
        return cell
    }
    
    func reloadTableView() {
        
        
    }
}

// MARK: - BlockTableViewCell
final class BlockTableViewCell: UITableViewCell, ViewAttributes {
    weak var delegate: ReloadTableView?
    let viewModel = MyInfoViewModel(nil, nil)
    let blockViewModel = BlockViewModel()
    let fontManager = FontManager.shared
    
    var userSeq: Int?
    var setUpTuple: (String, Bool) = ("", true)
    
    let profileImg : UIImageView = {
        let view = UIImageView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.followShadowColor.cgColor
        view.layer.cornerRadius = 24
        view.tintColor = UIColor.grayColor205
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    lazy var nickName : UILabel = {
        let label = UILabel()
        label.font = self.fontManager.getFont(Font.Bold.rawValue).medium15Font
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    lazy var followBtn: UIButton = {
        let button = UIButton()
        button.alpha = 0.0
        button.addTarget(self, action: #selector(followBtnAction(_:)), for: .touchUpInside)
        button.titleLabel?.font = self.fontManager.getFont(Font.Bold.rawValue).smallFont
        button.setTitleColor(UIColor.magnifyingGlassColor, for: .normal)
        button.tag = 1
        button.setTitle("팔로우", for: .normal)
        return button
    }()
    lazy var major : UILabel = {
        let label = UILabel()
        label.font = self.fontManager.getFont(Font.Regular.rawValue).smallFont
        label.textColor = UIColor.textColor115
        label.sizeToFit()
        label.numberOfLines = 2
        return label
    }()
    lazy var btn : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(followBtnAction(_:)), for: .touchUpInside)
        button.backgroundColor = UIColor.Gray02
        button.layer.cornerRadius = 4
        button.titleLabel?.font = self.fontManager.getFont(Font.SemiBold.rawValue).smallFont
        button.setTitleColor(UIColor.init(r: 70, g: 76, b: 83), for: .normal)
        button.tag = 2
        return button
    }()
    
    func setUpCell(_ info: Info){
        
        userSeq = info.userSeq
        
        //프로필 이미지
        setProfileImage(profileImg, info.profileImageUrl)
        
        nickName.text = info.userNickname
        major.text = info.major2
        btn.setTitle("차단 해제", for: .normal)
    }
    
    func setProfileImage(_ imageView: UIImageView,_ urlString: String?) {
        guard let urlString = urlString else {
            imageView.image = UIImage(named: "NonProfile")
            return
        }
        let url = URL(string: urlString)
        //DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
        //DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(
                    with: url,
                    options: [
                        .transition(.fade(0.2)),
                        .forceTransition,
                        .keepCurrentImageWhileLoading,
                        .processor(DownsamplingImageProcessor(size: CGSize(width: 48, height: 48))),
                        .scaleFactor(UIScreen.main.scale),
                        .cacheOriginalImage
                    ]
                )
            }
        }
    }
    
    ///재사용 셀 대응
    override func prepareForReuse() {
        super.prepareForReuse()

        profileImg.image = nil
        nickName.text = ""
        major.text = ""
        btn.setTitle("", for: .normal)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //기본 설정
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        setUI()
        setAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        contentView.addSubview(profileImg)
        contentView.addSubview(nickName)
        contentView.addSubview(major)
        contentView.addSubview(btn)
        contentView.addSubview(followBtn)
    }
    
    func setAttributes() {
        profileImg.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.width.height.equalTo(48)
        }
        
        nickName.snp.makeConstraints { (make) in
            make.left.equalTo(profileImg.snp.right).offset(12)
            make.bottom.equalTo(profileImg.snp.centerY).offset(-5)
        }
        
        followBtn.snp.makeConstraints {
            $0.centerY.equalTo(nickName.snp.centerY)
            $0.left.equalTo(nickName.snp.right).offset(6)
            $0.height.equalTo(31)
            $0.width.equalTo(40)
        }
        
        major.snp.makeConstraints { (make) in
            make.left.equalTo(nickName.snp.left)
            make.top.equalTo(profileImg.snp.centerY).offset(5)
        }
        
        btn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(-20)
            $0.width.equalTo(70)
            $0.height.equalTo(31)
        }
    }
    
    @objc func followBtnAction(_ sender: Any) {
        guard let userSeq = userSeq else {return}
        
        smLog("차단 해제")
        smLog("\(userSeq)")
        
        blockViewModel.blockUser(userSeq) { handler in
            handler ? toast("차단 해제") : toast("서버 오류, 잠시후 다시 시도해주세요.")
            
            if handler {
                self.delegate?.getBlockUsers()
            }
        }
    }
}
