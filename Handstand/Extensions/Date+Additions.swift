//
//  Date+Additions.swift
//  Handstand
//
//  Created by Ranjith Kumar on 1/4/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import Foundation

extension Date {
    
    func getBackendInput()->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: self)
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.string(from: self)
        dateFormatter.dateFormat = "YYYY"
        let year = dateFormatter.string(from: self)
        let finalDate = "\(year.description)"+"-"+"\(month.description)"+"-"+"\(day.description)"
        return finalDate
    }
    
    func getDateComponents() -> (Int,String,Int) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        return (day,getReadableMonth(with:month),year)
    }
    
    private func getReadableMonth(with index:Int) -> String {
        return ["January",
                "February",
                "March",
                "April",
                "May",
                "June",
                "July",
                "August",
                "September",
                "October",
                "November",
                "December"][index - 1]
    }
    
    func calcAge() -> Int {
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: self, to: now, options: [])
        let age = calcAge.year
        return age!
    }

}
