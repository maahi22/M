//
//  RealmDBHelper.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 09/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit
import Realm
import RealmSwift


class RealmDBHelper: NSObject {

    
    
    //ADD theme data
   class func saveThemesData(_ themeArray :NSArray ) {
        
        var saveArray = [RealmThemeModel]()
        for i in 0...(themeArray.count-1){
            let Dict = themeArray.object(at: i) as! NSDictionary
            let rTheme = RealmThemeModel()
            
            if let name = Dict["name"] , !(name is NSNull){
                rTheme.name  = (name as? String)!
            }
            
            if let id = Dict["id"] , !(id is NSNull){
                if let id = id as? Int {
                    rTheme.id  = String(id)
                }
            }
            
            if let preview_img = Dict["preview_img"] , !(preview_img is NSNull){
                rTheme.preview_img = (preview_img as? String)!
            }
            if let path = Dict["path"] , !(path is NSNull){
                rTheme.path = (path as? String)!
            }
            if let created_at = Dict["created_at"] , !(created_at is NSNull){
                rTheme.created_at = (created_at as? String)!
            }
            
            saveArray.append(rTheme)
        }
        if saveArray.count > 0 {
            saveRealmData(saveArray)
        }
        
    }
    
    
    
    
   class func saveRealmData(_ objects: [Object]) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(objects, update: true)
        }
    }
    
    
    class func deleteAllRecods(){
        
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    //Delete spacific Relm
    class func deletePoducts(){
        
        let realm = try! Realm()
        let allUploadingObjects = realm.objects(RealmThemeModel.self)
        try! realm.write {
            realm.delete(allUploadingObjects)
        }
        //category
        /*  let allcatObjects = realm.objects(Categories.self)
         try! realm.write {
         realm.delete(allcatObjects)
         }*/
        
    }
}
