//
//  AddCityViewController.swift
//  WeatherApp
//
//  Created by Oğuz Özan on 29.05.2020.
//  Copyright © 2020 Oğuz Özan. All rights reserved.
//

import UIKit

class AddCityViewController: UIViewController {

   
    @IBOutlet weak var addCityTextEdit: UITextField!
    var name:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
 
   
    @IBAction func submitTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        var citys = defaults.stringArray(forKey: "cities")
        guard let str = addCityTextEdit.text, var cities = citys else{
            print("error here")
            return
        }
        cities.append(str)
        defaults.set(cities, forKey: "cities")
         _ = navigationController?.popViewController(animated: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
