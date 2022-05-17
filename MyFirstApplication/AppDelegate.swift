//
//  AppDelegate.swift
//  MyFirstApplication
//
//  Created by Dmytro Hetman on 15.02.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        PostRepository.shared.readFile()
        Request.shared.fetchData(subreddit: Constants.subreddit, limit: Constants.limit, after: "") {
            postsData in
            ActiveSessionPosts.shared.posts = postsData
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        PostRepository.shared.writeToFile(ActiveSessionPosts.shared.posts)
    }


}

