//
//  WeatherService.swift
//  Weather
//
//  Created by Riddhi Gajjar on 9/5/23.
//

import Foundation
import CoreLocation
import UIKit


struct WeatherDetails: Decodable{
    let weather: [weather]
    let timezone: Double
    let id: Int
    let name: String
    let cod: Int
    let sys: sys
    let main: main
    enum WeatherDetails: String,CodingKey{
        case weather
        case name
        case cod
        case timeZome
        case sys
        case main
    }
}
struct main: Decodable{
    let temp: Float
    let temp_max: Float
    let temp_min: Float
    let humidity: Int
}

struct sys: Decodable{
    let country: String
}
struct  weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    var iconURL: URL{
        let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        return URL(string: urlString)!
    }
    enum weatheDetails: String,CodingKey{
        case id
        case main
        case description 
    }
}
class WeatherService {
    var serviceDetail =  [WeatherDetails]()
    func getCurrentWeather(withLocation location:CLLocationCoordinate2D, completion: @escaping ([WeatherDetails]?) -> ()){
        guard let apiLink = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&appid=d223bec2b2cbb6a920f9a43b314d82f1&units=metric") else {return}
        let request = URLRequest(url: apiLink)
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            if let data = data {
                do {
                    if let _ = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let weatherObject = try? JSONDecoder().decode(WeatherDetails.self, from: data) {
                            self.serviceDetail.append(weatherObject)
                            DispatchQueue.main.async {
                                completion(self.serviceDetail)
                            }
                        }
                    }
                }
                catch {
                    let errorAlert = UIAlertController(title: "There is some technical issue", message: "Please try after sometime!!!", preferredStyle: UIAlertController.Style.alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
                        errorAlert .dismiss(animated: true, completion: nil)
                    }))
                }}
        }
        task.resume()
    }
}
