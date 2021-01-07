//
//  SearchResultsTableViewController.swift
//  PixabayApp
//
//  Created by Клим on 04.01.2021.
//

import UIKit


protocol SuggestedSearch: class {
    // A suggested search was selected; inform our delegate that the selected search token was selected.
    func didSelectSuggestedSearch(word: String)
}



class SearchResultsTableViewController: UITableViewController {
    
  weak var suggestedSearchDelegate: SuggestedSearch?

  var suggestedSearches: [String] = []
    
    var showSuggestedSearches: Bool = false {
        didSet {
            if oldValue != showSuggestedSearches {
                tableView.reloadData()
            }
        }
    }

    func updateSearchTable(newSearch: String){
        if (suggestedSearches.count >= 5){
            suggestedSearches.removeFirst()
        }
        suggestedSearches.append(newSearch)
        
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestedSearches.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return showSuggestedSearches ? NSLocalizedString("Previous Searches", comment: "") : ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "suggestCell")

        if showSuggestedSearches {
            let suggestedtitle = NSMutableAttributedString(string: suggestedSearches[indexPath.row])
            /*
            suggestedtitle.addAttribute(NSAttributedString.Key.foregroundColor,
                                        value: UIColor.label,
                                        range: NSRange(location: 0, length: suggestedtitle.length))
 */
            cell.textLabel?.attributedText = suggestedtitle
            
            // No detailed text or accessory for suggested searches.
            cell.detailTextLabel?.text = ""
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // We must have a delegate to respond to row selection.
        guard let suggestedSearchDelegate = suggestedSearchDelegate else { return }
            
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Make sure we are showing suggested searches before notifying which token was selected.
        if showSuggestedSearches {
            // A suggested search was selected; inform our delegate that the selected search token was selected.
            let wordToInsert = suggestedSearches[indexPath.row]
            suggestedSearchDelegate.didSelectSuggestedSearch(word: wordToInsert)
        } 
    }




}
