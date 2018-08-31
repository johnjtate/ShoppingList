//
//  ListItemTableViewCell.swift
//  ShoppingList
//
//  Created by John Tate on 8/31/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

import UIKit

protocol ListItemTableViewCellDelegate: class {
    
    func toggleIsPurchasedButton(cell: ListItemTableViewCell)
}

class ListItemTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var isPurchasedButton: UIButton!
    
    weak var delegate: ListItemTableViewCellDelegate?
    
    var item: Item? {
        didSet{
            updateView()
        }
    }

    func updateView() {
        guard let item = item else { return }
        
        itemLabel.text = item.name
        updateButton()
    }
    
    func updateButton() {
        guard let item = item else {return}
        
        if item.isPurchased{
            isPurchasedButton.setImage(#imageLiteral(resourceName: "complete"), for: .normal)
        } else {
            isPurchasedButton.setImage(#imageLiteral(resourceName: "incomplete"), for: .normal)
        }
    }


    // MARK: - IBAction
    
    @IBAction func isPurchasedButtonTapped(_ sender: Any) {
        delegate?.toggleIsPurchasedButton(cell: self)
    }
    
    
}
