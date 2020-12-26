//
//  ImageZoomViewController.swift
//  PixabayApp
//
//  Created by Клим on 22.12.2020.
//

import UIKit

class ImageZoomViewController: UIViewController {
    
    var imageScrollView: ImageScrollView!

    var image: UIImage!
    
    private var savingImageisFinished = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        self.setupImageScrollView()
        
        self.imageScrollView.set(image: image)
        
    }
    
    
    private func setupImageScrollView(){
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        setupImageScrollViewLayout()
        imageScrollView.isUserInteractionEnabled = true
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(imageTapped))
        longPressRecognizer.minimumPressDuration = 1.0
        imageScrollView.addGestureRecognizer(longPressRecognizer)
        
    }
    
    
    
    //-MARK: image saving func
    @objc func imageTapped(sender: UILongPressGestureRecognizer){
        
        if (!savingImageisFinished){
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
        savingImageisFinished = true
        }
    }
    
    @objc func saveImage (_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Image has been saved to library.", preferredStyle: .actionSheet)
            
            let button = UIAlertAction(title: "OK", style: .default) { (action) in
                self.savingImageisFinished = false
            }
            
            ac.addAction(button)
            present(ac, animated: true)
        }
    }
    
    
    
    //MARK: layout 
    private func setupImageScrollViewLayout() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
        
    
}
