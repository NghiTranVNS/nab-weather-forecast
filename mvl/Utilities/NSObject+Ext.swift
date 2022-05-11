//
//  NSObject+Ext.swift
//  mvl
//
//  Created by nghitran on 18/02/2022.
//

import Foundation

public extension NSObject {
    @objc class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    @objc var nameOfClass: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
}
