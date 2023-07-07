//
//  LazyView.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 03.07.2023.
//

import Foundation
import SwiftUI

struct LazyContentView<Content: View>: View {
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}
