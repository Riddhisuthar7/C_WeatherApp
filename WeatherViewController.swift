//
//  WeatherViewController.swift
//  Weather
//
//  Created by Riddhi Gajjar on 9/5/23.
//

import UIKit
import CoreLocation

class WeatherViewController: UITableViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var weatherSearchBar: UISearchBar!
    var serviceDetail =  [WeatherDetails]()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherSearchBar.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled(){
                switch(CLLocationManager.authorizationStatus()){
                case .authorizedWhenInUse:  // Location services are available.
                    self.enableLocationFeatures()
                    break
                case .restricted, .denied:  // Location services currently unavailable.
                    self.disableLocationFeatures()
                    break
                case .notDetermined:        // Authorization not determined yet.
                    self.disableLocationFeatures()
                    break
                default:
                    break
                }
            }}
    }
    
    func enableLocationFeatures(){
        let alertView = UIAlertController(title: "Allow Weather App to use your Location", message: "We will access your location", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Allow", style: .default, handler:{ (action: UIAlertAction!) in
            alertView .dismiss(animated: true, completion: nil)
        }))
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    }
    
    func disableLocationFeatures(){
        let alert = UIAlertController(title: "Weather app location access are disabled", message: "Please enable location access in your Settings", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        weatherSearchBar.resignFirstResponder()
        if let searchString = weatherSearchBar.text, !searchString.isEmpty{
            updateWeatherSearchLocation(searchLocation: searchString) // It will show city name accoding to weather data
        }
    }
    
    func updateWeatherSearchLocation (searchLocation: String){
        CLGeocoder().geocodeAddressString(searchLocation) {(placemark: [CLPlacemark]?, error: Error?) in
            if error == nil {
                if let location = placemark?.first?.location{
                    WeatherService().getCurrentWeather(withLocation: location.coordinate, completion: { (results:[WeatherDetails]?) in
                        if let weatherData = results {
                            self.serviceDetail = weatherData
                            DispatchQueue.main.async {
                                if ((weatherData.first?.sys.country != "US"))
                                {
                                    let errorAlert = UIAlertController(title: "App won't work out of USA", message: "We dont support out of USA", preferredStyle: UIAlertController.Style.alert)
                                    errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
                                        errorAlert .dismiss(animated: true, completion: nil)
                                    }))
                                    self.present(errorAlert, animated: true, completion: nil)
                                    self.tableView.reloadData()
                                }
                                else{
                                    self.tableView.reloadData()}
                            }
                        }
                    })
                }
            }
        }}
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceDetail.count // weather service count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell
        let weatherObject = serviceDetail[indexPath.section]
        if (weatherObject.sys.country == "US"){
            cell?.cityName?.text = weatherObject.name
            cell?.tempLabel?.text = String(describing: weatherObject.main.temp)
            cell?.tempmaxLabel?.text = String(describing: weatherObject.main.temp_max)
            cell?.tempminLabel?.text = String(describing: weatherObject.main.temp_min)
            cell?.humidityLabel?.text = String(describing: weatherObject.main.humidity)
            cell?.iconImageView?.image = UIImage(named: weatherObject.weather.first?.icon ?? "")
        }
        else {
            return cell ?? UITableViewCell()
        }
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: UITableViewCell = tableView.cellForRow(at: indexPath)!

    }
}
