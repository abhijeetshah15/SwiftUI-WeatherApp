//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Abhijeet Shah on 2/14/22.
//

import UIKit
import CoreLocation
import SDWebImage

class ForecastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var navBarReloadBtn: UIBarButtonItem!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    var locationManager = CLLocationManager()
    let API_KEY = "(OPENWEATHERMAP API KEY HERE)"
    var dictObj = [[String: Any]]()
    var secTotal = 0
    var latValue = 0.0
    var lonValue = 0.0
    var arrDays: [String] = []

    var dataArraySunday: [(String, String, String, String)] = []
    var dataArrayMonday: [(String, String, String, String)] = []
    var dataArrayTuesday: [(String, String, String, String)] = []
    var dataArrayWednesday: [(String, String, String, String)] = []
    var dataArrayThursday: [(String, String, String, String)] = []
    var dataArrayFriday: [(String, String, String, String)] = []
    var dataArraySaturday: [(String, String, String, String)] = []
     
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view.
            self.weatherTableView.delegate = self
            self.weatherTableView.dataSource = self

            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            if locationManager.location != nil {
                latValue = locationManager.location!.coordinate.latitude
                lonValue = locationManager.location!.coordinate.longitude
                self.getWeatherList()
            }

        }
        
        
        func getWeatherList()
        {
            let df = DateFormatter()
            
            let weatherURL = URL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=\(latValue)&lon=\(lonValue)&appid=\(API_KEY)&units=metric")
            
            self.activityLoader.startAnimating()
            
            URLSession.shared.dataTask(with: weatherURL!) { data, response, error in
                
                if error == nil
                {
                do {
                    if let responseData = data{
                        let maindata = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as! [String: AnyObject]

                        guard let weatherData = maindata["list"] as? [[String: Any]] else {
                                 return
                            }
                        self.secTotal = maindata.count
                        
                        print(weatherData)
                        self.dictObj = weatherData
                        DispatchQueue.main.async { [self] in
                            
                            for i in (0..<weatherData.count) {
                                
                                let obj = weatherData[i]
                                
                                df.dateFormat = "EEEE"
                                let day = obj["dt"] as? Double
                                let dayDate = df.string(from: Date(timeIntervalSince1970: Double(day!)))
                                
                                df.dateFormat = "HH:MM"
                                let time = df.string(from: Date(timeIntervalSince1970: Double(day!)))
                                
                                
                                if dayDate == "Sunday" {
                                    
                                    var icon = ""
                                    var description = ""
                                    var temperature = ""

                                    let weatherData = (obj["weather"] as! NSArray)
                                    if let temp = weatherData[0] as? NSDictionary {
                                    let tempIcon = temp["icon"]
                                        icon = tempIcon as! String
                                    let tempDescription = temp["description"]
                                        description = tempDescription as! String
                                        }
                                    
                                    let mainData = (obj["main"] as! NSDictionary)
                                    if let main = mainData as? NSDictionary {
                                        temperature = formatTemperature(temp: main["temp"] as! Double)
                                    }
                                    
                                    if !arrDays.contains(dayDate) {
                                        arrDays.append(dayDate)
                                    }

                                    self.dataArraySunday.append((icon, description, temperature, time))

                                }

                                if dayDate == "Monday" {
                                    
                                    var icon = ""
                                    var description = ""
                                    var temperature = ""

                                    let weatherData = (obj["weather"] as! NSArray)
                                    if let temp = weatherData[0] as? NSDictionary {
                                    let tempIcon = temp["icon"]
                                        icon = tempIcon as! String
                                    let tempDescription = temp["description"]
                                        description = tempDescription as! String
                                        }
                                    
                                    let mainData = (obj["main"] as! NSDictionary)
                                    if let main = mainData as? NSDictionary {
                                        temperature = formatTemperature(temp: main["temp"] as! Double)
                                    }
                                

                                    if !arrDays.contains(dayDate) {
                                        arrDays.append(dayDate)
                                    }
                                    self.dataArrayMonday.append((icon, description, temperature, time))

                                }
                            

                                if dayDate == "Tuesday" {
                                    
                                    var icon = ""
                                    var description = ""
                                    var temperature = ""

                                    let weatherData = (obj["weather"] as! NSArray)
                                    if let temp = weatherData[0] as? NSDictionary {
                                    let tempIcon = temp["icon"]
                                        icon = tempIcon as! String
                                    let tempDescription = temp["description"]
                                        description = tempDescription as! String
                                        }
                                    
                                    let mainData = (obj["main"] as! NSDictionary)
                                    if let main = mainData as? NSDictionary {
                                        temperature = formatTemperature(temp: main["temp"] as! Double)
                                    }
                                

                                    if !arrDays.contains(dayDate) {
                                        arrDays.append(dayDate)
                                    }
                                    self.dataArrayTuesday.append((icon, description, temperature, time))

                                }

                                if dayDate == "Wednesday" {
                                    
                                    var icon = ""
                                    var description = ""
                                    var temperature = ""

                                    let weatherData = (obj["weather"] as! NSArray)
                                    if let temp = weatherData[0] as? NSDictionary {
                                    let tempIcon = temp["icon"]
                                        icon = tempIcon as! String
                                    let tempDescription = temp["description"]
                                        description = tempDescription as! String
                                        }
                                    
                                    let mainData = (obj["main"] as! NSDictionary)
                                    if let main = mainData as? NSDictionary {
                                        temperature = formatTemperature(temp: main["temp"] as! Double)
                                    }
                                

                                    if !arrDays.contains(dayDate) {
                                        arrDays.append(dayDate)
                                    }
                                    self.dataArrayWednesday.append((icon, description, temperature, time))

                                }

                                if dayDate == "Thursday" {
                                    
                                    var icon = ""
                                    var description = ""
                                    var temperature = ""

                                    let weatherData = (obj["weather"] as! NSArray)
                                    if let temp = weatherData[0] as? NSDictionary {
                                    let tempIcon = temp["icon"]
                                        icon = tempIcon as! String
                                    let tempDescription = temp["description"]
                                        description = tempDescription as! String
                                        }
                                    
                                    let mainData = (obj["main"] as! NSDictionary)
                                    if let main = mainData as? NSDictionary {
                                        temperature = formatTemperature(temp: main["temp"] as! Double)
                                    }
                                

                                    if !arrDays.contains(dayDate) {
                                        arrDays.append(dayDate)
                                    }
                                    self.dataArrayThursday.append((icon, description, temperature, time))

                                }

                                if dayDate == "Friday" {
                                    
                                    var icon = ""
                                    var description = ""
                                    var temperature = ""

                                    let weatherData = (obj["weather"] as! NSArray)
                                    if let temp = weatherData[0] as? NSDictionary {
                                    let tempIcon = temp["icon"]
                                        icon = tempIcon as! String
                                    let tempDescription = temp["description"]
                                        description = tempDescription as! String
                                        }
                                    
                                    let mainData = (obj["main"] as! NSDictionary)
                                    if let main = mainData as? NSDictionary {
                                        temperature = formatTemperature(temp: main["temp"] as! Double)
                                    }
                                

                                    if !arrDays.contains(dayDate) {
                                        arrDays.append(dayDate)
                                    }
                                    self.dataArrayFriday.append((icon, description, temperature, time))

                                }

                                if dayDate == "Saturday" {
                                    
                                    var icon = ""
                                    var description = ""
                                    var temperature = ""

                                    let weatherData = (obj["weather"] as! NSArray)
                                    if let temp = weatherData[0] as? NSDictionary {
                                    let tempIcon = temp["icon"]
                                        icon = tempIcon as! String
                                    let tempDescription = temp["description"]
                                        description = tempDescription as! String
                                        }
                                    
                                    let mainData = (obj["main"] as! NSDictionary)
                                    if let main = mainData as? NSDictionary {
                                        temperature = formatTemperature(temp: main["temp"] as! Double)
                                    }
                                

                                    if !arrDays.contains(dayDate) {
                                        arrDays.append(dayDate)
                                    }
                                    self.dataArraySaturday.append((icon, description, temperature, time))
                                }
                                
                                
                                
                                
                            }
                            self.activityLoader.stopAnimating()
                            self.blurView.isHidden = true
                            self.weatherTableView.reloadData()
                            navBarReloadBtn.isEnabled = true

                        }
                    }
                }
                catch let error as Error{
                    self.activityLoader.stopAnimating()
                    self.blurView.isHidden = true
                    print(error.localizedDescription)
                }
            }
                else {
                    self.activityLoader.stopAnimating()
                    self.blurView.isHidden = true
                }
            }.resume()
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return self.arrDays.count
          }
    
    func formatTemperature(temp: Double) -> String {
        return "\(Int(round(temp)))\u{00B0}"
    }
      
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let dayName = self.arrDays[section]
            if dayName == "Sunday"{
                return self.dataArraySunday.count
             }
            else if dayName == "Monday"{
                return self.dataArrayMonday.count
             }
            else if dayName == "Tuesday"{
                return self.dataArrayTuesday.count
             }
            else if dayName == "Wednesday"{
                return self.dataArrayWednesday.count
             }
            else if dayName == "Thursday"{
                return self.dataArrayThursday.count
             }
            else if dayName == "Friday"{
                return self.dataArrayFriday.count
             }
            else if dayName == "Saturday"{
                return self.dataArraySaturday.count
            }else{
                return 0
            }
            
       }

        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
          let headerView = UILabel()
            headerView.text = "     \(self.arrDays[section].uppercased())"
            headerView.textColor = .darkGray
            headerView.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            headerView.backgroundColor = .white
          return headerView
      }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            return 80
        }

        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = self.weatherTableView.dequeueReusableCell(withIdentifier: "weatherCell")! as! TableViewCell
            
            cell.selectionStyle = .none

            let dayName = self.arrDays[indexPath.section]
            if dayName == "Sunday"{
                 let oneImg = dataArraySunday[indexPath.row].0
                 let urlStr = NSURL(string:"http://openweathermap.org/img/w/\(oneImg).png")
                cell.cellImg.sd_setImage(with: urlStr as URL?)
                cell.skyConditionLbl.text = dataArraySunday[indexPath.row].1
                cell.tempLbl.text = String(dataArraySunday[indexPath.row].2) + "C"
                cell.timeLbl.text = dataArraySunday[indexPath.row].3
             }
            else if dayName == "Monday"{
                 let oneImg = dataArrayMonday[indexPath.row].0
                 let urlStr = NSURL(string:"http://openweathermap.org/img/w/\(oneImg).png")
                cell.cellImg.sd_setImage(with: urlStr as URL?)
                cell.skyConditionLbl.text = dataArrayMonday[indexPath.row].1
                cell.tempLbl.text = String(dataArrayMonday[indexPath.row].2) + "C"
                cell.timeLbl.text = dataArrayMonday[indexPath.row].3
             }
            else if dayName == "Tuesday"{
                 let oneImg = dataArrayTuesday[indexPath.row].0
                 let urlStr = NSURL(string:"http://openweathermap.org/img/w/\(oneImg).png")
                cell.cellImg.sd_setImage(with: urlStr as URL?)
                cell.skyConditionLbl.text = dataArrayTuesday[indexPath.row].1
                cell.tempLbl.text = String(dataArrayTuesday[indexPath.row].2) + "C"
                cell.timeLbl.text = dataArrayTuesday[indexPath.row].3
             }
            else if dayName == "Wednesday"{
                 let oneImg = dataArrayWednesday[indexPath.row].0
                 let urlStr = NSURL(string:"http://openweathermap.org/img/w/\(oneImg).png")
                cell.cellImg.sd_setImage(with: urlStr as URL?)
                cell.skyConditionLbl.text = dataArrayWednesday[indexPath.row].1
                cell.tempLbl.text = String(dataArrayWednesday[indexPath.row].2) + "C"
                cell.timeLbl.text = dataArrayWednesday[indexPath.row].3
             }
            else if dayName == "Thursday"{
                 let oneImg = dataArrayThursday[indexPath.row].0
                 let urlStr = NSURL(string:"http://openweathermap.org/img/w/\(oneImg).png")
                cell.cellImg.sd_setImage(with: urlStr as URL?)
                cell.skyConditionLbl.text = dataArrayThursday[indexPath.row].1
                cell.tempLbl.text = String(dataArrayThursday[indexPath.row].2) + "C"
                cell.timeLbl.text = dataArrayThursday[indexPath.row].3
            }
            else if dayName == "Friday"{
                 let oneImg = dataArrayFriday[indexPath.row].0
                 let urlStr = NSURL(string:"http://openweathermap.org/img/w/\(oneImg).png")
                cell.cellImg.sd_setImage(with: urlStr as URL?)
                cell.skyConditionLbl.text = dataArrayFriday[indexPath.row].1
                cell.tempLbl.text = String(dataArrayFriday[indexPath.row].2) + "C"
                cell.timeLbl.text = dataArrayFriday[indexPath.row].3
             }
            else if dayName == "Saturday"{
                 let oneImg = dataArraySaturday[indexPath.row].0
                 let urlStr = NSURL(string:"http://openweathermap.org/img/w/\(oneImg).png")
                cell.cellImg.sd_setImage(with: urlStr as URL?)
                cell.skyConditionLbl.text = dataArraySaturday[indexPath.row].1
                cell.tempLbl.text = String(dataArraySaturday[indexPath.row].2) + "C"
                cell.timeLbl.text = dataArraySaturday[indexPath.row].3
            }
            
      

          return cell
      }
        
        @IBAction func navBarButtonPressed(_ sender: UIBarButtonItem) {
            if locationManager.location != nil {
                
                self.navBarReloadBtn.isEnabled = false
                
                dataArraySunday.removeAll()
                dataArrayMonday.removeAll()
                dataArrayTuesday.removeAll()
                dataArrayWednesday.removeAll()
                dataArrayThursday.removeAll()
                dataArrayFriday.removeAll()
                dataArraySaturday.removeAll()
                arrDays.removeAll()
                self.weatherTableView.reloadData()
                self.getWeatherList()
            }
            
        }

}
