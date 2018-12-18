//
//  ThemeModel.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 03/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import Foundation


struct ThemeData:Codable {
    
    var status : Bool?
    var code : Int?
    var data : [ThemeModel]?
    
}





struct ThemeModel:Codable {
    
    var id : Int?
    var name : String?
    var preview_img : String?
    var path : String?
    var created_at : String?
    
    init(id:Int , name:String , previewimg:String , path:String , createdat:String) {
        self.id = id
        self.name = name
        self.preview_img = previewimg
        self.path = path
        self.created_at = createdat
          
    }
    
}
