//
//  Distence.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/31.
//

import Foundation

struct DistenceModel {
    var value: Double = 0
    var unit: Unit = Unit.m
    
    enum Unit: String {
        case m = "米"
        case km = "千米"
    }
}
