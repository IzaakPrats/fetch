//
//  ViewController.swift
//  fetch
//
//  Created by Izaak Prats on 4/10/15.
//  Copyright (c) 2015 IJVP. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var itemTable: UITableView!
    
    
    
    var tableData = []
    var filteredTableData = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getItems()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //   func filterContentForSearchText(searchText: String) {
    // Filter the array using the filter method
    //      self.filteredTableData = self.tableData.filteredArrayUsingPredicate)
    // }
    
    
    
    
    
    func getItems() {
        let baseURL = NSURL(string: "http://ijvp.co/fetch/")
        let studentURL = NSURL(string: "items.php", relativeToURL: baseURL)
        // Do any additional setup after loading the view, typically from a nib.
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask:  NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(studentURL!, completionHandler: {(classList: NSURL!, response: NSURLResponse!,error: NSError!) -> Void in
            
            if (error == nil) {
                let dataObject = NSData(contentsOfURL: classList)
                
                if (dataObject != nil) {
                    let results: NSArray = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSArray
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        self.tableData = results
                        self.itemTable?.reloadData()
                        
                    })
                    
                    
                } else {
                    println(error)
                }
                
            }
        })
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        downloadTask.resume()
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
        
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "itemCell")
        let className : NSMutableDictionary = self.tableData[indexPath.row] as NSMutableDictionary
        
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.font = UIFont.systemFontOfSize(20.0)
        cell.accessoryType = .DisclosureIndicator
        
        
        
        
        
        cell.textLabel?.text = className["name"] as NSString
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let selectedCell: UITableViewCell = itemTable.cellForRowAtIndexPath(indexPath)!
        let classInfo : NSMutableDictionary = self.tableData[indexPath.row] as NSMutableDictionary
        
        var findingViewController: FindingViewController = self.storyboard!.instantiateViewControllerWithIdentifier("findingViewController") as FindingViewController
        
        let givenItem: NSMutableDictionary = self.tableData[indexPath.row] as NSMutableDictionary
        
        findingViewController.id = givenItem["id"] as? NSString
        findingViewController.name = givenItem["name"] as? NSString
        findingViewController.drawerName = givenItem["drawerName"] as? NSString
        findingViewController.drawerURL = givenItem["drawerURL"] as? NSString
        
        
        self.presentViewController(findingViewController, animated: true, completion: nil)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    
}

