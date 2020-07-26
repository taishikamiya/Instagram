//
//  CommentTableViewCell.swift
//  Instagram
//
//  Created by Taishi Kamiya on 2020/07/12.
//  Copyright © 2020 taishi.kamiya. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //CommentDataの内容をセルに表示
    func setCommentData(_ postData: PostData){
        
        //コメント表示
       // self.commentLabel.text = "\(postData.comment!)"
        
        //名前表示
       // self.nameLabel.text = "\(postData.commentName!)"
    }
    
}
