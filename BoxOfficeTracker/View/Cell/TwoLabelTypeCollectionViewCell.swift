//
//  TwoLabelTypeCollectionViewCell.swift
//  BoxOfficeTracker
//
//  Created by 송하경 on 2/23/24.
//

import UIKit

class TwoLabelTypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!

    static var identifier = "TwoLabelTypeCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
