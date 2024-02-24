//
//  BoxOfficeTableViewCell.swift
//  BoxOfficeTracker
//
//  Created by 송하경 on 2/23/24.
//

import UIKit

class BoxOfficeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var rankOldAndNewLabel: UILabel!
    @IBOutlet weak var movieNmLabel: UILabel!
    @IBOutlet weak var openDateLabel: UILabel!
    @IBOutlet weak var audienceAccLabel: UILabel!
    @IBOutlet weak var salesAccLabel: UILabel!
    
    
    static var identifier = "BoxOfficeTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
