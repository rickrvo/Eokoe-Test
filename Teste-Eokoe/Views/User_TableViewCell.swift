//
//  User_TableViewCell.swift
//  Teste-Eokoe
//
//  Created by Rick on 11/12/18.
//  Copyright © 2018 Rick. All rights reserved.
//

import UIKit

class User_TableViewCell: UITableViewCell {

    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        var height = CGFloat(0)
//        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! User_TableViewCell
//        
//        let font = UIFont(name: "System", size: 17)
//        var detailHeight = cell.userName?.text?.heightWithConstrainedWidth(width: cell.userName.bounds.size.width, font: font!)
//        height += detailHeight!
//        
//        detailHeight = cell.userInfo?.text?.heightWithConstrainedWidth(width: cell.userInfo.bounds.size.width, font: font!)
//        height += detailHeight!
//        height += 10
//        
//        return height
//    }
    
}
