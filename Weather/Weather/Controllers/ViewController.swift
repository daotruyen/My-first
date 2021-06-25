//
//  ViewController.swift
//  Weather
//
//  Created by Tuyen on 20/06/2021.
//

import UIKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate {
    let networkWeather = WeatherNetwork()
    
   private let nameCity: UILabel = {
        let nameCity = UILabel()
        nameCity.translatesAutoresizingMaskIntoConstraints = false
        nameCity.text = "Name City"
        nameCity.textAlignment = .center
        nameCity.textColor = .label
        nameCity.numberOfLines = 0
        nameCity.font = UIFont.systemFont(ofSize: 38, weight: .heavy)
        return nameCity
    }()
    private let stateWeather: UILabel = {
        let stateWeather = UILabel()
        stateWeather.translatesAutoresizingMaskIntoConstraints = false
        stateWeather.text = "Cloudy"
        stateWeather.textAlignment = .center
        stateWeather.textColor = .label
        stateWeather.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        return stateWeather
     }()
    private let imageSymbol: UIImageView = {
        let img = UIImageView()
         img.image = UIImage(systemName: "cloud.fill")
         img.contentMode = .scaleAspectFit
         img.translatesAutoresizingMaskIntoConstraints = false
         img.tintColor = .gray
         return img
     }()
    private let numberOfTemperature: UILabel = {
        let numberOfTemperature = UILabel()
        numberOfTemperature.translatesAutoresizingMaskIntoConstraints = false
        numberOfTemperature.text = "38 °C"
        numberOfTemperature.textColor = .label
        numberOfTemperature.textAlignment = .center
        numberOfTemperature.font = UIFont.systemFont(ofSize: 70,weight: .heavy)
        return numberOfTemperature
    }()
    
    var locationManager = CLLocationManager()
    var currentLoc: CLLocation?
    var stackView : UIStackView!
    var latitude : CLLocationDegrees!
    var longitude: CLLocationDegrees!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "Color")
        //self.title = "Weather"
        
     let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(handAddPlaceButton))
      let showButton = UIBarButtonItem(image: UIImage(systemName: "thermometer"), style: .done, target: self, action: #selector(handShow))
      let refreshButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .done, target: self, action: #selector(handRefresh))
     self.navigationItem.rightBarButtonItems = [addButton, showButton,refreshButton]
        transparentNavigationBar()
        view.addSubview(nameCity)
        view.addSubview(stateWeather)
        view.addSubview(imageSymbol)
        view.addSubview(numberOfTemperature)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        nameCity.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        nameCity.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        nameCity.heightAnchor.constraint(equalToConstant: 70).isActive = true
        nameCity.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        
        imageSymbol.topAnchor.constraint(equalTo: nameCity.bottomAnchor,constant: 2).isActive = true
        imageSymbol.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        imageSymbol.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageSymbol.trailingAnchor.constraint(equalTo: nameCity.trailingAnchor, constant: -18).isActive = true
        
        stateWeather.topAnchor.constraint(equalTo: imageSymbol.bottomAnchor, constant: 4).isActive = true
        stateWeather.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        stateWeather.heightAnchor.constraint(equalToConstant: 20).isActive = true
        stateWeather.trailingAnchor.constraint(equalTo: nameCity.trailingAnchor, constant: -18).isActive = true
        
        numberOfTemperature.topAnchor.constraint(equalTo: stateWeather.topAnchor, constant: 4).isActive = true
        numberOfTemperature.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        numberOfTemperature.heightAnchor.constraint(equalToConstant: 200).isActive = true // height
        numberOfTemperature.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true //margin
        
    }
    
    
    @objc func handAddPlaceButton(){
        let alert = UIAlertController(title: "Search City", message: "", preferredStyle: .alert)
        // Add text field
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Name city"
        })
        let saveAction = UIAlertAction(title: "Search", style: .default, handler: {_ in
            let textField = alert.textFields![0] as UITextField
            guard let cityname = textField.text else { return}
            self.loadData(city: cityname)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    @objc func handShow(){
       self.navigationController?.pushViewController(CollectionViewController(), animated: true)
        print("navigation")
    }
    @objc func handRefresh(){
        let city = UserDefaults.standard.string(forKey: "SelectedCity") ?? ""
        loadData(city: city)
        print("reload")
    }
    func transparentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        navigationItem.backBarButtonItem = UIBarButtonItem(
        title: "", style: .plain, target: nil, action: nil)
       
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        let location = locations[0].coordinate
        latitude = location.latitude
        longitude = location.longitude
        print("Long", longitude.description)
        print("Lat", latitude.description)
        loadDataUsingCoordinates(lat: latitude.description, long: longitude.description)
    }
    func loadData ( city: String){
        networkWeather.fetchCurrentWeather(city: city) { (weather) in
            print("temperature",weather.main.temp.kelvin())
            DispatchQueue.main.async {
                self.numberOfTemperature.text = (String(weather.main.temp.kelvin()) + "°C")
                self.nameCity.text = "\(weather.name ?? ""), \(weather.sys.country ?? "")"
                print("\(String(describing: weather.name) ), \(String(describing: weather.sys.country) )")
                self.stateWeather.text = weather.weather[0].description
                self.imageSymbol.loadImage(url: "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
                UserDefaults.standard.set("\(weather.name ?? "")",forKey: "SelectedCity")
            }
        }
    }
    func loadDataUsingCoordinates(lat: String, long: String) {
        networkWeather.fetchDataLocation(lat: lat, long: long) { (weather) in
            print("Current Temperature", weather.main.temp.kelvin())
             DispatchQueue.main.async {
                 self.numberOfTemperature.text = (String(weather.main.temp.kelvin()) + "°C")
                 self.nameCity.text = "\(weather.name ?? "") , \(weather.sys.country ?? "")"
                print("\(String(describing: weather.name)), \(String(describing: weather.sys.country))")
                 self.stateWeather.text = weather.weather[0].description
                 self.imageSymbol.loadImage(url: "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
                UserDefaults.standard.set("\(weather.name ?? "")", forKey: "SelectedCity")
             }
        }
    }
}

