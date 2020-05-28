//
//  ViewController.swift
//  WeatherApp
//
//  Created by Oğuz Özan on 26.05.2020.
//  Copyright © 2020 Oğuz Özan. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!

    var Weathers : [Weather] = [Weather]()
    var cities = ["izmir","istanbul","konya"]
    var apiCallCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Array bos ise api Call ile Arrayi dolduruyoruz.
        if(Weathers.count == 0){
            print("Weather count: 0")
            for city in cities{
                var new_weather = Weather()
                new_weather.city = city
                Weathers.append(new_weather)
                _ = apiCall(city, cities.count)
                print("wth cont is " + String(Weathers.count))
        }
        }
        
       
        
        
        // Coredata şuanlık kullanmaya gerek yok çünkü APIden anlık veri çekiyoruz.
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let request = NSFetchRequest<Weather>(entityName: "Weather")
//
//        Weathers = try! context.fetch(request)
        
        // Do any additional setup after loading the view.
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
//     let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
//        cell.textLabel?.text = cellContent[indexPath.row]
//        return cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as! CityTableViewCell
        cell.celsiusLabel.text = String(Weathers[indexPath.row].temperature)
        cell.cityLabel.text = Weathers[indexPath.row].city
        
        // uiimage halledilecek
        //cell.weatherStatusLabel.text = Weathers[indexPath.row].status
        return cell
    }
    
    func apiCall(_ city : String, _ index: Int) {
        
        var res_weather = Weather()
        let url_string = "https://api.openweathermap.org/data/2.5/weather?q=" + city + "&appid=ecc3c72797ddc9972a4e28eb37e1876c"
        print("URL string is: " + url_string)
        if let url = URL(string: url_string) {
           // the url
            URLSession.shared.dataTask(with: url) { data, response, error in
               if let data = data {
                do{
                    let stories = try JSONDecoder().decode(UltimateResult.self, from: data)
                    
                    res_weather.city = stories.name
                    res_weather.temperature = (stories.main?.temp)!
                    res_weather.status = (stories.weather?[0].main)!
                    print("apicallcount is : " + String(self.apiCallCount))
                    self.Weathers[self.apiCallCount] = res_weather
                
                    print(String(format: "city is %@, tmp is %f, status is %@", self.Weathers[self.apiCallCount].city, self.Weathers[self.apiCallCount].temperature,  self.Weathers[self.apiCallCount].status))
                }
                catch let error {
                        print("Json Parse Error : \(error)")
                  }
               
                }
                self.apiCallCount += 1
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }.resume()
           
        }
         
    }
    
}

struct UltimateResult : Decodable{
    var name:String = ""
    var cod:Int = 0
    var id:Int = 0
    var timezone:Int = 0
    var sys : Sys?
    var clouds : Clouds?
    var wind : Wind?
    var main : Main?
    var weather : [Weatherr]?
    var coord : Coord?
    var dt:Int = 0
    var visibility:Int = 0
    var base:String = ""
}
struct Sys : Decodable{
    var type : Int = 0
    var id : Int = 0
    var country: String = ""
    var sunrise: Int = 0
    var sunset: Int = 0
}
struct Clouds : Decodable{
    var all : Int = 0
}
struct Wind : Decodable{
    var deg : Double = 0.0
    var speed : Double = 0.0
}
struct Main : Decodable {
    var temp : Double = 0.0
    var feels_like : Double = 0.0
    var temp_min : Double = 0.0
    var temp_max : Double = 0.0
    var pressure : Int = 0
    var humidity : Int = 0
}
struct Weatherr : Decodable{
    var id : Int = 0
    var main : String = ""
    var description : String = ""
    var icon : String = ""
}
struct Coord : Decodable {
    var lon : Double = 0.0
    var lat : Double = 0.0
}


struct Weather {
    var city:String = ""
    var temperature:Double = 0.0
    var status: String = ""
}

