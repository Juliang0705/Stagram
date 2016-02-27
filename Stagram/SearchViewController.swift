//
//  SearchViewController.swift
//  Stagram
//
//  Created by Juliang Li on 2/24/16.
//  Copyright © 2016 Juliang. All rights reserved.
//

import UIKit
import Parse

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var results:[PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        // Do any additional setup after loading the view.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if let results = self.results{
            return results.count
        }else{
            return 0
        }
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("searchCell", forIndexPath: indexPath) as! SearchViewCell
        let result = self.results?[indexPath.row]
        let imageFile = result?.objectForKey("media") as? PFFile
        
        imageFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if error == nil{
                cell.searchImageView.image = UIImage(data: data!)
            }else{
                print("cannot get image")
            }
        })
        
        let user = result?.objectForKey("author") as? PFUser
        
        cell.usernameLabel.text = user!.username!
        
        return cell
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.resignFirstResponder()
        searchBar.resignFirstResponder()
        let text = searchBar.text!
        UserMedia.fetchImagesWithSearch(text) { (objects, error) -> () in
            if error == nil {
                self.results = objects
                self.collectionView.reloadData()
            }else{
                print (error!)
            }
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.resignFirstResponder()
        searchBar.resignFirstResponder()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
