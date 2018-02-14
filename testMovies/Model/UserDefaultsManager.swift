//
//  UserDeafultsManager.swift
//  testMovies
//
//  Created by Lara Poveda Arana on 14/02/2018.
//  Copyright © 2018 lpoveda. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    
    private static let savedIdsKey = "savedIds"
    
    static var savedIds: [Int]? {
        get {
            return UserDefaults.standard.array(forKey: savedIdsKey) as! [Int]?
        }
        set {
            UserDefaults.standard.set(newValue, forKey: savedIdsKey)
        }
    }
    
    private static let baseurlKey = "baseurl"
    
    static var baseurl: String? {
        get {
            return UserDefaults.standard.object(forKey: baseurlKey) as! String?
        }
        set {
            UserDefaults.standard.set(newValue, forKey: baseurlKey)
        }
    }
    
    func remove(key: String){
        UserDefaults.standard.removeObject(forKey: key)
    }
}
