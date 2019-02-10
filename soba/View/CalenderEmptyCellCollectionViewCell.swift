//
//  CalenderEmptyCellCollectionViewCell.swift
//  soba
//
//  Created by James on 2019/1/29.
//  Copyright © 2019 tripresso. All rights reserved.
//

import UIKit

class CalenderEmptyCellCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func bind(selected: Bool) {
        if selected {
            self.backgroundColor = UIColor(red: 43/255, green: 142/255, blue: 149/255, alpha: 1)
        } else {
            self.backgroundColor = .white
        }
    }
}
