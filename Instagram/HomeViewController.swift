//
//  HomeViewController.swift
//  Instagram
//
//  Created by Taishi Kamiya on 2020/06/27.
//  Copyright © 2020 taishi.kamiya. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    //投稿データを格納する配列
    var postArray: [PostData] = []
    //コメントデータを格納する配列
    var commentArray: [Comment] = []
    
    var commentPostData: PostData?
    
    //コメント入力用
    let textField = UITextField()
    
//    FireStoreのListener
    var listener: ListenerRegistration!
    
    var commentListener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        //カスタムセルを登録する
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        if Auth.auth().currentUser != nil {
            //ログイン済
            if listener == nil {
                //listener未登録なら登録してスナップショットを受信する
                let  postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
                listener = postsRef.addSnapshotListener() { (QuerySnapshot, error) in
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました \(error)")
                        return
                    }
                    //で取得したdocumentを基にpostDataを作成しpostArrayの配列にする。
                    self.postArray = QuerySnapshot!.documents.map { document in
                        print("DEBUG_PRINT: document取得 \(document.documentID)")
                        let postData = PostData(document: document)
                        return  postData
                    }
                    
                    // TableViewの表示を更新する
                    self.tableView.reloadData()
                }
        } else {
            //未ログイン
            if listener != nil {
                //lister登録済なら削除してpostArrayをクリアする。
                listener.remove()
                listener = nil
                postArray = []
                tableView.reloadData()
            }
        }
        
        self.configureObserver()
    }
    
        func getCommentData(){
            
            for post in postArray {
                let postId = post.comment
                
            }
                //postにcommnetIdが含まれるかどうかをチェック
                    let commentRef = Firestore.firestore().collection(Const.CommentPath).order(by: "data", descending: true)
                    self.commentListener = commentRef.addSnapshotListener() { (QuerySnapshot, error) in
                        if let error = error {
                            print("DEBUG_PRINT: snapshotの取得が失敗しました(com) \(error)")
                            return
                        }
                        //取得したdocを基にcommentDataを作成しcommentArrayの配列にする
                        self.commentArray = QuerySnapshot!.documents.map { document in
                            print("DEBUG_PRINT: document取得 \(document.documentID)")
                            let commentData = Comment(document: document)
                            return commentData
                        }
                    }
                }
        }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
        //セル内のボタンのアクションをソースコードで設定する
        cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
        
        //セル内のコメントボタンのアクションをソースコードで設定する。
        cell.commentButton.addTarget(self, action:#selector(handleCommentButton(_:forEvent:)), for: .touchUpInside)
        
        //commentDelegate
    //    cell.commentDelegate = self
        
        return cell
    }
    
    @objc func handleButton(_ sender:  UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT:  likeボタンがタップされました。")
        
        //タップされたセルのインデックスを求める。
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        //配列からタップされたINDEXのデータを取りだす
        let postData = postArray[indexPath!.row]
        
        //likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            //更新データを作成する
            var updateValue: FieldValue
            if postData.isLiked {
                //すでにいいねをしている場合は、いいね解除のためmyidを取り除く更新データを作成
                updateValue =  FieldValue.arrayRemove([myid])
            } else {
                //今回新たにいいねを押した場合はmyidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            //likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes": updateValue])
        }
    }
        
    @objc func handleCommentButton(_ sender:  UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT:  commentボタンがタップされました。")

        //タップされたセルのインデックスを求める。
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        //配列からタップされたINDEXのデータを取りだす
        commentPostData = postArray[indexPath!.row]

        showTextField()
        editTextField()
        
    }
    
    //returnが押されたときに呼ばれる.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
        self.postComment()
        return true
    }
    
    // Notificationを設定
    func configureObserver() {
          
      let notification = NotificationCenter.default

      notification.addObserver(
        self,
        selector: #selector(self.keyboardWillShow(notification:)),
        name: UIResponder.keyboardWillShowNotification,
        object: nil
      )
          
      notification.addObserver(
        self,
        selector: #selector(self.keyboardWillHide(notification:)),
        name: UIResponder.keyboardWillHideNotification,
        object: nil
      )
    }
    //キーボードが現れたときにViewをずらす
    @objc func keyboardWillShow(notification: Notification?){
        let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            UIView.animate(withDuration: duration!) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
        }
    }
    
    // キーボードが消えたときにviewを戻す
    @objc func keyboardWillHide(notification: Notification?) {
      let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
      UIView.animate(withDuration: duration!) {
        self.view.transform = CGAffineTransform.identity
      }
    }
        
    
    func showTextField() {
         //テキストフィールド
        textField.frame = CGRect(x:0, y:self.view.bounds.height-50, width: self.view.bounds.width, height: 50)
        textField.placeholder = "コメント"
        //keyboard type
        textField.keyboardType = .default
        //枠線
        textField.borderStyle = .roundedRect
        //改行ボタンの種類
        textField.returnKeyType = .done
        //テキスト全消去ボタン表示
        textField.clearButtonMode = .always
        //デフォルトで非表示
//        textField.isHidden = true
        //UITextFieldを追加
        self.view.addSubview(textField)
        //デリゲード
        textField.delegate = self
        
    }
    
    func editTextField() {
        //フォーカスする
        textField.becomeFirstResponder()
    }
    
    
    func postComment() {
        //画像と投稿dataの保存場所を定義する
        //let postRef = Firestore.firestore().collection(Const.PostPath).document()
        
        //commentsを更新する
        if let myid = Auth.auth().currentUser?.uid {
            //更新データを作成する
            var updateValue: FieldValue
//            if ((commentPostData?.comment) != nil) {
                //すでにコメントがある場合
            //    updateValue =  FieldValue.arrayRemove([myid])
  //          } else {
//                今回新たにコメントボタンを押した場合はmyidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])

            //HUDで投稿処理中の表示を開始
            SVProgressHUD.show()

            let commentRef = Firestore.firestore().collection(Const.CommentPath).document()

            //投稿のidを生成
            let commentId = commentRef.documentID

            let postRef = Firestore.firestore().collection(Const.PostPath).document(commentPostData!.id).collection("comment").document(commentId)
            
            //FireSoreに投稿dataを保存する
            let name = Auth.auth().currentUser?.displayName
            let postDic = [
                "name": name!,
                "comment": self.textField.text!,
                "date": FieldValue.serverTimestamp(),
            ] as [String: Any]

            postRef.setData(postDic)
            
            //HUDで投稿完了を表示
            SVProgressHUD.showSuccess(withStatus: "投稿しました")

            //投稿処理が完了したので先頭に戻る
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)

        }

    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
