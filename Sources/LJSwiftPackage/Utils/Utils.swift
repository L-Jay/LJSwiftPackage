//
//  Utils.swift
//  
//
//  Created by 崔志伟 on 2023/5/3.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
  let key: String
  let defaultValue: T

  var wrappedValue: T {
    get {
      return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
    }
    set {
      UserDefaults.standard.set(newValue, forKey: key)
    }
  }
}
