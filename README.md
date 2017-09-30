# SCCardView

[![CI Status](http://img.shields.io/travis/myoungsc.dev@gmail.com/SCCardView.svg?style=flat)](https://travis-ci.org/myoungsc.dev@gmail.com/SCCardView)
[![Version](https://img.shields.io/cocoapods/v/SCCardView.svg?style=flat)](http://cocoapods.org/pods/SCCardView)
[![License](https://img.shields.io/cocoapods/l/SCCardView.svg?style=flat)](http://cocoapods.org/pods/SCCardView)
[![Platform](https://img.shields.io/cocoapods/p/SCCardView.svg?style=flat)](http://cocoapods.org/pods/SCCardView)

## Description
A view that changes the content by selecting a card. Content can be customized, but images are essential.
You can change the card by clicking on it or by swiping up and down gestures.

## ScreenShot
![](https://github.com/myoungsc/SCCardView/blob/master/SCCardView.gif?raw=true)

## Requirements
```
* Swift 3.0.1
* XCode 8.3.1
* iOS 9.0 (Min SDK)
```

## Installation
SCCardView is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
//Add Podfile
pod "SCCardView" //Swift 4.0
pod "SCCardView", , '~> 0.3.0' //Swift 3.0

//After
pod install
```

## How To Use
If you use a URL, you can set the key value to "url". But "image" is a required parameter. If you use "url", the value of the "image" key will be entered into the placeholder image if it can be empty. The URL image is rendered dependent on SDWebImage.

```Swift
import SCCardView

// Int index, [String: String] key, Value
// Make dummy data (Necessary key Image Card UI)
let dummyData: [Int: [String: Any]] = [0: ["image": UIImage()!,
                                          "title": "Catholic Church",
                                          "url": "https://github.com/myoungsc/SCCardView/blob/master/Example/SCCardView/Images.xcassets/sc0.imageset/sc0.jpg?raw=true",
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


// Delegate
// Selector Card Click. Required Delegate
func SCCardSelectorCard(_ index: Int, dic: [String: Any]) {
    if let img: UIImage = dic["image"] as? UIImage,
        let title: String = dic["title"] as? String,
        let des: String = dic["description"] as? String {
        sccardSubImg.image = img
        sccardSubTitle.text = title
        sccardSubDes.text = des
    }
}

// Refresh content view from down image. Required Delegate
func SCCardURLIndexRefresh(_ img: UIImage) {
    sccardSubImg.image = img
}

// Card Down Gesture. optional Delegate
internal func SCCardDownCardAction(_ indexPath: IndexPath) {
    print("down gesture \(indexPath)")
}

// Card Up Gesture. optional Delegate
internal func SCCardUpCardAction(_ indexPath: IndexPath) {
    print("up gesture \(indexPath)")
}
```

## Author
myoung

[HomePage](http://devsc.tistory.com)

<myoungsc.dev@gmail.com>

## License
SCPageControl is available under the MIT license. See the LICENSE file for more info.