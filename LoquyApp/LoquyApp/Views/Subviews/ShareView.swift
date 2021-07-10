//
//  ShareView.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 5/13/21.
//  Copyright © 2021 Kelby Mittan. All rights reserved.
//

import SwiftUI

struct ShareView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIActivityViewController

    let items: [Any]

    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareView>) -> UIActivityViewController {
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityController.excludedActivityTypes = [.saveToCameraRoll,.airDrop,.assignToContact,.openInIBooks]
        return activityController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareView>) {
        
    }
}
