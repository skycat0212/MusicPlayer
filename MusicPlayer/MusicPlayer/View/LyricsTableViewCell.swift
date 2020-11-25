//
//  LyricsTableViewCell.swift
//  MusicPlayer
//
//  Created by 김기현 on 2020/11/24.
//

import UIKit

class LyricsTableViewCell: UITableViewCell {
    @IBOutlet weak var lyricsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
