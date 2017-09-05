//
//  CellCard.swift
//  Pods
//
//  Created by maccli1 on 2017. 8. 31..
//
//

import UIKit

class CellCard: UICollectionViewCell {

    @IBOutlet weak var cardImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardImg.layer.masksToBounds = true
    }

}
