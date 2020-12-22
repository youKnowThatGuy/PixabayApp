//
//  ImageZoomViewController.swift
//  PixabayApp
//
//  Created by Клим on 22.12.2020.
//

import UIKit

class ImageZoomViewController: UIViewController {
    
    var imageScrollView: ImageScrollView!
    
    //@IBOutlet weak var fullSizeImageView: UIImageView!
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        setupImageScrollView()
        
        
        self.imageScrollView.set(image: image)
        
    }
    
    func setupImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
        
    
}
