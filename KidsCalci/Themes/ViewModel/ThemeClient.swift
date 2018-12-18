//
//  ThemeClient.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 03/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import Zip


class ThemeClient: NSObject {

    // MARK: - Injections
    internal let networkClient = NetworkClient.shared
    
    //get themes
    func getThemes(completion:@escaping ([ThemeModel]?,String)->())  {
        
        let appName = AppName.VoiceCal.rawValue
        
        let apiname = GET_Theme_Url + "/\(appName)"
        let headers = ["clientid": clientId,"clientsecret":clientSecret] as [String:String]
        
        networkClient.callAPIWithAlamofire(apiname: apiname,
                                           requestType: .get,
                                           params: nil,
                                           headers: headers,
                                           success: { (data, httpResponse) in
                                            
                                            print(httpResponse.statusCode)
                                            
                                            if let themeModel = decodeJSON(type: ThemeData.self, from: data) {
                                                
                                                
                                                completion(themeModel.data, "Success")
                                            }
                                            else if let messageModel = decodeJSON(type: MessageModel.self, from: data) {
                                                completion(nil, messageModel.Message ?? "")
                                            }
                                                
                                            else{
                                                completion(nil,"failed")
                                            }
                                            
        }) { (error, message) in
            
            completion(nil,message)
            
        }
    }
    
    
   //download zip file
    func downloadZipFile(_ theme:ThemeModel,completion:@escaping (Bool,String)->())  {
        
        guard let themeId = theme.id else{ return }
        guard let zipPath = theme.path else{ return}
    //    guard let name = theme.name else{ return}
        let zipUrlStr = BASE_URL + "theme/\(themeId)/\("IOS")/\(zipPath)"
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent(zipPath)
            return (documentsURL, [.removePreviousFile])
        }
        
        Alamofire.download(zipUrlStr, to: destination).responseData { response in
            if let destinationUrl = response.destinationURL {
       //         print("destinationUrl \(destinationUrl.absoluteURL)")
           
                //remove Exist folder
                //let path = DocumentDirectoryPath(zipPath.fileName())
                deleteDirectory(zipPath.fileName())
                
                
            //unzip file
                do {
                    let filePath = URL(string: "\(destinationUrl.absoluteURL)")
                    if let fileurl = filePath {
                        let unzipDirectory = try Zip.quickUnzipFile(fileurl) // Unzip
                        //let zipFilePath = try Zip.quickZipFiles([filePath], fileName: name) // Zip
                        removeFileIfExist(fileurl)
                        completion(true,"Success")
                    }
                }
                catch {
                    print("Something went wrong")
                    completion(false,"some problem")
                }
            }
        }
    }
    
    
    
    func offLineLoadtheme(_ theme:RealmThemeModel,completion:@escaping (Bool,String)->())  {
        let name = theme.path.fileName()
        let documentsURL = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        let filePath = NSString(format:"%@/%@", documentsURL, name) as String
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath){
            completion(true,"Success")
        }else{
            completion(false,ThemeNotDownloadYet)
        }
    }
    
    
}
