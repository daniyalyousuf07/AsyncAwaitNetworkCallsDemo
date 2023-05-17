//
//  AppKeychain.swift
//  Combine-SyncAsync-Networking-Demo
//
//  Created by Daniyal Yousuf on 2023-05-13.
//

import Foundation

protocol AppKeychain {
    var token: String? { get set }
    var username: String? { get set }
    var password: String? { get set }
}

final class SampleAppKeychain {
    
    private enum Keys {
        static let token = "sample_app_keychain_token"
        static let username = "sample_app_keychain_username"
        static let password = "sample_app_keychain_password"
    }
    
    static let shared: SampleAppKeychain = .init()
    private init() {}
}

extension SampleAppKeychain: AppKeychain {
    
    var username: String? {
        get {
            // MARK: - USE KEYCHAIN WRAPPER HERE - NOT COVERED IN THIS REPO SAMPLE.
           return "USE_SECURE_STORAGE_SUCH_AS_KEYCHAINWRAPPER_POD@GMAIL.COM"
        }
        set {
            if let newValue = newValue {
                //
            } else {
             //
            }
        }
    }
    
    var password: String? {
        get { // MARK: - USE KEYCHAIN WRAPPER HERE - NOT COVERED IN THIS REPO SAMPLE.
            return "USE_SECURE_STORAGE_SUCH_AS_KEYCHAINWRAPPER_POD@GMAIL.COM"
        }
        set {
            if let newValue = newValue {
              
            } else {
           
            }
        }
    }
    
    var token: String? {
        get { // MARK: - USE KEYCHAIN WRAPPER HERE - NOT COVERED IN THIS REPO SAMPLE.
          return nil
        }
        set {
            if let newValue = newValue {
              
            } else {
    
            }
        }
    }
}
