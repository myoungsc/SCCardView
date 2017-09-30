//
//  SCCardView.swift
//  Pods
//
//  Created by maccli1 on 2017. 8. 31..
//
//

import UIKit
import SDWebImage

@objc public protocol SCCardviewDelegate: class {
    func SCCardSelectorCard(_ index: Int, dic: [String: Any])
    func SCCardURLIndexRefresh(_ img: UIImage)
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
    public var currentIndex: Int = 0
    
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
    
    
    @objc func gestureDown(_ recognizer: UISwipeGestureRecognizer) {
        let cell = recognizer.view as! CellCard
        guard let indexPath = cell.indexPath else {
            return
        }
        delegate?.SCCardDownCardAction!(indexPath)
    }
    
    @objc func gestureUp(_ recognizer: UISwipeGestureRecognizer) {
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
        if var dic: [String: Any] = dicParameta[indexPath.row] {
            if let img: UIImage = dic["image"] as? UIImage {
                
                // only Use Image
                guard let strUrl: String = dic["url"] as? String else {
                    cell.cardImg.image = img
                    return cell
                }
                
                // use url
                cell.cardImg.sd_setImage(with: URL(string: strUrl),
                                         placeholderImage: img,
                                         options: .cacheMemoryOnly,
                                         completed: { downImg, err, type, url in
                                            
                                            cell.cardImg.image = downImg
                                            
                                            dic["image"] = downImg
                                            self.dicParameta[indexPath.row] = dic
                                            if indexPath.row == self.currentIndex {
                                                self.delegate?.SCCardURLIndexRefresh(downImg!)
                                            }
                })
            } else {
                print("error - \"image\" key value is Required. Please refer to the git README.md.")
            }
        }
        
        return cell
    }
    
    // Click Cell
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let dic: [String: Any] = dicParameta[indexPath.row] {
            currentIndex = indexPath.row
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

