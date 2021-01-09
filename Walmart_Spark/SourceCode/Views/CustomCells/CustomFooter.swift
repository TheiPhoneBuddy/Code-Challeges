//
//  CustomFooter.swift
//  Walmart_Spark
//
//  Created by Francis Chan on 1/8/21.
//

import UIKit

class CustomFooter: UIView {
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var msg: UILabel!
    
    override func awakeFromNib() {
        self.activityIndicator.startAnimating()
    }
}
