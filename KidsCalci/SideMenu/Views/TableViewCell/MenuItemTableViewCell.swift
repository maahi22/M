//
//  MenuItemTableViewCell.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 07/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {

    @IBOutlet weak var menuItemImageView: UIImageView!
    @IBOutlet weak var menuItemNameLabel: UILabel!
    
    
    var menuItem:Section?{
        didSet{
            guard let menuItem = menuItem else { return  }
            menuItemNameLabel.text = menuItem.name
            
            menuItemImageView.image = UIImage(named: menuItem.image)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            menuItemImageView.tintColor = .white
            // menuItemImageView.highlightedImage = UIImage(named: menuItem.selImage)
            
          //  menuItemNameLabel.highlightedTextColor = mainNavBarColor
          //  let backgroundView = UIView()
           // backgroundView.backgroundColor = .white
          //  self.selectedBackgroundView = backgroundView
        }
    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        /*if selected {
            menuItemImageView.tintColor = mainNavBarColor
        }else{
            menuItemImageView.tintColor = .white
        }*/
    }
    
}
