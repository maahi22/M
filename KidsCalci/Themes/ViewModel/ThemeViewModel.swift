//
//  ThemeViewModel.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 03/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit
import CoreData
import Realm
import RealmSwift


class ThemeViewModel: NSObject {
    
    @IBOutlet private var themeClient:ThemeClient!
    var themesList:[ThemeModel]?
    var rlmThemeList : Results<RealmThemeModel>!
    var dataActiveStatus = false
    
    func getThemes(completion:@escaping(Bool,String)->())  {
        
        themeClient.getThemes { [weak self] (themesList, message) in
            guard let strongSelf = self else{return}
            if let themesList = themesList{
                strongSelf.themesList = themesList
               strongSelf.dataActiveStatus = false
                
                
                var saveArray = [RealmThemeModel]()
                //Save 0 element
                let rTheme = RealmThemeModel()
                rTheme.id  = "0"
                rTheme.name  = "Classroom"
                rTheme.preview_img  = ""
                rTheme.path  = ""
                rTheme.created_at  = ""
                saveArray.append(rTheme)
                
                
                
                for theme in strongSelf.themesList!  {
                   
                    
                    let model = theme
                    let rTheme = RealmThemeModel()
                    if let name = model.name {
                        rTheme.name  = name
                    }
                    
                    if let id = model.id {
                          rTheme.id  = "\(id)"
                    }
                    
                    if let preview_img = model.preview_img {
                        rTheme.preview_img = preview_img
                    }
                    if let path = model.path {
                        rTheme.path = path
                    }
                    if let created_at = model.created_at {
                        rTheme.created_at = created_at
                    }
                    
                    saveArray.append(rTheme)
                    
                }
                
                if saveArray.count > 0 {
                    RealmDBHelper.saveRealmData(saveArray)
                }
                
                //DB Ended
                
               //Add-default theme
                let theme = ThemeModel(id: 0, name: "Classroom", previewimg: "", path: "", createdat: "")
                strongSelf.themesList?.insert(theme, at: 0)
                //Return
                completion(true,message)
            }else{
                
                //No internet get data from DB
                
               /* var saveArray = [RealmThemeModel]()
                //Save 0 element
                let rTheme = RealmThemeModel()
                rTheme.id  = "0"
                rTheme.name  = "Classroom"
                rTheme.preview_img  = ""
                rTheme.path  = ""
                rTheme.created_at  = ""
                saveArray.insert(rTheme, at: 0)
                if saveArray.count > 0 {
                    RealmDBHelper.saveRealmData(saveArray)
                }
                
                //Add-default theme
                let theme = ThemeModel(id: 0, name: "Classroom", previewimg: "", path: "", createdat: "")
                strongSelf.themesList = [theme]//insert(theme, at: 0)
                */
                
                strongSelf.dataActiveStatus = true
                let realm = try! Realm()
                strongSelf.rlmThemeList = realm.objects(RealmThemeModel.self)
                if strongSelf.rlmThemeList.count == 0 {
                    completion(false,message)
                }
                //Return
                completion(false,message)
                
            }
        }
    }
    
    
    func numberThemes() -> Int {
        
        if dataActiveStatus {
            guard let themes = rlmThemeList else { return 0 }
            return themes.count
        }else{
            guard let themes = themesList else { return 0 }
            return themes.count//(themes.count + 1)
        }
    }
    
    func themesAt(for cellAtIndex:IndexPath) -> ThemeModel? {
            guard let themes = themesList else { return nil }
            return themes[cellAtIndex.item]
    }
    
    func themesByRealmAt(for cellAtIndex:IndexPath) -> RealmThemeModel? {
        guard let themes = rlmThemeList else { return nil }
        return themes[cellAtIndex.item]
    }
    
    
}
