//
//  MusicTableViewCell.swift
//  MusicSearch
//
//  Created by Bharani Cherukuri on 3/30/17.
//  Copyright © 2017 Bharani.Cherukuri. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artWorkImage: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.borderColor = UIColor.black.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
