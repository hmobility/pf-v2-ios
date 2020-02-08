//
//  SearchHistoryItemTableViewCell.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/02.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class SearchHistoryItemTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!

    var removeAction: ((_ index:Int) -> Void)?
    
    var disposeBag = DisposeBag()
    
    // MARK: - Public Methods
    
    public func setTitle(with title:String) {
        titleLabel.text = title
    }
    
    // MARK: - Binding
     
    private func setupBinding() {
        removeButton.rx.tap
            .subscribe(onNext: { _ in
                if let indexPath = self.indexPath, let action = self.removeAction {
                    action(indexPath.row)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        setupBinding()
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
