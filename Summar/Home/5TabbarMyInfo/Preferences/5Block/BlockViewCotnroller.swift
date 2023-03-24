//
//  BlockViewCotnroller.swift
//  Summar
//
//  Created by plsystems on 2023/03/23.
//

import Foundation
import UIKit
import Kingfisher

final class BlockViewCotnroller: UIViewController, ViewAttributes {
    let fontManager = FontManager.shared
    
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
        view.alpha = 1.0
        view.delegate = self
        view.dataSource = self
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
    }
    
    func setAttributes() {
        
        blockTableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    @objc func topBtnAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
}

final class BlockTableViewCell: UITableViewCell, ViewAttributes {
    weak var delegate: PushDelegate?
    weak var refreshDelegate: RefreshFollowList?
    let viewModel = MyInfoViewModel(nil, nil)
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
    
    func setUpCell(_ follow: SearchUserInfo, _ handler: String, _ myFollowList: Bool){
        
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
    
    override func prepareForReuse() {
        super.prepareForReuse()

        profileImg.image = nil
        nickName.text = ""
        major.text = ""
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
        smLog("")
    }
}

extension BlockViewCotnroller: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockTableViewCell", for: indexPath) as! BlockTableViewCell
        cell.major.text = "1"
        cell.followBtn.setTitle("2", for: .normal)
        cell.nickName.text = "3"
        return cell
    }
}
