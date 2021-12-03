

import UIKit
class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImage: UIImageView!
}
protocol IconVCDelegate: AnyObject {
    func updateIconModel(icon: UIImage, row: Int)
}
class IconViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerTransitioningDelegate {
    
    static var keyArray = [Int]()
    static var indexPathRowBack: Int?
    weak var delegate: IconVCDelegate?
    static var selectedIndexPathRow = Int()
    @IBOutlet weak var collectionView: UICollectionView!
    
    static var selectedIcon = UIImage() {
        didSet {
        }
    }
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        if #available(iOS 13, *) {
            print("This code only runs on iOS 14 and up")
        } else {
            addSwipe()
            print("addSwipe() This code only runs on iOS 13 and lower")
        }
   
    }
     let categoryIcons = [
        UIImage(named: "icons8-airport-100"),
        UIImage(named: "icons8-beach-90"),
        UIImage(named: "icons8-broken-phone-100"),
        UIImage(named: "icons8-car-100"),
        UIImage(named: "icons8-car-service-100"),
        UIImage(named: "icons8-computer-100"),
        UIImage(named: "icons8-cutlery-100"),
        UIImage(named: "icons8-credit-card-100"),
        UIImage(named: "icons8-grocery-64"),
        UIImage(named: "icons8-guitar-90"),
        UIImage(named: "icons8-internet-90"),
        UIImage(named: "icons8-jumper-90"),
        UIImage(named: "icons8-long-skirt-90"),
        UIImage(named: "icons8-parcking-ticket-90"),
        UIImage(named: "icons8-paypal-150"),
        UIImage(named: "icons8-retro-tv-100"),
        UIImage(named: "icons8-shopping-cart-promotion-100"),
        UIImage(named: "icons8-subscription-100"),
        UIImage(named: "icons8-sun-glasses-90"),
        UIImage(named: "icons8-syringe-100"),
        UIImage(named: "icons8-tv-100"),
        UIImage(named: "icons8-wine-100")
    ]
//MARK: - Swipe Mechanism:
    func addSwipe() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
    }

   @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        print("sender.direction = \(sender.direction)")
       dismiss(animated: true) {
           
       }
    }
    
    
  //MARK: CollectionView
    
    
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryIcons.count
      }
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath) as! MyCollectionViewCell
          let newImage = self.resizeImage(image: categoryIcons[indexPath.row]!, targetSize: CGSize(width: 50, height: 50))
        cell.iconImage.image = newImage
        return cell
      }
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        IconViewController.selectedIndexPathRow = indexPath.row

//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let homeView = storyboard.instantiateViewController(identifier: "HomeView") as? HomeViewController
        dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        }
        IconViewController.indexPathRowBack = HomeViewController.selectedIndex!
        HomeViewController.data[HomeViewController.selectedIndex!].icon = (categoryIcons[indexPath.row]?.pngData())!
        do {
            let data = try HomeViewController.singletonHomeVC.encoder.encode(HomeViewController.data)
            try data.write(to: HomeViewController.singletonHomeVC.dataFilePath!)
        } catch {
            print("error, \(error)")
        }
          collectionView.deselectItem(at: indexPath, animated: true)
      }
    
// MARK: - Resize Image
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
//MARK: - Print Array's Unique Elements.

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

