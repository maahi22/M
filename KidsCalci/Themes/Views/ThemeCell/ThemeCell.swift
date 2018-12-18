//
//  ThemeCell.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 03/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage


class ThemeCell: UICollectionViewCell {
    @IBOutlet weak var themeName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var themeImageView: UIImageView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var downloadView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    static var identifier:String{
        return String(describing: self)
    }
    static var nib:UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    
    var Themes:ThemeModel?{
        
        
        
        didSet{
            guard let themes = Themes else { return  }
           let themeFolderName = KidsCalciUserDefaults.getTheme()
            if themes.id == 0 {
                themeName.text = themes.name ?? ""
                let img = UIImage(named: "Classroom")
                themeImageView.image = img
                downloadView.isHidden = true
                if themeFolderName == "" {
                    lblPrice.text = ThemeApplied
                }else{
                    lblPrice.text = ThemeFree
                }
            
            }else{
               
                guard let themName = themes.name else {return}
                themeName.text =  themName
                //load image
                guard let id2 = themes.id else{ return }
                guard let imgName = themes.preview_img else{ return}
                let imgUrlStr = BASE_URL + "theme/\(id2)/IOS/\(imgName)"
                let img = UIImage(named: "Placeholder")
                themeImageView.sd_setImage(with: URL(string: imgUrlStr), placeholderImage: img)
              //  themeImageView.contentMode = .scaleAspectFit
                if themeFolderName.lowercased() == themName.lowercased() {
                    lblPrice.text = ThemeApplied
                }else{
                    lblPrice.text = ThemeFree
                }
                
                downloadImg(imgUrlStr, theme: themes)
                //Check theme download
//                guard let path = themes.path else {return}
//                if checkFolderExist(path.fileName()){
//                    downloadView.isHidden = true
//                }else{
//                    downloadView.isHidden = false
//                }
                
            }
        }
    }

    
    
    
    var RealmThemes:RealmThemeModel?{
        didSet{
            guard let themes = RealmThemes else { return  }
            let themeFolderName = KidsCalciUserDefaults.getTheme()
            if themes.id == "0" {
                themeName.text = themes.name
                let img = UIImage(named: "Classroom")
                themeImageView.image = img
                downloadView.isHidden = true
                if themeFolderName == "" {
                    lblPrice.text = ThemeApplied
                }else{
                    lblPrice.text = ThemeFree
                }
                
            }else{
                
                let themName = themes.name
                themeName.text =  themName
                let imgName = themes.name
                let imgPath = DocumentDirectoryPath("\(imgName)_background")
                themeImageView.image = getImagebyPath(imgPath)
                if themeFolderName.lowercased() == themName.lowercased() {
                    lblPrice.text = ThemeApplied
                }else{
                    lblPrice.text = ThemeFree
                }
                
                
                //Check theme download
//                 let path = themes.path
//                if checkFolderExist(path.fileName()){
//                    downloadView.isHidden = true
//                }else{
//                    downloadView.isHidden = false
//                }
                
            }
        }
    }
    
    
    
    
    
    
    
    func downloadImg(_ url:String , theme:ThemeModel){
        // Use Alamofire to download the image
        let remoteImageURL:URL! = URL(string: url)
        Alamofire.request(remoteImageURL).responseData { [weak self](response) in
      //    guard  let stringSelf = self else { return}
            if response.error == nil {
                print(response.result)
                // Show the downloaded image:
                if let data = response.data {
                    let img = UIImage(data: data)
                    if let image = img{
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
