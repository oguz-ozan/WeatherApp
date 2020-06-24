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
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate {

    // REMAINING TASKS
    //  2. Detailed View araştırması yap. Ona göre 7 günlük ileriye dönük API Call yapılacak, sonuç detailed view içinde bastırılacak.
    @IBOutlet weak var tableView: UITableView!

    var Weathers : [Weather] = [Weather]()
    var baseCities = ["koeln","helsinki"]
    var apiCallCount = 0
    var cities = [String]()
    var tmpCelsius : Bool = true
    var locationManager:CLLocationManager!
    var myLocation = ""
    var alertMessage = false
    
    override func viewDidAppear(_ animated: Bool) {
        
          print("viewDidAppear called")
        
        let defaults = UserDefaults.standard
        guard let citys = defaults.stringArray(forKey: "cities") else {
            return
        }

        cities = citys
        if(apiCallCount != 0){
            var new_weather = Weather()
            new_weather.city = cities[cities.count-1]
            Weathers.append(new_weather)
            apiCall(cities[cities.count-1],4)
            print("cities count is \(cities.count) and apicallcount is: \(apiCallCount) Weathers count is: \(Weathers.count)" )

        }
        // no need for that
        //self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad called")
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        
        
        // UserDefaults Settings. Bossa olusturuyor. Doluysa cities String arrayine yukluyor.
        let defaults = UserDefaults.standard
        guard let citys = UserDefaults.standard.stringArray(forKey: "cities") else{
            defaults.set(baseCities, forKey: "cities")
            print("Cities adlı UserDefaults Arrayi Olusturuldu.")
            return
        }
            //defaults.set(baseCities, forKey: "cities")


        
            cities = citys
    
        
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
        
        
        // Do any additional setup after loading the view.
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if(editingStyle == .delete){
            let currentCell = tableView.cellForRow(at: indexPath) as! CityTableViewCell
            guard let str = currentCell.cityLabel.text
                else{
                    print("null value geldi.")
                    return
                }
            let defaults = UserDefaults.standard
            cities = defaults.stringArray(forKey: "cities") ?? [String]()
            let index = cities.firstIndex(of: str.lowercased().replacingOccurrences(of: " ", with: "%20"))!
            print("index is: \(index) and the value is: \(cities[index])")
            var i = 0
            for weather in Weathers{
                if(weather.city == (cities[index])){
                    Weathers.remove(at: i)
                }
                i+=1
            }
            cities.remove(at: index)
            defaults.set(cities, forKey: "cities")
            print("Cities count is \(cities.count)")
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            
            self.apiCallCount-=1
            
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as! CityTableViewCell
        if(tmpCelsius){
            cell.celsiusLabel.text = String(Weathers[indexPath.row].temperature) + " °C"
        }else{
            cell.celsiusLabel.text = String(Weathers[indexPath.row].temperature) + " °F"
        }
        
        
        var newstr = Weathers[indexPath.row].city.replacingOccurrences(of: "%20", with: " ")
        cell.cityLabel.text = newstr
        
        // uiimage halledilecek
        
        cell.weatherStatusLabel.text = Weathers[indexPath.row].status
         
        guard Weathers[indexPath.row].status == "" else{
        cell.backgroundColor = UIColor(patternImage: UIImage(named: Weathers[indexPath.row].status)!)
            return cell
        }
        return cell
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation

        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")

    //    self.labelLat.text = "\(userLocation.coordinate.latitude)"
    //    self.labelLongi.text = "\(userLocation.coordinate.longitude)"

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print("Your location is: \(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)")
                guard let str = placemark.locality else{
                    print("error in location stage")
                    return
                }
                self.myLocation = str

                //self.labelAdd.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
            }
        }

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    func apiCall(_ city : String, _ index: Int) {
        
        var res_weather = Weather()
        let url_string = "https://api.openweathermap.org/data/2.5/weather?q=" + city + "&appid=ecc3c72797ddc9972a4e28eb37e1876c"
        print("URL string is: " + url_string)
        if let url = URL(string: url_string) {
           // the url
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                guard let data = data, error == nil,
                let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200 else {
                    print("Guardin icine girildi. May be HTTP error")
                    self.alertMessage = true
                    self.Weathers.remove(at: self.Weathers.count-1)
                    let defaults = UserDefaults.standard
                    var citys = defaults.stringArray(forKey: "cities")
                    citys!.remove(at: citys!.count-1)
                    defaults.set(citys, forKey: "cities")
                    
                    return
                }
                do{
                    let stories = try JSONDecoder().decode(UltimateResult.self, from: data)
                    
                    res_weather.city = city
                    var tempRes:Double = (stories.main?.temp)!-273.15
                    res_weather.temperature = round(tempRes)
  
                    res_weather.status = (stories.weather?[0].main)!
                    print("apicallcount is : " + String(self.apiCallCount))
                    self.Weathers[self.apiCallCount] = res_weather
                
                    print(String(format: "city is %@, tmp is %f, status is %@", self.Weathers[self.apiCallCount].city, self.Weathers[self.apiCallCount].temperature,  self.Weathers[self.apiCallCount].status))
                }
                catch let error {
                    print("Json Parse Error with: \(city) and the error is: \(error)")
                  }
               
                self.apiCallCount += 1
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }.resume()
           
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCity"{
            let destinationVC = segue.destination as! AddCityViewController
            destinationVC.name = myLocation
        }
    }
    
  
    @IBAction func switchTemperatues(_ sender: Any) {
        print("in")
        for i in 0..<Weathers.count{
            var item = Weathers[i]
             if(tmpCelsius){
                item.temperature = celciusToFahrenheit(item.temperature)
                       }else{
                item.temperature = fahrenheitToCelcius(item.temperature)
                       }
            Weathers[i].temperature = item.temperature
        }
        tmpCelsius = !tmpCelsius
        tableView.reloadData()
    }
    
    func fahrenheitToCelcius(_ degree : Double) -> Double{
        
         return round((degree-32) / 1.8)
        
    }

    func celciusToFahrenheit(_ degree : Double) -> Double{
        
         return round(degree * 1.8) + 32
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
    //var visibility:Int = 0
    var base:String = ""
}
struct Sys : Decodable{
    //var type : Int = 0
    //var id : Int = 0
    var country: String = ""
    var sunrise: Int = 0
    var sunset: Int = 0
}
struct Clouds : Decodable{
    var all : Int = 0
}
struct Wind : Decodable{
    //var deg : Double = 0.0
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



