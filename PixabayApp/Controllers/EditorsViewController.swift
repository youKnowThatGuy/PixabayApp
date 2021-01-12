//
//  EditorsViewController.swift
//  PixabayApp
//
//  Created by Клим on 06.12.2020.
//

import UIKit

class EditorsViewController: UICollectionViewController {
    
    private var images: [UIImage?] = []
    private var imagesInfo = [ImageInfo]()
    
    private var activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    
    private func configureView(){
        collectionView.collectionViewLayout = customLayout()
        loadImages()
        setupSpinner(spinner: activityIndicator)
        let logoImage = UIImage(named: "logo")!
        self.navigationItem.titleView = UIImageView(image: logoImage)
        
    }
    
    private func setupSpinner(spinner: UIActivityIndicatorView) {
            spinner.hidesWhenStopped = true
            spinner.style = .medium
            spinner.color = .blue
            spinner.frame = collectionView.bounds
            spinner.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            collectionView.addSubview(activityIndicator)
        }

    
    private func loadImages(){
        //images.removeAll()
        updateUI()
        activityIndicator.startAnimating()
        NetworkService.shared.fetchEditorsImages(amount: 87) { (result) in
            self.activityIndicator.stopAnimating()
            
            switch result{
            case let .failure(error):
                print(error)
            
            case let .success(imagesInfo):
                self.imagesInfo = imagesInfo
                self.images = Array(repeating: nil, count: imagesInfo.count)
                self.updateUI()
            }
        }
    }
    
    
    
    private func updateUI(){
        self.collectionView.reloadSections(IndexSet(arrayLiteral: 0))
    }

    private func getCachedImages(){
        CacheManager.shared.getCachedImages { (images) in
            self.images = images
        }
    }
    
    private func loadSingleImage(for cell: ImageCell,at index: Int){
        let info = imagesInfo[index]
        
        CacheManager.shared.getImage(with: info.id) { (image) in
            if (image != nil){
                //self.images.append(image)
                self.images[index] = image
                cell.configure(with: self.images[index])
                return
            }
            NetworkService.shared.loadImage(from: info.webformatURL) { (image) in
                self.images[index] = image
                //self.images.append(image)
                CacheManager.shared.cacheImage(image, with: info.id)
                cell.configure(with: self.images[index])
            }
        }
    }

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "showEditorsImage":
            guard let vc = segue.destination as? ImageDetailViewController,
                  let image = sender as? ImageInfo
            else {fatalError("Invalid data passed")}
            vc.imageInfo = image
            
        default:
            break
        }
    }
    
    
    
    private let spacing: CGFloat = 1
    
    /*
    private func prepareLayout(){
        let width = view.bounds.width
        let summarySpacing = spacing * (numberOfItemsPerRow - 1)
        let insets = 2  * spacing
        let rawWidth = width - summarySpacing - insets
        
        let cellWidth = rawWidth / numberOfItemsPerRow
        
        let itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        collectionView.collectionViewLayout = StandartLayout(itemSize: itemSize, insetForSection: UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing), lineSpacing: spacing, interItemSpacing: spacing)
        
    }
    */
    
    
    //MARK: custom layout
    private func customLayout()-> UICollectionViewLayout{
        
        //second layer
        let mainItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)))
        mainItem.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        
        let pairItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1.0)))
        pairItem.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        
        let mainWithPairGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(4/9)), subitems: [mainItem, pairItem])
        
        //third layer
        let tripletItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/4), heightDimension: .fractionalHeight(1.0)))
        tripletItem.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        
        let tripletGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/9)), subitems: [tripletItem, tripletItem, tripletItem, tripletItem])
        
        //fourth layer
        let mainItemR = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1.0)))
        mainItem.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        
        let pairItemR = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)))
        pairItem.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        
        let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)), subitem: pairItemR, count: 2)
        
        
        let mainWithPairReverse = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(4/9)), subitems: [trailingGroup, mainItemR])
        
        //final preparations
        
        let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(10/9)), subitems: [
            
            mainWithPairGroup,
            tripletGroup,
            mainWithPairReverse
        ])
        
        let section = NSCollectionLayoutSection(group: nestedGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
        
    
    
    
    
    
    // MARK: DataSource
/*
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
*/
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else{
            fatalError("Invalid Cell kind")
        }
        loadSingleImage(for: cell, at: indexPath.row)
        //cell.configure(with: images[indexPath.row])
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = imagesInfo[indexPath.row]
        performSegue(withIdentifier: "showEditorsImage", sender: selectedImage)
    }
    
}



    
    
    
    
    
    // MARK: UICollectionViewDelegate

    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    /*
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }


    
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
*/
//}
