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
    let tapReact = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapReact.addTarget(self, action: #selector(imageTapped) )
        fullImageView.addGestureRecognizer(tapReact)
        
        prepareView()
        // Do any additional setup after loading the view.
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
        loadImages()
        
    }
    
    private func loadImages(){
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
