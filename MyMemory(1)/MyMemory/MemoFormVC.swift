//
//  MemoFormVC.swift
//  MyMemory
//
//  Created by Byoung_wook on 2021/08/17.
//

import UIKit

class MemoFormVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate{
    
    var subject: String!
    @IBOutlet weak var contents: UITextView!
    @IBOutlet weak var preview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contents.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: Any) {
        guard self.contents.text?.isEmpty == false else {
            let alert = UIAlertController(title: nil, message: "내용을 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        let data = MemoData()
        
        data.title = self.subject
        data.contents = self.contents.text
        data.regdate = Date()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memolist.append(data)
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pick(_ sender: Any) {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        self.present(picker, animated: false)
    }
    
    
   
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      // 선택된 이미지를 미리보기에 표시한다.
        self.preview.image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
      
      // 이미지 피커 컨트롤러를 닫는다.
      picker.dismiss(animated: false)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let contents = textView.text as NSString
        let length = ((contents.length > 15) ? 15: contents.length)
        self.subject = contents.substring(with: NSRange(location: 0, length: length))
        
        self.navigationItem.title = subject
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
