//
//  AppDelegate.swift
//  Saily Package Manager
//
//  Updated by Brecken Lusk on 6/6/19.
//  Copyright © 2019 Saily Team. All rights reserved.
//

import UIKit

#if DEBUG
import DoraemonKit
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AUTH_ins.abort_notice()
        // Duang~ This is because the Saily_Exchange_AUTH.swift is and will not be opensourced.
        // Please check Saily_Exchange_AUTH_NONE.swift for details.
        
//        for family: String in UIFont.familyNames {
//            print("\(family)")
//            for names: String in UIFont.fontNames(forFamilyName: family) {
//                print("== \(names)")
//            }
//        }
        
        Saily.apart_init()
        
        #if DEBUG
        DoraemonManager.shareInstance().install()
        #endif
        
        do { // just a joke
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = #colorLiteral(red: 0.2880531251, green: 0.5978398919, blue: 0.9421789646, alpha: 1)
        self.window!.makeKeyAndVisible()
        
        // rootViewController from StoryBoard
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = mainStoryboard.instantiateViewController(withIdentifier: "Saily_UI_Tabbar_INIT_ID")
        self.window!.rootViewController = navigationController
        
        // logo mask
        navigationController.view.layer.mask = CALayer()
        navigationController.view.layer.mask?.contents = UIImage(named: "iConWhiteTransparent.png")!.cgImage
        navigationController.view.layer.mask?.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        navigationController.view.layer.mask?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        navigationController.view.layer.mask?.position = CGPoint(x: navigationController.view.frame.width / 2, y: navigationController.view.frame.height / 2)
        
        // logo mask background view
        let maskBgView = UIView(frame: navigationController.view.frame)
        maskBgView.backgroundColor = UIColor.white
        navigationController.view.addSubview(maskBgView)
        navigationController.view.bringSubviewToFront(maskBgView)
        
        // logo mask animation
        let transformAnimation = CAKeyframeAnimation(keyPath: "bounds")
        transformAnimation.delegate = self as? CAAnimationDelegate
        transformAnimation.duration = 1
        transformAnimation.beginTime = CACurrentMediaTime() + 1 //add delay of 1 second
        let initalBounds = NSValue.init(cgRect: (navigationController.view.layer.mask?.bounds)!)
        let secondBounds = NSValue.init(cgRect: CGRect(x: 0, y: 0, width: 75, height: 75))
        let finalBounds = NSValue.init(cgRect:CGRect(x: 0, y: 0, width: 3333, height: 3333))
        transformAnimation.values = [initalBounds, secondBounds, finalBounds]
        transformAnimation.keyTimes = [0, 0.5, 1]
        transformAnimation.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut), CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)]
        transformAnimation.isRemovedOnCompletion = false
        transformAnimation.fillMode = CAMediaTimingFillMode.forwards
        navigationController.view.layer.mask?.add(transformAnimation, forKey: "maskAnimation")
        
        // logo mask background view animation
        UIView.animate(withDuration: 0.1,
                       delay: 1.35,
                       options: .curveEaseIn,
                       animations: {
                        maskBgView.alpha = 0.0
        },
                       completion: { finished in
                        maskBgView.removeFromSuperview()
                        self.window!.backgroundColor = .white
        })
        
        Saily.operation_quene.repo_queue.async {
            Saily.repos_root.refresh_call()
        }
        
        } // visual effects
        
        do {
            // open socket on port
            Saily.objc_bridge.ensureDaemonSocket(at: XPC_ins.session_port, XPC_ins.session_token, Saily.files.root)
            
            //        Saily.objc_bridge.callToDaemon(with: "com.Saily.respring")
            
            // call to daemon
            XPC_ins.tell_demon_to_listen_at_port()
            
            //        Saily_FileU.simple_write(file_path: Saily.files.queue_root + "/command", file_content: "dpkg -l &> " + Saily.files.queue_root + "/dpkgl.out")
            Saily.objc_bridge.callToDaemon(with: "com.Saily.list_dpkg")

            Saily.operation_quene.network_queue.asyncAfter(deadline: .now() + 4) {
                if let dpkgread = Saily_FileU.simple_read(Saily.files.daemon_root + "/dpkgl.out") {
                    print("\n\n\n[*] Daemon online~~ yayayayaa!")
                    print("[*] START DPKG STATUS ---------------------------------------")
                    print(dpkgread)
                    Saily.daemon_online = true
                    var dpkgsplit = dpkgread.split(separator: "\n")
                    while !(dpkgsplit.first?.hasPrefix("|") ?? false) {
                        dpkgsplit.remove(at: 0)
                    }
                    dpkgsplit.remove(at: 0)
                    dpkgsplit.remove(at: 0)
                    dpkgsplit.remove(at: 0)
                    dpkgsplit.remove(at: 0)
                    for item in dpkgsplit {
                        Saily.installed[item.description.split(separator: " ")[1].description.uppercased()] = item.description.split(separator: " ")[2].description.uppercased()
                    }
                    print("[*] END DPKG STATUS ---------------------------------------\n\n\n")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    UIApplication.shared.endIgnoringInteractionEvents()
                })
            }
            UIApplication.shared.beginIgnoringInteractionEvents()
            
        } // daemon init
        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        Saily.test_copy_board()
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


}

