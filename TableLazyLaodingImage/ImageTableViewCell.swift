//
//  ImageTableViewCell.swift
//  TableLazyLaodingImage
//
//  Created by hc_cyril on 2017/3/8.
//  Copyright © 2017年 Clark. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    var photoView: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.photoView = UIImageView()
        self.photoView.contentMode = .scaleAspectFill
        self.photoView.clipsToBounds = true
        self.contentView.addSubview(self.photoView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.photoView.frame = self.contentView.bounds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
