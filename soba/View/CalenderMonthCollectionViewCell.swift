//
//  CalenderMonthCollectionViewCell.swift
//  soba
//
//  Created by James on 2019/1/29.
//  Copyright © 2019 tripresso. All rights reserved.
//

import UIKit

class CalenderMonthCollectionViewCell: UICollectionViewCell {
    var backgroundCustomView: UIView!
    var contentLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentLabel = UILabel.init(frame: self.contentView.bounds)
        self.contentLabel.textAlignment = .left
        
        self.contentView.addSubview(contentLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
