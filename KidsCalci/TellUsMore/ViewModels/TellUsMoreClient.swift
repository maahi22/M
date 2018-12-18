//
//  TellUsMoreClient.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 13/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit
import Alamofire
import Reachability


class TellUsMoreClient: NSObject {
    // MARK: - Injections
    internal let networkClient = NetworkClient.shared
    
    
    func sendUserInfo(_ nameString:String, age:String,completion:@escaping (Bool,String)->())  {
        
        
        
        let reachability = Reachability()!
        if !reachability.isReachable {
            completion(true, connectionProb)
        }
        
        
        
        let deviceType = KidsCalciUserDefaults.getDeviceType()
        let deviceDetail = KidsCalciUserDefaults.getDeviceDetail()
        let appName = AppName.VoiceCal.rawValue
        
        
        let apiname = BASE_URL + GET_Userinfo_Url
        let headers = ["clientid": clientId,"clientsecret":clientSecret,"Content-Type":"application/x-www-form-urlencoded"] as [String:String]
        let params = ["device_type": deviceType,
                      "device_details":deviceDetail,
                      "name": nameString,
                      "app_name" :appName,
                      "age" :age] as [String:Any]
        
        Alamofire.request(apiname, method: .post, parameters: params, encoding:  URLEncoding.httpBody, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case.success(let data):
                print("success",data)
                
                guard let value = response.result.value else {
                    return
                }
                
                guard let json = value as? [String: AnyObject] else {
                    return
                }
                
                guard let status :Bool = json["status"] as? Bool else{ return }
                if !status{
                    guard let errdict = json["error"] else{
                        completion(false, ThereIsSomeproble )
                        return
                    }
                    
                    guard let errorMessage = errdict["error_message"] as? [String: AnyObject] else{
                        completion(false, ThereIsSomeproble )
                        return
                    }
                    
                    guard let messageArr = errorMessage["message"]  as? [String] else {
                        completion(false, ThereIsSomeproble )
                        return
                    }
                    
                    if messageArr.count > 0 {
                        guard let messageString = messageArr[0] as? String else {
                            completion(false, ThereIsSomeproble )
                            return
                        }
                        
                        completion(false, messageString )
                    }else{
                        completion(false, ThereIsSomeproble )
                    }
                }else{
                    
                    
                    print("json",json)
                    guard let dict = json["data"] else{
                        completion(false, ThereIsSomeproble )
                        return
                    }
                    completion(true, dict["message"] as! String )
                }
            case.failure(let error):
                //if let messageModel = decodeJSON(type: MessModel.self, from: data as! Data) {
                completion(false, ThereIsSomeproble )
                //}
                print("Not Success",error)
                
            }
        }
    }
    
    
}


extension TellUsMoreClient{
    static func getStoryboardInstance() -> UINavigationController?{
        let storyborad = UIStoryboard(name: String(describing: self), bundle: nil)
        guard let navViewController = storyborad.instantiateInitialViewController()  as? UINavigationController else { return nil }
        return navViewController
    }
}
