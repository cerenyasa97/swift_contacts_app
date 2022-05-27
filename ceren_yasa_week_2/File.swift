//
//  File.swift
//  ceren_yasa_week_2
//
//  Created by Ceren Yaşa on 27.05.2022.
//

import Foundation

class Person{
    var id: UUID?
    var nameSurname: String?
    var phone:String?
    
    init(id: UUID?, name: String?, phone: String?){
        self.id = id
        self.nameSurname = name
        self.phone = phone
    }
    
    init(name: String?, phone: String?){
        self.nameSurname = name
        self.phone = phone
    }
}
