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
        longPressRecognizer.minimumPressDuration = 0.5
        imageScrollView.addGestureRecognizer(longPressRecognizer)
        
    }
    
    
    
    //-MARK: image saving func
    @objc func imageTapped(sender: UILongPressGestureRecognizer){
        //let firstActivityItem = "Description you want.."
            
            // If you want to use an image
            let savImage : UIImage = image
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [savImage], applicationActivities: nil)
            
            // This lines is for the popover you need to show in iPad
            //activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
            
            // This line remove the arrow of the popover to show in iPad
            activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
            
            // Pre-configuring activity items
            activityViewController.activityItemsConfiguration = [
                UIActivity.ActivityType.message, UIActivity.ActivityType.mail, UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.airDrop
            ] as? UIActivityItemsConfigurationReading
            
            // Anything you want to exclude
        /*
            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.postToWeibo,
                UIActivity.ActivityType.print,
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.addToReadingList,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo,
                UIActivity.ActivityType.postToFacebook
            ]
 */
            
            activityViewController.isModalInPresentation = true
            self.present(activityViewController, animated: true, completion: nil)
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
