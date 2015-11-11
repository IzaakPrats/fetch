//
//  ViewController.swift
//  fetch
//
//  Created by Izaak Prats on 4/10/15.
//  Copyright (c) 2015 IJVP. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var itemTable: UITableView!


    
    
    var tableData = []
    
    
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
            let studentURL = NSURL(string: "drawers.php", relativeToURL: baseURL)
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
            let cell: MyFetchTableViewCell = itemTable.dequeueReusableCellWithIdentifier("drawerCell") as MyFetchTableViewCell
            
            
            // let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "itemCell") as UITableViewCell
            
            let className : NSMutableDictionary = self.tableData[indexPath.row] as NSMutableDictionary
            
            var drawerNumber = className["id"] as? NSString
            
            
            cell.myFetchImage.image = UIImage(named: "drawer.JPG")
            cell.fetchNumber?.text = "Fetch \(drawerNumber!)"
            cell.fetchNumberOfItems?.text = "5 items"
            
            
            // cell.textLabel?.text = "Fetch"
            
            
            
            return cell
                
        }
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
            
            let selectedCell: UITableViewCell = itemTable.cellForRowAtIndexPath(indexPath)!
            let classInfo : NSMutableDictionary = self.tableData[indexPath.row] as NSMutableDictionary
            
            var drawerDetailViewController: DrawerDetailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("drawerDetailViewController") as DrawerDetailViewController
            
            let givenClass: NSMutableDictionary = self.tableData[indexPath.row] as NSMutableDictionary
            
            drawerDetailViewController.drawerName = givenClass["name"] as? NSString
            drawerDetailViewController.drawerId = givenClass["id"] as? NSString
            drawerDetailViewController.drawerURL = givenClass["url"] as? NSString
            
            self.presentViewController(drawerDetailViewController, animated: true, completion: nil)
            
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 220
    }

}

