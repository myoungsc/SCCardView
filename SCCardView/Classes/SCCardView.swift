//
//  SCCardView.swift
//  Pods
//
//  Created by maccli1 on 2017. 8. 31..
//
//

import UIKit

@objc public protocol SCCardviewDelegate: class {
    func SCCardSelectorCard(_ index: Int, dic: [String: Any])
    @objc optional func SCCardDownCardAction(_ indexPath: IndexPath)
    @objc optional func SCCardUpCardAction(_ indexPath: IndexPath)
}

public class SCCardView: UIView {
    
    weak public var delegate: SCCardviewDelegate?
    
    public enum cardShape: Int {
        case none = 0
        case custom
        case onlyTop
        case onlyBottom
        case all
    }
    
    lazy var collectionCard = UICollectionView()
    
    var screenWidth : CGFloat = UIScreen.main.bounds.size.width
    var screenHeight : CGFloat = UIScreen.main.bounds.size.height
    
    public var bottomInterval: CGFloat = UIScreen.main.bounds.size.height*0.25-10
    public var cardStyle: cardShape = .none
    
    var rectCorners: UIRectCorner = []
    var dicParameta: [Int: [String: Any]] = [:]
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)!
    }
    
    public override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // ## set Data and UICollectionView Setting ##
    public func initialViewData(_ dic: [Int: [String: Any]]) {
        
        dicParameta = dic
        
        if cardStyle != .custom {
            cardShapeSettingFromCardStyle()
        }
        
        let aFlowLayout = UICollectionViewFlowLayout()
        aFlowLayout.itemSize = CGSize(width: screenWidth*0.35, height: screenHeight*0.25-10)
        aFlowLayout.scrollDirection = .horizontal
        aFlowLayout.minimumLineSpacing = 10.0
        aFlowLayout.minimumInteritemSpacing = 10.0
        aFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10)
        
        collectionCard = UICollectionView(frame: CGRect(x: 0,
                                                        y: screenHeight*0.75,
                                                        width: screenWidth,
                                                        height: screenHeight*0.25),
                                          collectionViewLayout: aFlowLayout)
        collectionCard.delegate = self
        collectionCard.dataSource = self
        collectionCard.backgroundColor = UIColor.clear
        collectionCard.showsHorizontalScrollIndicator = false
        
        let bundle = Bundle(for: type(of: self))
        collectionCard.register(UINib.init(nibName: "CellCard", bundle: bundle), forCellWithReuseIdentifier: "cell")
        self.addSubview(collectionCard)
        
        collectionCard.reloadData()
    }
    
    // setting cardStyle
    // use cardStyle
    private func cardShapeSettingFromCardStyle() {
        switch cardStyle {
        case .onlyTop:
            rectCorners = [.topRight, .topLeft]
        case .onlyBottom:
            rectCorners = [.bottomRight, .bottomLeft]
        case .all:
            rectCorners = [.allCorners]
        default: //none
            break
        }
        
    }
    
    // custom corner
    public func initCustomCardStyle(_ value: UIRectCorner) {
        rectCorners = value
    }
    
    
    func gestureDown(_ recognizer: UISwipeGestureRecognizer) {
        let cell = recognizer.view as! CellCard
        guard let indexPath = cell.indexPath else {
            return
        }
        delegate?.SCCardDownCardAction!(indexPath)
    }
    
    func gestureUp(_ recognizer: UISwipeGestureRecognizer) {
        let cell = recognizer.view as! CellCard
        guard let indexPath = cell.indexPath else {
            return
        }
        delegate?.SCCardUpCardAction!(indexPath)
    }
    

}


//MARK: UICollectionView Delegate, DataSource
extension SCCardView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // number of sections
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // count of cell item
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dicParameta.count
    }
    
    // initial cell item
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CellCard
        
        cell.cardImg.image = UIImage(named: "")
        cell.cardImg.frame = CGRect(x: 0, y: 0, width: screenWidth*0.35, height: screenHeight*0.25-10)
        
        // round corner to cell
        let maskPath = UIBezierPath(roundedRect: cell.cardImg.bounds,
                                    byRoundingCorners: rectCorners,
                                    cornerRadii: CGSize(width: 10.0, height: 10.0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = cell.cardImg.bounds
        maskLayer.path = maskPath.cgPath
        cell.cardImg.layer.mask = maskLayer
        
        // initial Gesture
        // down gesture
        let downGesture = UISwipeGestureRecognizer(target: self, action: #selector(gestureDown(_:)))
        downGesture.direction = .down
        cell.addGestureRecognizer(downGesture)
        
        //up gesture
        let upGesture = UISwipeGestureRecognizer(target: self, action: #selector(gestureUp(_:)))
        upGesture.direction = .up
        cell.addGestureRecognizer(upGesture)
        
        
        //initial image
        if let dic: [String: Any] = dicParameta[indexPath.row] {
            if let img: UIImage = dic["image"] as? UIImage {
                cell.cardImg.image = img
            }
        }        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { //셀 아이템 선택 했을 경우 호출
        if let dic: [String: Any] = dicParameta[indexPath.row] {
            delegate?.SCCardSelectorCard(indexPath.row, dic: dic)
        }
    }    
}

//MARK: Collection indexPath From Cell
extension UICollectionViewCell {
    var indexPath: IndexPath? {
        return (superview as? UICollectionView)?.indexPath(for: self)
    }
}



















