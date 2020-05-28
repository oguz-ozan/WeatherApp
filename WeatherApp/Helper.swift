//
//  Helper.swift
//  WeatherApp
//
//  Created by Oğuz Özan on 28.05.2020.
//  Copyright © 2020 Oğuz Özan. All rights reserved.
//

import Foundation
import UIKit
import CoreData


// şu an kullanılmıyor. ileride lazım olursa diye dursun.
class Helper{
    static let shareInstance = Helper()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}
