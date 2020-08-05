//
//  CommentData.swift
//  Instagram
//
//  Created by Taishi Kamiya on 2020/07/13.
//  Copyright © 2020 taishi.kamiya. All rights reserved.
//

import Foundation
import Firebase

class Comment : NSObject {
    
    var id: String
    var name: String?

    var comment: String?
//    var userId: String?
    var date: Date?

//    var timeStamp: Int = 0
    
    init(document: QueryDocumentSnapshot) {
//        self.userId = document.documentID
        let postDic = document.data()

        self.id = document.documentID

        self.name = postDic["name"] as? String

        self.comment =  postDic["comment"] as? String
           
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
    }
    
}

