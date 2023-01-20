//
//  FAQView.swift
//  Summar
//
//  Created by ukBook on 2023/01/15.
//

import Foundation
import UIKit

class FAQView: UIView {
    let viewModel = FAQViewModel()
    var notice : Notice? {
        didSet {
            guard let results = notice?.result?.results else { return }
            tableViewData = []
            
            for x in 0 ... results.count - 1 {
                tableViewData.append(cellData(opened: false, title: results[x].title!, date: results[x].regDatetime! , sectionData: results[x].content!))
            }
            
            
            tableView.register(FAQTitleTableViewCell.self, forCellReuseIdentifier: "TableViewCell1")
            tableView.register(NoticeContentTableViewCell.self, forCellReuseIdentifier: "TableViewCell2")
            
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.reloadData()
        }
    }
    
    var tableViewData = [cellData]()
    
    let view : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        return view
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.searchGray.cgColor
        
        // 테이블뷰 왼쪽 마진 없애기
        tableView.separatorStyle = .singleLine
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.separatorInset.left = 0
        tableView.separatorColor = .gray
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .white
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.top.left.right.bottom.equalToSuperview()
        }
    }
    
    func getNotice(){
        viewModel.getNotice()
        
        viewModel.didFinishFetch = {
            self.notice = self.viewModel.notice
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FAQView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
         return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true {
            // tableView Section이 열려있으면 Section Cell 하나에 sectionData 개수만큼 추가해줘야 함
            return 2
        } else {
            // tableView Section이 닫혀있을 경우에는 Section Cell 하나만 보여주면 됨
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // section 부분 코드
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell1", for: indexPath)
                    as? FAQTitleTableViewCell else { return UITableViewCell() }
            cell.tableLabel.text = tableViewData[indexPath.section].title
            cell.upDownImageView.image = UIImage(named: "Down")
            cell.view.backgroundColor = .white
            return cell
            
        // sectionData 부분 코드
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell2", for: indexPath)
                    as? NoticeContentTableViewCell else { return UITableViewCell() }
            cell.tableLabel.text = tableViewData[indexPath.section].sectionData
            cell.view.backgroundColor = UIColor.Gray01
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 셀 선택 시 회색에서 다시 변하게 해주는 것
        tableView.deselectRow(at: indexPath, animated: true)
        
        // section 부분 선택하면 열리게 설정
        if indexPath.row == 0 {
            
            // section이 열려있다면 다시 닫힐 수 있게 해주는 코드
            tableViewData[indexPath.section].opened = !tableViewData[indexPath.section].opened
            
            // 모든 데이터를 새로고침하는 것이 아닌 해당하는 섹션 부분만 새로고침
            tableView.reloadSections([indexPath.section], with: .none)
        
            let cell = tableView.cellForRow(at: indexPath) as! FAQTitleTableViewCell
            
            if tableViewData[indexPath.section].opened { // 초기 false Down
                smLog("")
                cell.upDownImageView.image = UIImage(named: "Up")
            }else {
                smLog("")
                cell.upDownImageView.image = UIImage(named: "Down")
            }
            // sectionData 부분을 선택하면 아무 작동하지 않게 설정
        } else {
            print("이건 sectionData 선택한 거야")
        }
        
    }
}
