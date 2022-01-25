//
//  View+exts.swift
//  LoquyApp
//
//  Created by Kelby Mittan on 1/25/22.
//  Copyright © 2022 Kelby Mittan. All rights reserved.
//

import SwiftUI

extension View {

    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    
}
