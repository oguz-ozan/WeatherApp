//
//  AddCityViewController.swift
//  WeatherApp
//
//  Created by Oğuz Özan on 29.05.2020.
//  Copyright © 2020 Oğuz Özan. All rights reserved.
//

import UIKit

class AddCityViewController: UIViewController {

   
    @IBOutlet weak var hint_Label: UILabel!
    @IBOutlet weak var info_Label: UILabel!
    @IBOutlet weak var addCityTextEdit: UITextField!
    var name:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        info_Label.numberOfLines = 2
        info_Label.text = "Your location is \(name)"
        hint_Label.text = "To add another city, type above"
        addCityTextEdit.text = name

        // Do any additional setup after loading the view.
    }
    
 
   
    @IBAction func submitTapped(_ sender: Any) {
        var cityStr = ""
        var bool = false
        let defaults = UserDefaults.standard
        var citys = defaults.stringArray(forKey: "cities")
        guard let str = addCityTextEdit.text, var cities = citys else{
            print("error here")
            return
        }
        cityStr = str
        if(str==""){
           let alert = UIAlertController(title: "Warning", message: "Sehir ismi girin!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            bool = true
        }
        
        if(str.trimmingCharacters(in: .whitespaces).count > 1){
             cityStr = str.replacingOccurrences(of: " ", with: "%20")
        }
            
        
        
        for city in cities{
            if cityStr.lowercased() == city.lowercased(){
               let alert = UIAlertController(title: "Warning", message: "Ayni sehri ekleyemezsiniz!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                bool = true
            }
        }
        
        
        if(!bool){
            cities.append(cityStr.lowercased())
            print("eklenecek olan sehir" + str.lowercased())
                  defaults.set(cities, forKey: "cities")
        }
      
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
