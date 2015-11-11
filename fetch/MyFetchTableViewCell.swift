//
//  MyFetchTableViewCell.swift
//  fetch
//
//  Created by Izaak Prats on 4/11/15.
//  Copyright (c) 2015 IJVP. All rights reserved.
//

import UIKit

class MyFetchTableViewCell: UITableViewCell {

    @IBOutlet weak var myFetchImage: UIImageView!
    
    @IBOutlet weak var fetchNumber: UILabel!
    
    @IBOutlet weak var fetchNumberOfItems: UILabel!
    
    
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
