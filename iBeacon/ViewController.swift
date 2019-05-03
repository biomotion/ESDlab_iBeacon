//
//  ViewController.swift
//  iBeacon
//
//  Created by 李聖誠 on 2019/5/3.
//  Copyright © 2019 nctuesd. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var monitorResultTextView: UITextView!
    @IBOutlet weak var rangingResultTextView: UITextView!
    
    var locationManager: CLLocationManager = CLLocationManager()
    let uuid = "A7E717B6-AC09-45AE-AD30-661FF6A49DB2"
    let identfier = "Benson region"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let region = CLBeaconRegion(proximityUUID: UUID.init(uuidString: uuid)!, identifier: identfier)
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
            if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways{
                locationManager.requestAlwaysAuthorization()
            }
        }
        
        locationManager.delegate = self
        region.notifyEntryStateOnDisplay = true
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        locationManager.startMonitoring(for: region)
        monitorResultTextView.text = ""
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        monitorResultTextView.text = "did start monitoring \(region.identifier)\n" + monitorResultTextView.text
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        monitorResultTextView.text = "did enter\n" + monitorResultTextView.text
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        monitorResultTextView.text = "did exit\n" + monitorResultTextView.text
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        switch state {
        case .inside:
            monitorResultTextView.text = "state inside\n" + monitorResultTextView.text
            if CLLocationManager.isRangingAvailable(){
                manager.startRangingBeacons(in: region as! CLBeaconRegion)
            }
        case .outside:
            monitorResultTextView.text = "state outside\n" + monitorResultTextView.text
            manager.stopMonitoring(for: region)
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons:
        [CLBeacon], in region: CLBeaconRegion) {
        rangingResultTextView.text = ""
        let orderedBeaconArray = beacons.sorted(by: { (b1, b2) -> Bool in
            return b1.rssi > b2.rssi
        })
        for beacon in orderedBeaconArray {
            var proximityString = ""
            switch beacon.proximity {
            case .far:
                proximityString = "far"
            case .near:
                proximityString = "near"
            case .immediate:
                proximityString = "immediate"
            default :
                proximityString = "unknow"
            }
            rangingResultTextView.text = rangingResultTextView.text +
                "Major: \(beacon.major)" + " Minor: \(beacon.minor)" +
                " RSSI: \(beacon.rssi)" + " Proximity: \(proximityString)" +
                " Accuracy: \(beacon.accuracy)" + "\n\n";
        }
    }}

