//
//  PlaceCollectionViewCell.swift
//  TestApp
//
//  Created by Kirill Sysoev on 19.05.2025.
//

import UIKit

class PlaceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var favoriteAction: (() -> Void)?
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        favoriteAction?()
        uploadFavorites()
    }
}
