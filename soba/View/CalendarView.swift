//
//  CalendarView.swift
//  soba
//
//  Created by James on 2019/1/25.
//  Copyright © 2019年 tripresso. All rights reserved.
//

import UIKit

class CalendarView: UIView {
    
    private var dateArray: Array<CalenderType> = []
    private var collectioinView: UICollectionView!
    private var startDay: IndexPath?
    private var endDay: IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
//    private func updateDateCount() {
//        for _ in dateCount...dateCount + 99 {
//            dateCount += 1
//            self.dateArray.append(dateCount)
//        }
//        print(dateArray.count)
//        self.collectioinView.reloadData()
//    }
    
    private func setup() {
        let currentYear = Calendar.current.component(.year, from: Date())
        
        for month in 1...12 {
            //每個月幾天
            let days = getDaysInThisMonth(year: currentYear, month: month)
            self.dateArray.append(CalenderMonthCell(title: String(describing: month)))
            for _ in 1..<getWeekday(year: currentYear, month: month, day: 1) {
                self.dateArray.append(CalenderEmptyCell(selected: false))
            }
            for day in 1...days {
                self.dateArray.append(CalenderDayCell(year: currentYear, month: month, day: day, selected: false, cellSelectedType: .none))
            }
            if self.getWeekday(year: currentYear, month: month, day: days) < 7 {
                for _ in 1...(7 - self.getWeekday(year: currentYear, month: month, day: days)) {
                    self.dateArray.append(CalenderEmptyCell(selected: false))
                }
            }

        }
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0.0

        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.scrollDirection = .vertical
        
        
        self.collectioinView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height), collectionViewLayout: flowLayout)
        self.collectioinView.backgroundColor = .clear
        self.collectioinView.frame = self.bounds
        self.collectioinView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.collectioinView.register(CalenderDayCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CalenderDayCollectionViewCell.self))
        self.collectioinView.register(CalenderMonthCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CalenderMonthCollectionViewCell.self))
        self.collectioinView.register(CalenderEmptyCellCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CalenderEmptyCellCollectionViewCell.self))
        
        
        self.collectioinView.dataSource = self
        self.collectioinView.delegate = self
        self.addSubview(collectioinView)
    }
    
    private func getWeekday(year: Int, month: Int, day: Int) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: "\(year)-\(month)-\(day)") {
            let weekDay = Calendar.current.component(.weekday, from: date)
            return weekDay
        }
        return Int()
    }
    
    private func getDaysInThisMonth(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let date = Calendar.current.date(from: dateComponents)!
        let range = Calendar.current.range(of: .day, in: .month, for: date)
        return range?.count ?? 0
    }
    
    private func selectedCalenderRange(startDay: Int, endDay: Int, selected: Bool) {
        for selectedDay in startDay...endDay {
            if dateArray[selectedDay] is CalenderEmptyCell {
                let emptyCell = (dateArray[selectedDay] as! CalenderEmptyCell)
                emptyCell.selected = selected
            }
            if dateArray[selectedDay] is CalenderDayCell {
                let dayCell = (dateArray[selectedDay] as! CalenderDayCell)
                dayCell.selected = selected
                dayCell.cellSelectedType = .none
            }
        }
    }

}

private class CalenderType {}

private class CalenderMonthCell: CalenderType {
    let title: String
    
    init(title: String) {
        self.title = title
    }
}

private class CalenderDayCell: CalenderType {
    let year: Int
    let month: Int
    let day: Int
    var selected: Bool
    var cellSelectedType: CalenderCellSelectedTypeEnum
    
    init(year: Int, month: Int, day: Int, selected: Bool, cellSelectedType: CalenderCellSelectedTypeEnum) {
        self.year = year
        self.month = month
        self.day = day
        self.selected = selected
        self.cellSelectedType = cellSelectedType
    }
}

private class CalenderEmptyCell: CalenderType {
    var selected: Bool
    
    init(selected: Bool) {
        self.selected = selected
    }
}

enum CalenderCellSelectedTypeEnum {
    case none
    case single
    case start
    case middle
    case end
}



extension CalendarView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = self.dateArray[indexPath.row]
        
        if (cellType is CalenderMonthCell) {
            let cellData = cellType as! CalenderMonthCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CalenderMonthCollectionViewCell.self), for: indexPath) as! CalenderMonthCollectionViewCell
            cell.contentLabel.text = "\(cellData.title)月"
            
            return cell
        } else if (cellType is CalenderDayCell) {
            let cellData = cellType as! CalenderDayCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CalenderDayCollectionViewCell.self), for: indexPath) as! CalenderDayCollectionViewCell
            cell.bind(year: cellData.year, month: cellData.month, day: cellData.day, selected: cellData.selected, calenderCellSelectedType: cellData.cellSelectedType)
            
            return cell
        } else if (cellType is CalenderEmptyCell) {
            let cellData = cellType as! CalenderEmptyCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CalenderEmptyCellCollectionViewCell.self), for: indexPath) as! CalenderEmptyCellCollectionViewCell
            cell.bind(selected: cellData.selected)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellType = self.dateArray[indexPath.row]
        
        if (cellType is CalenderMonthCell) {
            return CGSize(width: self.frame.width, height: self.frame.width / 7)
        } else if (cellType is CalenderDayCell) {
            return CGSize(width: self.frame.width / 7, height: self.frame.width / 7)
        } else if (cellType is CalenderEmptyCell) {
            return CGSize(width: self.frame.width / 7, height: self.frame.width / 7)
        }
        
        return CGSize(width: 0, height: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        //        print("offset:\(offset)")
        let bounds = scrollView.bounds
        //        print("bounds:\(bounds)")
        let size = scrollView.contentSize
        //        print("size:\(size)")
        let inset = scrollView.contentInset
        //        print("inset:\(inset)")
        let y = offset.y + bounds.size.height - inset.bottom
        //        print("y:\(y)")
        let h = size.height
        //        print("h:\(h)")
        
        let reloadDistance: CGFloat = 10.0
        if (y > h + reloadDistance) {
            print("load more")
//            self.updateDateCount()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (self.dateArray[indexPath.row] is CalenderDayCell) {
            let cell = (self.dateArray[indexPath.row] as! CalenderDayCell)
            let slectedYear = cell.year
            let slectedMonth = cell.month
            let slectedDay = cell.day
            
            cell.selected = true
            
            if self.startDay == nil {
                cell.cellSelectedType = .single
                self.startDay = indexPath
            } else {
                if self.endDay == nil {
                    if indexPath != startDay {
                        cell.cellSelectedType = .middle
                        if indexPath.row < self.startDay!.row {
                            let dayCell = (dateArray[startDay!.row] as! CalenderDayCell)
                            dayCell.selected = false
                            self.startDay = indexPath
                            cell.cellSelectedType = .single
                        } else {
                            self.endDay = indexPath
                            self.selectedCalenderRange(startDay: self.startDay!.row, endDay: self.endDay!.row, selected: true)
                            cell.cellSelectedType = .end
                            (self.dateArray[(self.startDay?.row)!] as! CalenderDayCell).cellSelectedType = .start
                        }
                    }
                } else {
                    self.selectedCalenderRange(startDay: self.startDay!.row, endDay: self.endDay!.row, selected: false)
                    cell.selected = true
                    cell.cellSelectedType = .single
                    self.startDay = indexPath
                    self.endDay = nil
                }
            }
            self.collectioinView.reloadData()
            
            print("\(slectedYear)年\(slectedMonth)月\(slectedDay)日")
        }
        
    }
    
    
    
}
