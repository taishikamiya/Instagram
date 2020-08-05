//
//  PostData.swift
//  Instagram
//
//  Created by Taishi Kamiya on 2020/07/11.
//  Copyright © 2020 taishi.kamiya. All rights reserved.
//

import UIKit
import Firebase


class PostData: NSObject {
    var id: String
    var name: String?
    var caption: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false

    //コメント
    var comment: [Comment] = []
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        
        let postDic = document.data()
        
        self.name = postDic["name"] as? String
        
        self.caption =   postDic["caption"] as? String
        
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        if let myid = Auth.auth().currentUser?.uid {
            //likesの配列の中にmyidが含まれているかチェックすることで自分がいいねをおしているかを判断
            if self.likes.firstIndex(of: myid) != nil {
                // myidがあればいいねを押していると認識する
                self.isLiked = true
            }
            
        }
        
        if let _comment = postDic["comment"] as? [Comment] {
            self.comment = _comment
        }
        
    }

}
