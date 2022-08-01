//
//  AppDelegate.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/7/30.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy private(set) var connectionService = ConnectionService()
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: PokemonListViewController(connectionService: connectionService))
        window?.makeKeyAndVisible()
        return true
    }
}
