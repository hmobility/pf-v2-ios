//
//  CarModelTableViewCell.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/01.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

class CarModelTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Public Methods
    
    public func setModel(_ model:String) {
        titleLabel.text = model
    }
    
    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
