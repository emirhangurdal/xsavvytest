

import UIKit
class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    
}

protocol IconVCDelegate {
    func updateIcon (selectedIcon: UIImage)
}

var selectedIndexPath = IndexPath()


class IconViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    static var keyArray = [Int]()
    static var indexPathRowBack = Int()
    var delegate: IconVCDelegate?
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
//    static var selectedIcon = UIImage() {
//
//        didSet {
//
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pickedIcon"), object: nil, userInfo: ["icon": IconViewController.selectedIcon])
//
//            print("IconViewController.selectedIcon \(IconViewController.selectedIcon)")
//
//
//        }
//    }
    
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        print("viewdidload")
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.updateIcon), name: NSNotification.Name(rawValue: "pickedIcon"), object: nil)
        
//        for (key, value) in HomeViewController.selectedIcon {
//            print("Key: \(key), value: \(value)")
//
//            IconViewController.keyArray.append(key)
//            print("keyArray = \(IconViewController.keyArray)")
//        }
        
  
       
        
    }
    
    
    var keyTo = Int()
  
    
    var selectedIndexPathRow = Int()
    
    @objc func updateIcon(notification: Notification) {
        
        
        guard let userInfo = notification.userInfo else {return}
        if let newIcon = userInfo["icon"] as? UIImage {
            
            HomeViewController.categoryIcon = newIcon

            print("newIcon = \(newIcon)")
        }
        
    }
    
    
    static let categoryIcons = [
        UIImage(named: "icons8-airport-100"),
        UIImage(named: "icons8-beach-90"),
        UIImage(named: "icons8-broken-phone-100"),
        UIImage(named: "icons8-car-100"),
        UIImage(named: "icons8-car-service-100"),
    ]
    
    
   
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return IconViewController.categoryIcons.count
      }
      
 
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath) as! MyCollectionViewCell
        let newImage = self.resizeImage(image: IconViewController.categoryIcons[indexPath.row]!, targetSize: CGSize(width: 50, height: 50))

        cell.iconImage.image = newImage
        return cell
      }
    
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let homeView = storyboard.instantiateViewController(identifier: "HomeView") as? HomeViewController
        
        dismiss(animated: true) {
            
            IconViewController.indexPathRowBack = HomeViewController.selectedIndex!
            print("IconViewController.indexPathRowBack = \(IconViewController.indexPathRowBack)")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
           
        }
        
        selectedIndexPathRow = indexPath.row
        
        collectionView.deselectItem(at: indexPath, animated: true)

        HomeViewController.selectedIcon[HomeViewController.selectedIndex!] = IconViewController.categoryIcons[indexPath.row]
        
        for (key, _) in HomeViewController.selectedIcon {
            
            IconViewController.keyArray.append(key)
            

            if let image = HomeViewController.selectedIcon[key] {
                
                print("key = \(key) image = \(image)")
            
            } else {
                print("I am else")
            }
        
        
        }
     
        print("IconViewController.keyArray = \(IconViewController.keyArray)")
        print(" IconViewController.keyArray.uniqued() = \(IconViewController.keyArray.uniqued())")
        
//        print("HomeViewController.selectedIcon = \(HomeViewController.selectedIcon)")
        
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.updateIcon), name: NSNotification.Name(rawValue: "pickedIcon"), object: nil)
        
      }
    
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
  

}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
