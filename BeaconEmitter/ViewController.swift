//
//  ViewController.swift
//  BeaconEmitter
//
//  Created by Bernd Plontsch on 09/11/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class ViewController: UIViewController, CBPeripheralManagerDelegate {

    let peripheralManager:CBPeripheralManager!
    var enabled:Bool = false
    @IBOutlet var emitterSwitch: UISwitch!
    
    //MARK: Beacon Credentials
    
    let uuid:NSUUID = NSUUID(UUIDString: "AA6062F0-98CA-4211-8EC4-193EB73CEBE6")!
    let major:NSNumber = NSNumber(short: 100)
    let minor:NSNumber = NSNumber(short: 701)
    let power:NSNumber = NSNumber(short: -59)
    let identifier:NSString = "de.plontsch.Emitter"
    
    //MARK: INIT
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        println("INIT")
        peripheralManager = CBPeripheralManager(delegate: self, queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        enabled = true //Update depending on current defaults
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewWillAppear(animated: Bool) {
        var stateEnabled:Bool = peripheralManager!.isAdvertising
        enabled = stateEnabled
        emitterSwitch.setOn(stateEnabled, animated: true)
    }
    
    //MARK: APPEARANCE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emitterSwitch.layer.transform = CATransform3DMakeRotation(1.571, 0, 0, 1)
        emitterSwitch.frame = CGRectMake(0, 0, emitterSwitch.frame.width, emitterSwitch.frame.height)
        emitterSwitch.addTarget(self, action: "configurationChanged", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    //MARK: SWITCH
    
    func configurationChanged(){
        enabled = emitterSwitch.on
        if peripheralManager!.state != CBPeripheralManagerState.PoweredOn {
            println("Bluetooth not enabled")
            return
        }
        if enabled {
            var peripheralData:NSDictionary?
            var region:CLBeaconRegion = CLBeaconRegion(
                proximityUUID: uuid,
                major: CLBeaconMajorValue(major.integerValue),
                minor: CLBeaconMinorValue(minor.integerValue),
                identifier: identifier)
            peripheralData = region.peripheralDataWithMeasuredPower(power)
            if peripheralData != nil {
                println("Start \(region)")
                peripheralManager.startAdvertising(peripheralData)
            }
        } else {
            println("Stop")
            peripheralManager.stopAdvertising()
        }
    }
    
    //MARK: CBPeripheralManager Protocol
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
    }
    
}

