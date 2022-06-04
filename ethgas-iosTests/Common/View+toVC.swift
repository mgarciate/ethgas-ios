//
//  View+toVC.swift
//  ethgas-iosTests
//
//  Created by mgarciate on 4/6/22.
//

import SwiftUI

extension SwiftUI.View {
    func toVC() -> UIViewController {
        let vc = UIHostingController(rootView: self)
        vc.view.frame = UIScreen.main.bounds
        return vc
    }
}
