//
//  ProfileVC.swift
//  MyMemory
//
//  Created by prologue on 2017. 6. 9..
//  Copyright © 2017년 rubypaper. All rights reserved.
//

import UIKit
class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  let profileImage = UIImageView() // 프로필 사진 이미지
  let tv = UITableView() // 프로필 목록
    let uinfo = UserInfoManager()
  
  override func viewDidLoad() {
    self.navigationItem.title = "프로필"
    
    // 뒤로 가기 버튼 처리
    let backBtn = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector( close(_:) ))
    self.navigationItem.leftBarButtonItem = backBtn
    
    // 추가되는 부분) 배경 이미지 설정
    let bg = UIImage(named: "profile-bg")
    let bgImg = UIImageView(image: bg)
    bgImg.frame.size = CGSize(width: bgImg.frame.size.width, height: bgImg.frame.size.height)
    bgImg.center = CGPoint(x: self.view.frame.width / 2, y: 40)
    bgImg.layer.cornerRadius = bgImg.frame.size.width / 2
    bgImg.layer.borderWidth = 0
    bgImg.layer.masksToBounds = true
    
    self.view.addSubview(bgImg)
    
    // ① 프로필 사진에 들어갈 기본 이미지
    let image = self.uinfo.profile
    
    // ② 프로필 이미지 처리
    self.profileImage.image = image
    self.profileImage.frame.size = CGSize(width: 100, height: 100)
    self.profileImage.center = CGPoint(x: self.view.frame.width / 2, y: 270)
    
    // ③ 프로필 이미지 둥글게 만들기
    self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
    self.profileImage.layer.borderWidth = 0
    self.profileImage.layer.masksToBounds = true
    
    // ④ 루트 뷰에 추가
    self.view.addSubview(self.profileImage)
    
    // 테이블 뷰
    self.tv.frame = CGRect(x: 0,
                           y: self.profileImage.frame.origin.y + self.profileImage.frame.size.height + 20,
                           width: self.view.frame.width,
                           height: 100)
    self.tv.dataSource = self
    self.tv.delegate = self
    self.view.addSubview(self.tv)
    
    // 내비게이션 바 숨김 처리
    self.navigationController?.navigationBar.isHidden = true
    self.drawBtn()
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(profile(_:)))
    self.profileImage.addGestureRecognizer(tap)
    self.profileImage.isUserInteractionEnabled = true
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
    
    cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
    cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
    cell.accessoryType = .disclosureIndicator
    
    switch indexPath.row {
      case 0 :
        cell.textLabel?.text = "이름"
        cell.detailTextLabel?.text = self.uinfo.name ?? "Login please"
      case 1 :
        cell.textLabel?.text = "계정"
        cell.detailTextLabel?.text = self.uinfo.account ?? "Login please"
      default :
        ()
    }
    return cell
  }
  
  @objc func close(_ sender: Any) {
    self.presentingViewController?.dismiss(animated: true)
  }
    
    @objc func doLogin(_ sender:Any) {
        let loginAlert = UIAlertController(title: "LOGIN", message: nil, preferredStyle: .alert)
        
        loginAlert.addTextField() {
            (tf) in tf.placeholder = "Your Account"
        }
        loginAlert.addTextField() {
            (tf) in tf.placeholder = "Password"
            tf.isSecureTextEntry = true

        }
        
        loginAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        loginAlert.addAction(UIAlertAction(title: "Login", style: .destructive) {
            (_) in
            let account = loginAlert.textFields?[0].text ?? ""
            let passwd = loginAlert.textFields?[1].text ?? ""
            
            if self.uinfo.login(account: account, passwd: passwd) {
                self.tv.reloadData()
                self.profileImage.image = self.uinfo.profile
                self.drawBtn()
                
            } else {
                let msg = "로그인에 실패하였습니다"
                let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            }
        })
        self.present(loginAlert, animated: false)
    }
    
    @objc func doLogout(_ sender: Any) {
        let msg = "로그아웃하시겠습니까?"
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive){
            (_) in
            if self.uinfo.logout() {
                self.tv.reloadData()
                self.profileImage.image = self.uinfo.profile
                self.drawBtn()
            }
        })
        self.present(alert, animated: false)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.uinfo.isLogin == false {
            self.doLogin(self.tv)
        }
    }
    
    func drawBtn() {
        let v = UIView()
        v.frame.size.width = self.view.frame.width
        v.frame.size.height = 40
        v.frame.origin.x = 0
        v.frame.origin.y = self.tv.frame.origin.y + self.tv.frame.height
        v.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        
        self.view.addSubview(v)
        
        let btn = UIButton(type: .system)
        btn.frame.size.width = 100
        btn.frame.size.height = 30
        btn.center.x = v.frame.size.width / 2
        btn.center.y = v.frame.size.width / 2
        
        if self.uinfo.isLogin == true {
            btn.setTitle("로그아웃", for: .normal)
            btn.addTarget(self, action: #selector(doLogout(_:)), for: .touchUpInside)
        } else {
            btn.setTitle("로그인", for: .normal)
            btn.addTarget(self, action: #selector(doLogin(_:)), for: .touchUpInside)
        }
        v.addSubview(btn)
    }
    
    func imgPicker(_ source: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    @objc func profile(_ sender: UIButton) {
        guard self.uinfo.account != nil else {
            self.doLogin(self)
            return
        }
        
        let alert = UIAlertController(title: nil, message: "사진을 가져올곳을 선택해 주세요", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "카메라", style: .default){
                (_) in self.imgPicker(.camera)
            })
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            alert.addAction(UIAlertAction(title: "저장된 앨범", style: .default){
                (_) in self.imgPicker(.savedPhotosAlbum)
            })
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "포토라이브러리", style: .default){
                (_) in self.imgPicker(.photoLibrary)
            })
        }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.uinfo.profile = img
            self.profileImage.image = img
        }
        
        picker.dismiss(animated: true)
    }
}
