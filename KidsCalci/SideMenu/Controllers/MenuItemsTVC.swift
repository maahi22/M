//
//  MenuItemsTVC.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 07/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit

class MenuItemsTVC: UITableViewController {

    @IBOutlet weak var menuHeaderView: UIView!
    @IBOutlet weak var menuHeaderImageView: UIImageView!
    @IBOutlet weak var menuFotterView: UIView!
    @IBOutlet weak var menuFotterImageView: UIImageView!
    @IBOutlet weak var lblcompName: UILabel!
    @IBOutlet weak var backImageView: UIImageView!
   
    
    let gradientLayer = CAGradientLayer()
    var menuItems :[Section] = [Section]()
    let bgLayer = CAShapeLayer()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        //Load gradient
        gradientLayer.frame = self.tableView.bounds
        let color1 = UIColor.hexStringToUIColor(hex: topOrangegradiant).cgColor as CGColor
        let color2 = UIColor.hexStringToUIColor(hex: bottomPinkgradiant).cgColor as CGColor
        gradientLayer.colors = [ color1, color2]
        gradientLayer.locations = [0.0, 0.90]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        let bgView = UIView.init(frame: tableView.frame)
        bgView.layer.insertSublayer(gradientLayer, at: 0)
        tableView.backgroundView = bgView
        //End
        
        
        
        self.navigationController?.isNavigationBarHidden = true
        let deviceType = UIDevice.DeviceType.self
        tableView.rowHeight = 45
        if deviceType.IS_IPHONE_5 {
            tableView.rowHeight = 45
        }else if deviceType.IS_IPHONE_6{
            tableView.rowHeight = 50
        }else if deviceType.IS_IPHONE_6P {
            tableView.rowHeight = 55
        }else if deviceType.IS_IPHONE_X {
            tableView.rowHeight = 55
        }
        
        lblcompName.sizeToFit()
        tableView.register(MenuItemTableViewCell.nib, forCellReuseIdentifier: MenuItemTableViewCell.identifier)
       
    }

    
    override func viewDidAppear(_ animated: Bool) {
        getMenuItems() { [weak self](menuItems) in
            guard let strongSelf = self else{return}
            strongSelf.menuItems = menuItems
            strongSelf.tableView.reloadData()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        menuFotterView.backgroundColor = UIColor.clear
        menuFotterView.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 150)
        return menuFotterView
    }
    
    // set height for footer
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       
        let deviceType = UIDevice.DeviceType.self
        if deviceType.IS_IPHONE_4_OR_LESS{
            return 208
        }else if deviceType.IS_IPHONE_5 {
           return 296
        }else if deviceType.IS_IPHONE_6{
            return 385
        }else if deviceType.IS_IPHONE_6P {
            return 444//430
        }else if deviceType.IS_IPHONE_X {
            return 465
        }else{
            return 200
        }

        
    }
}




extension MenuItemsTVC{

    class func getSideMenuImageArray() -> NSArray {
        return ["FeedbackIcon","GetSupportIcon"]
    }
    //MARK: - Menu Items Model
    fileprivate func getMenuItems(completion:([Section])->())  {
        let menuItems = [
             Section(name: "Feedback", items: [], image: "FeedbackIcon", selImage: "", expanded: false,itemType:MenuItemType.feedback),
            Section(name: "Get Support", items: [], image: "GetSupportIcon", selImage: "", expanded: false,itemType:MenuItemType.getSupport)
        ]
        
        completion(menuItems)
    }
    
    
    //MARK: - Functions
    
    
    
    func loadNewView(_ index:Int){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
           
            switch index {
            case 1:
                guard let navViewController = FeedbackVC.getStoryboardInstance(),
                    let _ = navViewController.topViewController as? FeedbackVC
                    else { return  }
                self.present(navViewController, animated: true, completion: nil)
            case 3:
                guard let navViewController = GetSupportVC.getStoryboardInstance(),
                    let _ = navViewController.topViewController as? GetSupportVC
                    else { return  }
                self.present(navViewController, animated: true, completion: nil)
            default:
                print("none")
            }
           
        }
    }
    
    func setCenterView(index:Int)  {
        
        switch menuItems[index].itemType {
        case .feedback:
            sideMenuController?.performSegue(withIdentifier: SideMenuOptions.showFeedback.rawValue, sender: nil)
        case .getSupport:
            sideMenuController?.performSegue(withIdentifier: SideMenuOptions.getSupport.rawValue, sender: nil)
        case .none:
            print("none")
            
        }
        
        loadNewView(index)
    }
    
    
    
    
    
    
    
    
}

extension MenuItemsTVC{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemTableViewCell.identifier, for: indexPath) as? MenuItemTableViewCell else { return UITableViewCell() }
        cell.menuItem = menuItems[indexPath.row]
        
        return cell
    }
}

extension MenuItemsTVC{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        setCenterView(index: indexPath.row)
    }
}
