//
//  DashboardCollectionViewCell.swift
//  FinalProject_CampusConnect
//
//  Created by Mann Mehta.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Style: rounded cards
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .secondarySystemBackground

        // Optional: add shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        // Icon styling
                iconImageView.contentMode = .scaleAspectFit
                iconImageView.clipsToBounds = true
                iconImageView.tintColor = .systemBlue

    }
}
