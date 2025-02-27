//
//  SceneDelegate.swift
//  test-for-VK
//
//  Created by Dmitrii Imaev on 17.07.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let vc = WeatherViewController()
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}

