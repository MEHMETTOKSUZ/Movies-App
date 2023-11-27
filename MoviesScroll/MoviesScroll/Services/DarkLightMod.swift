//
//  DarkLightMod.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 20.03.2023.
//

import Foundation
import UIKit

class ThemeHelper {
    static func switchToLightMode() {
        
        UIApplication.shared.connectedScenes.forEach { windowScene in
            if let windowScene = windowScene as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .light
                }
            }
        }
    }
    
    static func switchToDarkMode() {
        UIApplication.shared.connectedScenes.forEach { windowScene in
            if let windowScene = windowScene as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .dark
                }
            }
        }
    }
}

