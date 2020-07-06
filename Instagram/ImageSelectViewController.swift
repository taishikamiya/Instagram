//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by Taishi Kamiya on 2020/06/27.
//  Copyright © 2020 taishi.kamiya. All rights reserved.
//

import UIKit
import CLImageEditor

class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate {

    
    @IBAction func handleLibraryButton(_ sender: Any) {
        //ライブラリを指定してピッカーで開く
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func handleCameraButton(_ sender: Any) {
        //カメラを指定してPickerを開く
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickerController  = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func handleCancelButton(_ sender: Any) {
        //画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //写真を選択したときに呼ばれるメソッド
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            //撮影/選択された画像を取得する
            let image = info[.originalImage] as! UIImage
            
            //あとでCLImageEditorライブラリで加工する
            print("DEBUG_PRINT: image = \(image)")
          let editor = CLImageEditor(image: image)!
          editor.delegate = self
          picker.present(editor, animated: true, completion: nil)
          
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //ImageSelectViewController画面を閉じてタブ画面に戻る
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

     //CLImageEditorで加工が終わった時に呼ばれるメソッド
     func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
          //投稿画面を開く
          let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
          postViewController.image = image!
          editor.present(postViewController, animated: true, completion: nil)
     }
     
     //CLImageEditorの編集がキャンセルされた時に呼ばれるメソッド
     func imageEditorDidCancel(_ editor: CLImageEditor!) {
          //ImageSelectViewController画面を閉じてタブ画面に戻る
          self.presentingViewController?.dismiss(animated: true, completion: nil)
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
