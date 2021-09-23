//
//  TutorialContentsVC.swift
//  MyMemory
//
//  Created by Byoung_wook on 2021/09/23.
//  Copyright © 2021 rubypaper. All rights reserved.
//

import UIKit

class TutorialContentsVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    
    var pageindex: Int!
    var titleText: String!
    var imageFile: String!
    
    override func viewDidLoad() {
        self.titleLabel.text = self.titleText
        self.titleLabel.sizeToFit()
        
        self.bgImageView.image = UIImage(named: self.imageFile)

    
    }
}
