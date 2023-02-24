//
//  NotificationModel.swift
//  Summar
//
//  Created by ukBook on 2023/02/19.
//

import Foundation

struct NotificationModel: Codable {
    let result: [NotificationList]
}

struct NotificationList: Codable {
    let content: String?
    let userSeq: Int?
    let otherUserSeq: Int?
    let feedSeq: Int?
    let feedCommentSeq: Int?
    let imageUrl: String?
    let feedImageUrl: String?
    let notificationType: String?
    let followCheck: Bool?
    let createdDate: String?
}
