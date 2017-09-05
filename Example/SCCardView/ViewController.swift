//
//  ViewController.swift
//  SCCardView
//
//  Created by myoungsc.dev@gmail.com on 08/31/2017.
//  Copyright (c) 2017 myoungsc.dev@gmail.com. All rights reserved.
//

import UIKit
import SCCardView

class ViewController: UIViewController, SCCardviewDelegate {

    var screenWidth : CGFloat = UIScreen.main.bounds.size.width
    var screenHeight : CGFloat = UIScreen.main.bounds.size.height
    
    @IBOutlet weak var sccard: SCCardView!
    @IBOutlet weak var sccardSubImg: UIImageView!
    @IBOutlet weak var sccardSubTitle: UILabel!
    @IBOutlet weak var sccardSubDes: UITextView!
    
    @IBOutlet weak var contBottomDes: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Int index, [String: String] key, Value
        // Make dummy data (Necessary key Image Card UI)
        let dummyData: [Int: [String: Any]] = [0: ["image": UIImage(named: "sc0")!,
                                                  "title": "Catholic Church",
                                                  "description": "Maybe famous Catholic Churchsadl"],
                                               1: ["image": UIImage(named: "sc1")!,
                                                   "title": "Beautiful Sea",
                                                   "description": "Beautiful sea anywhere on earth"],
                                               2: ["image": UIImage(named: "sc2")!,
                                                  "title": "Famous temple",
                                                   "description": "A landscape of famous temple"],
                                               3: ["image": UIImage(named: "sc3")!,
                                                  "title": "Pretty Flower",
                                                  "description": "Pretty Flower\nphoto  by myoung father"],
                                               4: ["image": UIImage(named: "sc4")!,
                                                  "title":"Vast Sky",
                                                  "description": "Vast korea sky\nphoto by myoung father"],
                                               5: ["image": UIImage(named: "sc5")!,
                                                  "title": "Leaf",
                                                  "description":"Leaf anywhere on Korea\nphoto by myoung father"]]
        
        sccard.delegate = self
        sccard.cardStyle = .onlyTop
        //if cardstyle round cutom
        /*
         sccard.cardStyle = .custom
         sccard.initCustomCardStyle([.topLeft, .bottomRight])
         */
        sccard.initialViewData(dummyData)
        
        
        
        // Set initial value
        if let dicSubData: [String: Any] = dummyData[0] {
            if let img: UIImage = dicSubData["image"] as? UIImage,
                let title: String = dicSubData["title"] as? String,
                let des: String = dicSubData["description"] as? String {                
                sccardSubImg.image = img
                sccardSubTitle.text = title
                sccardSubDes.text = des
            }
        }
        // Autolayout bottom card ratio
        contBottomDes.constant = sccard.bottomInterval
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: ## SCCardView Delegate ##
    // Selector Card Click
    func SCCardSelectorCard(_ index: Int, dic: [String: Any]) {
        if let img: UIImage = dic["image"] as? UIImage,
            let title: String = dic["title"] as? String,
            let des: String = dic["description"] as? String {
            sccardSubImg.image = img
            sccardSubTitle.text = title
            sccardSubDes.text = des
        }
    }
    
    // Card Down Gesture
    internal func SCCardDownCardAction(_ indexPath: IndexPath) {
        print("down gesture \(indexPath)")
    }
    
    // Card Up Gesture
    internal func SCCardUpCardAction(_ indexPath: IndexPath) {
        print("up gesture \(indexPath)")
    }
}

