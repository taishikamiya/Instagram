//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by Taishi Kamiya on 2020/07/11.
//  Copyright © 2020 taishi.kamiya. All rights reserved.
//

import UIKit
import FirebaseUI

class PostTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    
    //コメントデータを格納する配列
    var commentArray: [PostData] = []
//        var commentArray: [Comment] = []

    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return commentArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //セルを取得してデータを設定する
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CommentTableViewCell
     //       cell.setPostData(commentArray[indexPath.row])
  //          cell.setCommentData(commentArray[indexPath.row])

            return cell
        }

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    //comment
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentTableView: UITableView!
    
    weak var commentDelegate: PostCellDelegate?

    /*
    @IBAction func handleCommentButton(_ sender: Any) {
        //プロトコルの関数を呼ぶ
        commentDelegate?.showTextField()
        //アクティブにする
        commentDelegate?.editTextField()
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //postDataの内容をセルに表示
    func setPostData(_ postData: PostData) {
        //画像の表示
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        postImageView.sd_setImage(with: imageRef)
        
        //キャプションの表示
        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }
        
        //いいね数の表示
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        //いいねボタンの表示
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named:  "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        
        //コメントの表示
        /*
        let commentNumber = postData.comment.count
        let commentData: [Comment] = postData.comment
        for Com in commentData {
                    print("DEBUG_PRINT: \(Com)")
        }
*/
        
    }
    
}

protocol PostCellDelegate: class {
    func showTextField()
    func editTextField()
    
}
