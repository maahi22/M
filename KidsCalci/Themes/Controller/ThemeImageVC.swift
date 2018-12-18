//
//  ThemeImageVC.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 23/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage


class ThemeImageVC: UIViewController {

    
    var itemIndex : Int = 0
    var totalImageCount : Int = 0
    
    var theme : ThemeModel?
    var relmTheme : RealmThemeModel?
    
    @IBOutlet weak var themeImageView: UIImageView!
    @IBOutlet weak var themeName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let themes = theme else { return  }
        let themeFolderName = KidsCalciUserDefaults.getTheme()
        if themes.id == 0 {
            themeName.text = themes.name ?? ""
            let img = UIImage(named: "Classroom")
            themeImageView.image = img
            lblPrice.text = "Free"
            
//            downloadView.isHidden = true
//            if themeFolderName == "" {
//                statusImageView.image = UIImage(named: "selectTheme")
//            }else{
//                statusImageView.image = UIImage(named: "barbuttonBlank")//UIImage()
//            }
            
        }else{
            
            guard let themName = themes.name else {return}
            themeName.text =  themName
            lblPrice.text = "Free"
            
            //load image
            guard let id2 = themes.id else{ return }
            guard let imgName = themes.preview_img else{ return}
            let imgUrlStr = BASE_URL + "theme/\(id2)/\(imgName)"//"theme/\(id2)/IOS/\(imgName)"
            let img = UIImage(named: "placeholder")
            themeImageView.sd_setImage(with: URL(string: imgUrlStr), placeholderImage: img)
            
//            if themeFolderName.lowercased() == themName.lowercased() {
//                statusImageView.image = UIImage(named: "selectTheme")
//            }else{
//                statusImageView.image = UIImage(named: "barbuttonBlank")//UIImage()
//            }
           
            
            downloadImg(imgUrlStr, theme: themes)
            
            //Check theme download
//            guard let path = themes.path else {return}
//            if checkFolderExist(path.fileName()){
//                downloadView.isHidden = true
//            }else{
//                downloadView.isHidden = false
//            }
            
        }

        
        
    }

    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func downloadImg(_ url:String , theme:ThemeModel){
        
        // Use Alamofire to download the image
        let remoteImageURL:URL! = URL(string: url)
        
        Alamofire.request(remoteImageURL).responseData { [weak self](response) in
            
            guard  let stringSelf = self else{ return}
            
            if response.error == nil {
                print(response.result)
                
                // Show the downloaded image:
                if let data = response.data {
                    let img = UIImage(data: data)
                    
                    if let image = img{
                        
                        //     stringSelf.activityIndicator.stopAnimating()
                        guard let themName = theme.name else {return}
                        // Save theme image in doc folder with theme name
                        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let fileName = themName + "_background"
                        // create the destination file url to save your image
                        let fileURL = documentsDirectory.appendingPathComponent(fileName)
                        saveImageInDocDir(image, fileURL: fileURL)
                        
                        
                    }
                    
                    
                    
                }
            }
        }
    }
    
    
}
