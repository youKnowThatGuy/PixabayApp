//
//  ImageDetailViewController.swift
//  PixabayApp
//
//  Created by Клим on 22.12.2020.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    @IBOutlet weak var fullImageView: UIImageView!
    
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorAvatarView: UIImageView!
    @IBOutlet weak var tagsLabel: UILabel!
    
    var imageInfo: ImageInfo!
    var parentDataSet: ImageData!
    
    var imageIndex: Int!
    let tapReact = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        tapReact.addTarget(self, action: #selector(imageTapped) )
        fullImageView.addGestureRecognizer(tapReact)
        setupGestures()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    private func prepareView(){
        likesLabel.text = "\(imageInfo.likes)"
        commentsLabel.text = "\(imageInfo.comments)"
        viewsLabel.text = "\(imageInfo.views)"
        authorNameLabel.text = "commited by: \(imageInfo.user)"
        tagsLabel.text = "tags: \(imageInfo.tags)"
        loadImage()
        
    }
    //MARK: Left-Right gestures
    private func setupGestures(){
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
            swipeLeft.direction = .left
            self.view.addGestureRecognizer(swipeLeft)

            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
            swipeRight.direction = .right
            self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        
        if gesture.direction == .right && imageIndex != 0  {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "detailVC") as? ImageDetailViewController
            vc?.parentDataSet = parentDataSet
            let prevInfo = parentDataSet.imagesInfo[imageIndex - 1]
            vc?.imageInfo = prevInfo
            vc?.imageIndex = imageIndex - 1
                
                var vcs = self.navigationController?.viewControllers
                vcs!.insert(vc!, at: vcs!.count - 1)
                self.navigationController?.setViewControllers(vcs!, animated: false)
                self.navigationController?.popViewController(animated: true)
           }
        
        else if gesture.direction == .left && imageIndex != parentDataSet.imagesInfo.count - 1 {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "detailVC") as? ImageDetailViewController
            vc?.parentDataSet = parentDataSet
            let nextInfo = parentDataSet.imagesInfo[imageIndex + 1]
            vc?.imageInfo = nextInfo
            vc?.imageIndex = imageIndex + 1
            self.navigationController?.pushViewController(vc!, animated: true)
    
            var vcs = self.navigationController?.viewControllers
            vcs!.remove(at: vcs!.count - 2)
            self.navigationController?.setViewControllers(vcs!, animated: false)
           }
    }
    
    
    private func loadImage(){
        NetworkService.shared.loadImage(from: imageInfo.largeImageURL) { (image) in
            self.fullImageView.image = image
        }
        
        let userPicURL = URL(string: imageInfo.userImageURL )
        NetworkService.shared.loadImage(from: userPicURL) { (image) in
            self.authorAvatarView.image = image
        }
    
    }
    
    @objc func imageTapped() {
        performSegue(withIdentifier: "photoZoom", sender: fullImageView.image)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "photoZoom":
            guard let vc = segue.destination as? ImageZoomViewController,
                  let image = sender as? UIImage
            else {fatalError("invalid data passed")}
            vc.image = image
        default:
            break
        }
    }
    

    

}
