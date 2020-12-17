//
//  SearchViewController.swift
//  PixabayApp
//
//  Created by Клим on 09.12.2020.
//

import UIKit

class SearchViewController: UICollectionViewController {

    @IBOutlet weak var searchSwitch: UISegmentedControl!
    private var searchFilter = false
    
    private var images: [UIImage?] = []
    private var imagesInfo = [ImageInfo]()
    
    
    private var activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

         //Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ImageCell.identifier)

        // Do any additional setup after loading the view.
    }
    
    private func configureView(){
        setupSpinner(spinner: activityIndicator)
        setupSearchBar()
        //getCachedImages()

    }
    
    private func setupSearchBar(){
        let searchC = UISearchController(searchResultsController: nil)
        searchC.searchBar.placeholder = "Search"
        searchC.searchBar.delegate = self
        searchC.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchC
    }
    
    func choiceCheck(){
        switch searchSwitch.selectedSegmentIndex {
        case 0:
            searchFilter = false
        case 1:
            searchFilter = true
        default:
            searchFilter = false
        }
    }
    
    private func setupSpinner(spinner: UIActivityIndicatorView) {
            spinner.hidesWhenStopped = true
            spinner.style = .medium
            spinner.color = .blue
            spinner.frame = collectionView.bounds
            spinner.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            collectionView.addSubview(activityIndicator)
        }

    
    private func loadImages(query: String){
        images.removeAll()
        updateUI()
        activityIndicator.startAnimating()
        NetworkService.shared.fetchImagesForSearch(query: query ,amount: 70, filter: searchFilter) { (result) in
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
        choiceCheck()
        self.collectionView.reloadSections(IndexSet(arrayLiteral: 0))
    }

    private func getCachedImages(){
        CacheManager.shared.getCachedImages { (images) in
            self.images = images
            self.updateUI()
        }
    }
    
    
    private func loadSingleImage(for cell: ImageCell, at index: Int){
        if let image = images[index]{
            cell.configure(with: image)
            return
        }
        
        let info = imagesInfo[index]
        NetworkService.shared.loadImage(from: info.previewURL) { (image) in
            self.images[index] = image
            
            CacheManager.shared.cacheImage(image, with: info.id)
            cell.configure(with: self.images[index])
        }
    }


    
    
    
    
    
    
    // MARK: UICollectionViewDataSource
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else {
            fatalError("Invalid Cell kind")
        }
    
        loadSingleImage(for: cell, at: indexPath.row)
    
        return cell
    }
}


extension SearchViewController: UISearchBarDelegate{
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.count >= 4 else{
            return
        }
        loadImages(query: query)
    }
}











//-MARK: Flow layout
private let numberOfItemsPerRow: CGFloat = 3
private let spacing: CGFloat = 5

extension SearchViewController: UICollectionViewDelegateFlowLayout{
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let width = view.bounds.width
            let summarySpacing = spacing * (numberOfItemsPerRow - 1)
            let insets = 2  * spacing
            let rawWidth = width - summarySpacing - insets
            
            let cellWidth = rawWidth / numberOfItemsPerRow
            
            return CGSize(width: cellWidth, height: cellWidth)
            
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            
            UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            spacing
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            spacing
        }
}





















    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
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


