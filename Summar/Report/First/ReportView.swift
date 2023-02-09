//
//  ReportView.swift
//  Summar
//
//  Created by plsystems on 2023/02/09.
//

import Foundation
import UIKit

final class ReportView: UIView, ViewAttributes {
    weak var delegate: PushDelegate?
    var reportArr: [String] = []
    
    lazy var tableView : UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.register(ReportTableViewCell.self, forCellReuseIdentifier: "ReportTableViewCell")
        view.separatorStyle = .none
        view.isScrollEnabled = false
        view.backgroundColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.Gray02
        
        setArray()
        setUI()
        setAttributes()
    }
    
    func setArray() {
        _ = [
        "신고이유를 선택해 주세요",
        "사칭, 거짓정보 및 허위사실 유포",
        "욕설, 비난, 차별, 저격, 정치/사회적 갈등 조장",
        "도배, 홍보/광고 행위",
        "수위가 높은 음란성 발언",
        "테러 모의 및 범죄",
        "자살, 자해 및 섭식 장애",
        "저작권 침해",
        "기타"
        ].map {
            reportArr.append($0)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUI() {
        addSubview(tableView)
    }
    
    func setAttributes() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(1)
            $0.left.right.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReportView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCell", for: indexPath) as! ReportTableViewCell
        cell.setUpCell(index: indexPath.row, reportArr[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        default:
            self.delegate?.pushScreen(ReportView2Controller(), reportArr[indexPath.row])
        }
    }
}
