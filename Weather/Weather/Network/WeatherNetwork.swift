//
//  WeatherNetwork.swift
//  Weather
//
//  Created by Tuyen on 22/06/2021.
//
//
//  WeatherNetwork.swift
//  Weather
//
//  Created by Tuyen on 22/06/2021.
//

import UIKit
let API_KEY = "20d29094d2068ccbf9d139d31346fcd1"
class WeatherNetwork: UIViewController {

    func fetchDataLocation(lat:String, long: String, completion: @escaping(WeatherModel)->()){
        let URL_API = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(API_KEY)"
        guard let url = URL(string: URL_API) else {
            fatalError()
        }
        let request  = URLRequest(url:url)
        URLSession.shared.dataTask(with: request){
            (data,response,error) in
            guard let data = data else {return}
            do {
                let currentWeather = try JSONDecoder().decode(WeatherModel.self, from: data)
               completion(currentWeather)
            } catch {
                print(error)
            }
        }.resume()
    }
    func fetchCurrentWeather(city: String, completion: @escaping (WeatherModel) -> ()) {
        let formattedCity = city.replacingOccurrences(of: " ", with: "+")
        let cityFormatted = formattedCity.replacingOccurrences(of: "đ", with: "d")
        let API_URL = "http://api.openweathermap.org/data/2.5/weather?q=\(cityFormatted)&appid=\(API_KEY)"
        
        guard let url = URL(string: API_URL) else {
                 fatalError()
             }
             let urlRequest = URLRequest(url: url)
             URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                 guard let data = data else { return }
                 do {
                     let currentWeather = try JSONDecoder().decode(WeatherModel.self, from: data)
                    completion(currentWeather)
                 } catch {
                     print(error)
                 }
                     
        }.resume()
    }
    func  fetchFiveDay(city: String, completion: @escaping ([numberTemperature]) -> ()) {
        let formattedCity = city.replacingOccurrences(of: " ", with: " ")
        let API_URL = "http://api.openweathermap.org/data/2.5/forecast?q=\(formattedCity)&appid=\(API_KEY)"
        
        var currentDayTemp = numberTemperature(weekDay: nil, hourly: nil)
        var secondDayTemp = numberTemperature(weekDay: nil, hourly: nil)
        var thirdDayTemp = numberTemperature(weekDay: nil, hourly: nil)
        var fourthDayTemp = numberTemperature(weekDay: nil, hourly: nil)
        var fifthDayTemp = numberTemperature(weekDay: nil, hourly: nil)
        var sixthDayTemp = numberTemperature(weekDay: nil, hourly: nil)
        
        guard let url = URL(string: API_URL) else {
                 fatalError()
             }
             let urlRequest = URLRequest(url: url)
             URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
                guard let strongSelf = self else { return }
                 guard let data = data else { return }
                 do {
                    
                    let forecastWeather = try JSONDecoder().decode(ForecastModel.self, from: data)
                        
                    var forecastmodelArray : [numberTemperature] = []
                    var fetchedData : [WeatherInfo] = [] //Just for loop completion
                    
                    var currentDayForecast : [WeatherInfo] = []
                    var secondDayForecast : [WeatherInfo] = []
                    var thirddayDayForecast : [WeatherInfo] = []
                    var fourthDayDayForecast : [WeatherInfo] = []
                    var fifthDayForecast : [WeatherInfo] = []
                    var sixthDayForecast : [WeatherInfo] = []
                    
                    print("Total data:", forecastWeather.list.count)
                    var totalData = forecastWeather.list.count //Should be 40 all the time
                    
                    for day in 0...forecastWeather.list.count - 1 {
                        let listIndex = day//(8 * day) - 1
                        let mainTemp = forecastWeather.list[listIndex].main.temp
                        let descriptionTemp = forecastWeather.list[listIndex].weather[0].description
                        let icon = forecastWeather.list[listIndex].weather[0].icon
                        let time = forecastWeather.list[listIndex].dt_txt!
                    
                        let dateFormatter = DateFormatter()
                        dateFormatter.calendar = Calendar(identifier: .gregorian)
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let date = dateFormatter.date(from: forecastWeather.list[listIndex].dt_txt!)
                        
                        let calendar = Calendar.current
                        let components = calendar.dateComponents([.weekday], from: date!)
                        let weekdaycomponent = components.weekday! - 1  //Just the integer value from 0 to 6
                        
                        let f = DateFormatter()
                        let weekday = f.weekdaySymbols[weekdaycomponent] // 0 Sunday 6 - Saturday //This is where we are getting the string val (Mon/Tue/Wed...)
                            
                        let currentDayComponent = calendar.dateComponents([.weekday], from: Date())
                        let currentWeekDay = currentDayComponent.weekday! - 1
                        let currentweekdaysymbol = f.weekdaySymbols[currentWeekDay]
                        
                        if weekdaycomponent == currentWeekDay - 1 {
                            totalData = totalData - 1
                        }
                        
                        
                        if weekdaycomponent == currentWeekDay {
                            let info = WeatherInfo(temp: mainTemp , description: descriptionTemp, icon: icon, time: time)
                            currentDayForecast.append(info)
                            currentDayTemp = numberTemperature(weekDay: currentweekdaysymbol, hourly: currentDayForecast)
                            print("1")
                            fetchedData.append(info)
                        }else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 1) {
                            let info = WeatherInfo(temp: mainTemp, description: descriptionTemp, icon: icon, time: time)
                            secondDayForecast.append(info)
                            secondDayTemp = numberTemperature(weekDay: weekday, hourly: secondDayForecast)
                            print("2")
                            fetchedData.append(info)
                        }else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 2) {
                            let info = WeatherInfo(temp: mainTemp, description: descriptionTemp, icon: icon, time: time)
                            thirddayDayForecast.append(info)
                            print("3")
                            thirdDayTemp = numberTemperature(weekDay: weekday, hourly: thirddayDayForecast)
                            fetchedData.append(info)
                        }else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 3) {
                            let info = WeatherInfo(temp: mainTemp, description: descriptionTemp, icon: icon, time: time)
                            fourthDayDayForecast.append(info)
                            print("4")
                            fourthDayTemp = numberTemperature(weekDay: weekday, hourly: fourthDayDayForecast)
                            fetchedData.append(info)
                        }else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 4){
                            let info = WeatherInfo(temp: mainTemp, description: descriptionTemp, icon: icon, time: time)
                            fifthDayForecast.append(info)
                            fifthDayTemp = numberTemperature(weekDay: weekday, hourly: fifthDayForecast)
                            fetchedData.append(info)
                            print("5")
                        }else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 5) {
                            let info = WeatherInfo(temp: mainTemp, description: descriptionTemp, icon: icon, time: time)
                            sixthDayForecast.append(info)
                            sixthDayTemp = numberTemperature(weekDay: weekday, hourly: sixthDayForecast)
                            fetchedData.append(info)
                            print("6")
                        }

                        
                        if fetchedData.count == totalData {
                            
                            if currentDayTemp.hourly?.count ?? 0 > 0 {
                                forecastmodelArray.append(currentDayTemp)
                            }
                            
                            if secondDayTemp.hourly?.count ?? 0 > 0 {
                                forecastmodelArray.append(secondDayTemp)
                            }
                            
                            if thirdDayTemp.hourly?.count ?? 0 > 0 {
                                forecastmodelArray.append(thirdDayTemp)
                            }
                            
                            if fourthDayTemp.hourly?.count ?? 0 > 0 {
                                forecastmodelArray.append(fourthDayTemp)
                            }
                            
                            if fifthDayTemp.hourly?.count ?? 0 > 0 {
                                forecastmodelArray.append(fifthDayTemp)
                            }
                            
                            if sixthDayTemp.hourly?.count ?? 0 > 0 {
                                forecastmodelArray.append(sixthDayTemp)
                            }
                            
//                            if seventhDayTemp.hourlyForecast?.count ?? 0 > 0{
//                                forecastmodelArray.append(seventhDayTemp)
//                            }
                            
                            if forecastmodelArray.count <= 6 {
                                completion(forecastmodelArray)
                            }
                            
                        }
                        
                     
                        
                    }
                 } catch {
                     print(error)
                 }
                     
        }.resume()
    }
    
}

