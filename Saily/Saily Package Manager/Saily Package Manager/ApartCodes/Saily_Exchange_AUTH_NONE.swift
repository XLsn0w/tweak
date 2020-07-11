//
//  Saily_Exchange_AUTH_NONE.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/23.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import Foundation
// Do not upload this to git.

import UIKit

// We communicate with daemon over web socket over a random port in range 2333...6666
// auth session_token is an identity ensure the app is running only once
// while session_port is an identify ensure the daemon could find somewhere to read

// Daemon will always accept the infomation of session_port while not session_token
// If our daemon has read a session_token which is differently from exists,
//    daemon woud send back message "Invalid session_token" and then restart.

// We will first build up http server for token sure. It's not encoded
// at 127.0.0.1:session_port/session.token

// Then, later,
// We will send session_port over notify(), yes because I don't want to use XPC cause there might be future mergition,
//    notify("com.Saily.session.init.start_read_port")
//    notify("com.Saily.session.init.addport.0")
//    notify("com.Saily.session.init.addport.1")
//    notify("com.Saily.session.init.addport.2")
//    notify("com.Saily.session.init.addport.3")
//    notify("com.Saily.session.init.addport.4")
//    notify("com.Saily.session.init.addport.5")
//    notify("com.Saily.session.init.addport.6")
//    notify("com.Saily.session.init.addport.7")
//    notify("com.Saily.session.init.addport.8")
//    notify("com.Saily.session.init.addport.9")
//    notify("com.Saily.session.init.end_read_port")

// When notify("com.Saily.session.init.end_read_port") called to daemon,
//   our daemon will immediately read from 127.0.0.1:session_port/session.token to look for session token



let XPC_ins = XPC_Auth()
class XPC_Auth {
    
    var session_token = ""
    var session_port  = 0
    
    init() {
        ensure_token()
        ensure_port()
    }
    
    func abort_notice() {
        print("[*] Using Saily Secert.")
    }
    
    func ensure_token() -> Void {
        if (session_token == "") {
            session_token = UUID().uuidString
            print("[*] Session_token init_ed! :" + session_token)
        }else{
            print("[*] Double init of session_token.")
            session_token = UUID().uuidString
        }
    }
    
    func ensure_port() -> Void {
        if (session_port == 0) {
            session_port = Int.random(in: 2333...6666)
            print("[*] Session_port init_ed! :" + session_port.description)
        }else{
            print("[*] Double init of session_port.")
            session_port = Int.random(in: 2333...6666)
        }
        print("[*] Sending sandbox evn...")
        // "/var/mobile/Containers/Data/Application/"
        Saily.objc_bridge.callToDaemon(with: "com.Saily.path_begin")
        for item in Saily.files.root.dropFirst("/var/mobile/Containers/Data/Application/".count).dropLast("/Documents".count) {
            let read = (item.description != "-") ? item.description : "_"
            let call_str = "com.Saily.path_" + read
            Saily.objc_bridge.callToDaemon(with: call_str)
            usleep(1500)
        }
        usleep(100)
        Saily.objc_bridge.callToDaemon(with: "com.Saily.end_root_path")
    }
    
    func tell_demon_to_listen_at_port() -> Void {
        Saily.objc_bridge.callToDaemon(with: "com.Saily.begin_port")
        for item in XPC_ins.session_port.description {
            let call_str = "com.Saily.addport_" + item.description
            Saily.objc_bridge.callToDaemon(with: call_str)
            usleep(1000)
        }
        Saily.objc_bridge.callToDaemon(with: "com.Saily.end_port")
    }
    
}


// Saily_Exchange_AUTH.swift should contains following struct
////
//import Foundation
//
let AUTH_ins = AUTH_C()
class AUTH_C {

    func encrypt(withStr: String) -> String {
        return withStr
    }

    func abort_notice() {

    }

}

