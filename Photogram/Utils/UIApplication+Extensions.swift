//
//  UIApplication+Extensions.swift
//  Photogram
//
//  Created by Eugene Goloboyar on 04.05.2023.
//

import Foundation
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
