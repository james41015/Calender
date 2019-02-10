//
//  CalenderDayCollectionViewCell.swift
//  soba
//
//  Created by James on 2019/1/29.
//  Copyright © 2019 tripresso. All rights reserved.
//

import UIKit

class CalenderDayCollectionViewCell: UICollectionViewCell {
    private var selecedTodayView: UIView!
    private var backgroundCustomView: UIView!
    private var contentLabel: UILabel!
    private let currentYear = Calendar.current.component(.year, from: Date())
    private let currentMonth = Calendar.current.component(.month, from: Date())
    private let currentDay = Calendar.current.component(.day, from: Date())
    private var year: Int!
    private var month: Int!
    private var day: Int!
    private var calenderCellSelectedType: CalenderCellSelectedTypeEnum?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentLabel = UILabel(frame: self.contentView.frame)
        self.contentLabel.textAlignment = .center
        self.backgroundCustomView = UIView(frame: self.contentView.frame)
        self.selecedTodayView = UIView(frame: self.contentView.frame)
        self.selecedTodayView.layer.cornerRadius = self.selecedTodayView.frame.width / 2
        
        self.contentView.addSubview(selecedTodayView)
        self.contentView.addSubview(backgroundCustomView)
        self.contentView.addSubview(contentLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func bind(year: Int, month: Int, day: Int, selected: Bool, calenderCellSelectedType: CalenderCellSelectedTypeEnum) {
        self.year = year
        self.month = month
        self.day = day
        self.calenderCellSelectedType = calenderCellSelectedType
        
        self.contentLabel.text = String(describing: day)
        
        if (isToday()) {
            self.selecedTodayView.layer.borderWidth = 1
            self.selecedTodayView.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            self.selecedTodayView.layer.borderWidth = 0
            self.selecedTodayView.layer.borderColor = UIColor.clear.cgColor
        }
        
        if (isEarlyThenToday()) {
            self.isUserInteractionEnabled = false
            self.contentLabel.textColor = .lightGray
            self.backgroundCustomView.backgroundColor = .clear
        } else {
            self.isUserInteractionEnabled = true
            if (selected) {
                self.backgroundCustomView.backgroundColor = UIColor(red: 43/255, green: 142/255, blue: 149/255, alpha: 1)
                self.contentLabel.textColor = .white
            } else {
                self.backgroundCustomView.backgroundColor = .clear
                self.contentLabel.textColor = .black
            }
        }
        
        switch calenderCellSelectedType {
        case .none:
            self.backgroundCustomView.layer.cornerRadius = 0
            self.backgroundCustomView.roundCorners([.allCorners], radius: 0)
        case .single:
            self.backgroundCustomView.layer.cornerRadius = self.backgroundCustomView.frame.width / 2
            self.backgroundCustomView.roundCorners([.allCorners], radius: 0)
        case .start:
            self.backgroundCustomView.layer.cornerRadius = 0
            self.backgroundCustomView.roundCorners([.topLeft, .bottomLeft], radius: self.backgroundCustomView.frame.width / 2)
        case .middle:
            self.backgroundCustomView.layer.cornerRadius = 0
            self.backgroundCustomView.roundCorners([.allCorners], radius: 0)
        case .end:
            self.backgroundCustomView.layer.cornerRadius = 0
            self.backgroundCustomView.roundCorners([.topRight, .bottomRight], radius: self.backgroundCustomView.frame.width / 2)
        }
    }
    
    private func isToday() -> Bool {
        if (currentYear == self.year && currentMonth == self.month && currentDay == self.day) {
            return true
        }
        return false
    }
    
    private func isEarlyThenToday() -> Bool {
        if (self.year < self.currentYear) {
            return true
        } else if (self.year == self.currentYear && self.month < self.currentMonth) {
            return true
        } else if (self.year == self.currentYear && self.month == self.currentMonth && self.day < self.currentDay) {
            return true
        }
        return false
    }
    
}

extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
