//
//  UserDetails_TableViewCell.swift
//  Teste-Eokoe
//
//  Created by Rick on 14/12/18.
//  Copyright © 2018 Rick. All rights reserved.
//

import UIKit

class UserDetails_TableViewCell: UITableViewCell {

 
    @IBOutlet weak var imgPicto: UIImageView!
    @IBOutlet weak var userInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
