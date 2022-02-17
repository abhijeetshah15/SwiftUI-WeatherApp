//
//  TodayVC.swift
//  WeatherApp
//
//  Created by Abhijeet Shah on 2/14/22.
//

import UIKit
import CoreLocation
import SDWebImage
import MapKit

class TodayVC: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    let API_KEY = "3dcf172add32592a2fd2d0e52fa6e9fe"
    var latValue = 0.0
    var lonValue = 0.0
    var city = ""
    var country = ""
    
    @IBOutlet weak var reloadBtn: UIButton!
    @IBOutlet weak var navBarReloadBtn: UIBarButtonItem!
    @IBOutlet weak var navBarShareBtn: UIBarButtonItem!
    
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var weatherLbl: UILabel!
    
    @IBOutlet weak var cloudPercentageLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var pressureLbl: UILabel!
    @IBOutlet weak var windSpeedLbl: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var directionLbl: UILabel!
    var firstRun: Bool = true
    
    @IBOutlet weak var lineLbl: UILabel!
    
    @IBOutlet weak var stack1: UIStackView!
    @IBOutlet weak var stack2: UIStackView!
    
    @IBOutlet weak var refreshControl: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /////// start locationManager/////////////
        
        DispatchQueue.main.async {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
        }
        
        
      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if locationManager.location != nil {
        self.getWeather()
        }
        else {
            dataManage(isShow: false)
        }
        
        if self.locationManager.authorizationStatus == .denied || self.locationManager.authorizationStatus == .restricted || self.locationManager.authorizationStatus == .notDetermined || CLLocationManager .locationServicesEnabled() == false {
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func getWeather() {
        
        let weatherURL = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(latValue)&lon=\(lonValue)&appid=\(API_KEY)&units=metric")
        self.refresh()
        URLSession.shared.dataTask(with: weatherURL!) { data, response, error in
            if error == nil {

            do {
                self.dataManage(isShow: true)
                if let responseData = data{
                    let weatherData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as! [String: AnyObject]
                    
                    DispatchQueue.main.async {
                        
                        let temp = self.formatTemperature(temp: weatherData["main"]!["temp"]!! as! Double)
                        if let condition = weatherData["weather"]!.value(forKey: "main") {
                            let str = "\(temp)C | \(condition)"
                            self.weatherLbl.text = str.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "  ", with: "")
                        }
 
                        let iconData = weatherData["weather"] as! NSArray
                        let imageIcon = iconData.value(forKey: "icon")
                        let urlStr = "http://openweathermap.org/img/w/\(imageIcon).png".replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                        
                        self.weatherImg.sd_setImage(with: URL(string: urlStr))
                       
                        
                        let humidity = weatherData["main"]!["humidity"]!!
                        self.humidityLbl.text = "\(humidity)"
                        
                        let pressure = weatherData["main"]!["pressure"]!!
                        self.pressureLbl.text = "\(pressure)hPa"
                        
                        let clouds = weatherData["clouds"]!["all"]!!
                        self.cloudPercentageLbl.text = "\(clouds) %"
                        let wind = weatherData["wind"]!["speed"]!!
                        self.windSpeedLbl.text = "\(wind) km/h"
                        
                        
                        if let degrees = weatherData["wind"]!["deg"]!! as? Float {
                            let direction = Direction(degrees)
                            self.directionLbl.text = "\(direction)"
                            
                        }
                        guard let country = try? weatherData["sys"]!["country"]! else {return}

                       
                        let city = weatherData["name"]!
                        self.locationLbl.text = "\(city), \(country)"
                    }
                }
                
             }
            catch let error as Error{
                print(error.localizedDescription)
                self.dataManage(isShow: false)
             }
        }
            else{
                self.dataManage(isShow: false)
            }
        }.resume()
     }
    
    /////// Buttons Action///////////
    @IBAction func reloadAction(_ sender: Any) {
        if locationManager.location != nil {
        self.getWeather()
        }
        else {
            dataManage(isShow: false)
        }
    }
    
    @IBAction func shareAction(_ sender: Any) {
        
        guard let strText1 = self.locationLbl.text else { return  }
        guard let strText2 = self.weatherLbl.text else { return  }
        
        let strData = "\(strText1) \n\(strText2)"
        
        
        // URL, and or, and image to share with other apps
        
        let items = [strData] as [Any]
        let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        //Apps to exclude sharing to
        avc.excludedActivityTypes = [
            UIActivity.ActivityType.airDrop,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList
        ]
        //If user on iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            if avc.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                avc.popoverPresentationController?.barButtonItem = sender as! UIBarButtonItem
            }
        }
        //Present the shareView on iPhone
        self.present(avc, animated: true, completion: nil)
    }
    
    /////// Refresh Action///////////
    @objc func refresh() {
        self.refreshControl.startAnimating()
        self.blurView.isHidden = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailRangingFor beaconConstraint: CLBeaconIdentityConstraint, error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    /////// location framework delegates///////////
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        if location != nil {
            latValue = location!.coordinate.latitude
            lonValue = location!.coordinate.longitude
            if firstRun == true {
                self.getWeather()
                firstRun = false
            }
        }
        else {
            dataManage(isShow: false)
        }
    }
    
    func formatTemperature(temp: Double) -> String {
        return "\(Int(round(temp)))\u{00B0}"
    }
    
    func dataManage(isShow: Bool) {
        DispatchQueue.main.async {
        if isShow == true {
            self.reloadBtn.isHidden = true
            self.weatherLbl.isHidden = false
            self.stack1.isHidden = false
            self.stack2.isHidden = false
            self.lineLbl.isHidden = false
            self.navBarShareBtn.isEnabled = true
        }
        else {
            self.reloadBtn.isHidden = false
            self.weatherLbl.isHidden = true
            self.stack1.isHidden = true
            self.stack2.isHidden = true
            self.lineLbl.isHidden = true
            self.navBarShareBtn.isEnabled = false
            
            self.locationLbl.text = "The data couldn't be read because it is missing."
            self.weatherImg.image = UIImage(named: "data_load_error")
        }
        
            self.blurView.isHidden = true
            self.refreshControl.stopAnimating()
        }
        
    }
    
    @IBAction func yellowReloadBtnPressed(_ sender: UIButton) {
        if locationManager.location != nil {
        self.getWeather()
        }
        else {
            dataManage(isShow: false)
        }
    }
    
}

enum Direction: String, CaseIterable {
    case N, NNE, NE, ENE, E, ESE, SE, SSE, S, SSW, SW, WSW, W, WNW, NW, NNW
}
extension Direction: CustomStringConvertible  {
    init<D: BinaryFloatingPoint>(_ direction: D) {
        self =  Self.allCases[Int((direction.angle+11.25).truncatingRemainder(dividingBy: 360)/22.5)]
    }
    var description: String { rawValue.uppercased() }
}
extension BinaryFloatingPoint {
    var angle: Self {
        (truncatingRemainder(dividingBy: 360) + 360)
            .truncatingRemainder(dividingBy: 360)
    }
    var direction: Direction { .init(self) }
}
