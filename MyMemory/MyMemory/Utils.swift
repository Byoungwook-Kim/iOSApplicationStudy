//
//  Utils.swift
//  MyMemory
//
//  Created by Byoung_wook on 2021/09/23.
//  Copyright © 2021 rubypaper. All rights reserved.
//

import Foundation

extension UIViewController {
    var tutorialSB: UIStoryboard {
        return UIStoryboard(name: "Tutorial", bundle: Bundle.main)
    }
    func instanceTutorialVC(name: String) -> UIViewController? {
        return self.tutorialSB.instantiateViewController(withIdentifier: name)
    }
}
