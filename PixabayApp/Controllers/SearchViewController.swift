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
    
    var searchController: UISearchController!
    
    /// The search results table view.
    var resultsTableController: SearchResultsTableViewController!
    
    
    private var activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
          layout.delegate = self
        }

        loadRecentSearch()
        configureView()
        
    }
    
    private func configureView(){
        //prepareLayout()
        setupSpinner(spinner: activityIndicator)
        setupSearchBar()

    }
    
    
    
    private func loadRecentSearch(){
        CacheManager.shared.getSearches { (searches) in
            self.resultsTableController.suggestedSearches = searches.components(separatedBy: ", ")
        }
    }
    
    private func saveRecentSearch(query: String){
        resultsTableController.updateSearchTable(newSearch: query)
        CacheManager.shared.cacheSearches(resultsTableController.suggestedSearches.joined(separator: ", "))
        
    }
    
    private func setupSearchBar(){
        resultsTableController = SearchResultsTableViewController()
        resultsTableController.suggestedSearchDelegate = self
        
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
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
    
    
    
    
    
    //-MARK: fLOW LAYOUT
    
    private let numberOfItemsPerRow: CGFloat = 3
    private let spacing: CGFloat = 5
    private func prepareLayout(){
        let width = view.bounds.width
        let summarySpacing = spacing * (numberOfItemsPerRow - 1)
        let insets = 2  * spacing
        let rawWidth = width - summarySpacing - insets
        
        let cellWidth = rawWidth / numberOfItemsPerRow
        
        let itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        collectionView.collectionViewLayout = StandartLayout(itemSize: itemSize, insetForSection: UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing), lineSpacing: spacing, interItemSpacing: spacing)
        
    }
    
    
    
    
    
    
    
    private func loadSingleImage(for cell: ImageCell, at index: Int){
        if let image = images[index]{
            cell.configure(with: image)
            return
        }
        
        let info = imagesInfo[index]
        NetworkService.shared.loadImage(from: info.webformatURL) { (image) in
            self.images[index] = image
            
            CacheManager.shared.cacheImage(image, with: info.id)
            cell.configure(with: self.images[index])
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "showDetailImage":
            guard let vc = segue.destination as? ImageDetailViewController,
                  let image = sender as? ImageInfo
            else {fatalError("Invalid data passed")}
            vc.imageInfo = image
            
        default:
            break
        }
    }
    
    
    
    
    
    
    // MARK: UICollectionViewDataSource
/*
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
*/

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = imagesInfo[indexPath.row]
        performSegue(withIdentifier: "showDetailImage", sender: selectedImage)
    }
  
    
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


extension SearchViewController: PinterestLayoutDelegate {
  func collectionView(
      _ collectionView: UICollectionView,
      heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    return CGFloat(imagesInfo[indexPath.row].webformatHeight)
  }
}



extension SearchViewController{
    func setToSuggestedSearches() {

            resultsTableController.showSuggestedSearches = true
            
            // We are no longer interested in cell navigating, since we are now showing the suggested searches.
            resultsTableController.tableView.delegate = resultsTableController
    }
    
    
}




//MARK: Search Bar config

extension SearchViewController: UISearchBarDelegate{
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.count >= 4 else{
            return
        }
        loadImages(query: query)
        saveRecentSearch(query: query)
        searchController.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.isEmpty {
            // Text is empty, show suggested searches again.
            setToSuggestedSearches()
        } else {
            resultsTableController.showSuggestedSearches = false
        }
    }
    

    
    
    
}

extension SearchViewController: UISearchControllerDelegate {
    
    // We are being asked to present the search controller, so from the start - show suggested searches.
    func presentSearchController(_ searchController: UISearchController) {
        searchController.showsSearchResultsController = true
        setToSuggestedSearches()
    }
}

extension SearchViewController: SuggestedSearch {
    func didSelectSuggestedSearch(word: String) {
         let searchField = navigationItem.searchController?.searchBar
          searchField!.text = word
          loadImages(query: word)
        searchController.dismiss(animated: true, completion: nil)
            
            // Hide the suggested searches now that we have a token.
            resultsTableController.showSuggestedSearches = false
            
            // Update the search query with the newly inserted token.
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


