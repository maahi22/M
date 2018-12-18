//
//  WebServiceConstant.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 03/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import Foundation


let BASE_URL = "https://dev.evantiv.com/development/evantivapi/public/"//"http://dev.evantiv.com/development/kidscalzi/public/"//

//Headers client_id, client_secret
let imageUrl = "theme/" // ApiService.BASE_URL + "theme/"
//val url = Constant.imageUrl + "$id/$previewName"

let GET_Theme_Url = "api/get-themes"
let GET_Feedback_Url = "api/feedback-create"
let GET_SupportCreate_Url = "api/support-create"
let GET_Userinfo_Url = "api/userinfo-create"


let connectionProb = "Please check your internet connection!"

let clientId = "1"
let clientSecret = "zYtbxG8zg2aB8aUnOaenbEbjq3b1eXQVoaU7b56Z"//"kUTsxfp9Kp5OHVq2E3JTqpUDuMwMiPHsTRcEUeHb"



enum AppName: String {
    case MyFirstCal = "MyFirstCal"
    case KiddieCal = "KiddieCal"
    case VoiceCal = "VoiceCal"
    case Wordlle = "Wordlle"
    case MyFirstStoryBook = "MyFirstStoryBook"
    case MyFirstClock = "MyFirstClock"
    case MyFirstPainting = "MyFirstPainting"
    case MilliPixels = "MilliPixels"
    
}
