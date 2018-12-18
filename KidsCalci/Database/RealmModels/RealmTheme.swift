//
//  RealmTheme.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 09/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

//class RealmTheme: Object {
//
//    @objc dynamic var status = false
//    @objc dynamic var code  = 0
//    @objc dynamic var data : [RealmThemeModel] = []
//}


//protocol PrimaryKeyAware {
//    var id: Int { get }
//    static func primaryKey() -> String?
//}

class RealmThemeModel: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var preview_img = ""
    @objc dynamic var path = ""
    @objc dynamic var created_at = ""
    
   
    override class func primaryKey() -> String? {
        return "id"
    }
    
    
}
