//
//  FindingViewController.swift
//  fetch
//
//  Created by Izaak Prats on 4/10/15.
//  Copyright (c) 2015 IJVP. All rights reserved.
//

import UIKit
import CoreFoundation
import CoreData
import CoreBluetooth

class FindingViewController: UIViewController, CBCentralManagerDelegate,CBPeripheralManagerDelegate,CBPeripheralDelegate {

    var id: NSString?
    var name: NSString?
    var drawerName: NSString?
    var drawerURL: NSString?
    var flexUUID = CBUUID(string: "9460C413-1AC1-F9BE-7376-433BC56586F3")
    var timer = NSTimer()
    var done = false
    
   
    
    @IBOutlet weak var signalImage: UIImageView!
    
    
    
    
    
    var cManager = CBCentralManager()
    var peripheralManager = CBPeripheralManager()
    var discoveredPeripheral: CBPeripheral?
    
  //  Create our beaconRegion and discoveredPeripheral vars, this will be explained later.
  
    
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var drawerNameLabel: UILabel!
    
    
    @IBAction func foundButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        done = true
    }
    
    @IBAction func cancelButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
       
        done = true
    }
 
    
  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        itemNameLabel.text! = name! as String
        drawerNameLabel.text! = drawerName! as String
        
        // Watch Bluetooth connection
       
        // Init the CentralManager, we set the queue to nil so that the manager dispatches the central role events on the main queue - refer to the CBCentralManager Class definition for further explanation
        cManager = CBCentralManager(delegate: self, queue: nil)
        
        // Init the PeripheralManager
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        // Start the Bluetooth discovery process
        // Do any additional setup after loading the view.
       
        
    }
    
    func startLooking() {
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("timerFunc"), userInfo: nil, repeats: true)
        println("one")
    }
    
    func timerFunc() {
        discoveredPeripheral?.readRSSI()
        println("two")
    }
    
    func peripheral(peripheral: CBPeripheral!, didReadRSSI RSSI: NSNumber!, error: NSError!) {
        if let negRSSI = RSSI {
            
        var posRSSI: Int? = Int(negRSSI) * -1
        
        if (posRSSI == 0 ) {
            // seekingLabel!.text = "Antarctic"
            signalImage.image = UIImage(named: "none.png")
        } else if (posRSSI < 45) {
            // seekingLabel!.text = "You're on fire."
            signalImage.image = UIImage(named: "found.png")
        } else if (posRSSI < 65) {
           // seekingLabel!.text = "You're hot."
            signalImage.image = UIImage(named: "found.png")
        } else if (posRSSI < 75) {
           // seekingLabel!.text = "You're warm."
            signalImage.image = UIImage(named: "strong.png")
        } else if (posRSSI < 85) {
           // seekingLabel!.text = "Luke warm."
            signalImage.image = UIImage(named: "medium.png")
        } else if (posRSSI < 95) {
           // seekingLabel!.text = "Cold."
            signalImage.image = UIImage(named: "weak.png")
        } else if (posRSSI > 105) {
            // seekingLabel!.text = "Colder."
            signalImage.image = UIImage(named: "weak.png")
        } else {
            // seekingLabel!.text = "Antartic"
            signalImage.image = UIImage(named: "images/qm.jpg")
        }
            
        println(posRSSI)
            
        } else {
            println("nope")
            timer.invalidate()
        }
        
        if (done == true) {
            timer.invalidate()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func scanForBeacons(sender: AnyObject?) {
        cManager.scanForPeripheralsWithServices(nil, options: nil)
        
    }
    
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        
        switch cManager.state {
            
        case .PoweredOff:
            println("CoreBluetooth BLE hardware is powered off")
            break
        case .PoweredOn:
            println("CoreBluetooth BLE hardware is powered on and ready")
            // We can now call scanForBeacons
            self.scanForBeacons(self)
            break
        case .Resetting:
            println("CoreBluetooth BLE hardware is resetting")
            break
        case .Unauthorized:
            println("CoreBluetooth BLE state is unauthorized")
            
            break
        case .Unknown:
            println("CoreBluetooth BLE state is unknown")
            break
        case .Unsupported:
            println("CoreBluetooth BLE hardware is unsupported on this platform")
            break
            
        default:
            break
        }
    }
    
    //Create an optional var at the top the class and implement the
    
    //We need to implement the centralManager didDiscoverPeripheral method.
    
    func centralManager(central: CBCentralManager!,
        didDiscoverPeripheral peripheral: CBPeripheral!,
        advertisementData: [NSObject : AnyObject]!,
        RSSI: NSNumber!) {
            
           // central.connectPeripheral(peripheral, options: nil)
            
            // We have to set the discoveredPeripheral var we declared earlier to reference the peripheral, otherwise we won't be able to interact with it in didConnectPeripheral. And you will get state = connecting> is being dealloc'ed while pending connection error.
            
            self.discoveredPeripheral = peripheral
            
            var curDevice = UIDevice.currentDevice()
          
            
            println("UUID DESCRIPTION: \(peripheral.identifier.UUIDString)\n")
            
         
            
            if (peripheral?.name == "Flex") {
                central.connectPeripheral(peripheral, options: nil)
                startLooking()
                cManager.stopScan()
                println("Found it.")
            } 
            
            // stop scanning, saves the battery
            // cManager.stopScan()
            
            
    }

    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        
        peripheral.delegate = self
        peripheral.discoverServices([flexUUID])
        
        
    }
    
    func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("FAILED TO CONNECT \(error)")
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        
        switch peripheralManager.state {
            
        case .PoweredOff:
            println("Peripheral - CoreBluetooth BLE hardware is powered off")
            break
            
        case .PoweredOn:
            println("Peripheral - CoreBluetooth BLE hardware is powered on and ready")
            startLooking()
            break
            
        case .Resetting:
            println("Peripheral - CoreBluetooth BLE hardware is resetting")
            break
            
        case .Unauthorized:
            println("Peripheral - CoreBluetooth BLE state is unauthorized")
            break
            
        case .Unknown:
            println("Peripheral - CoreBluetooth BLE state is unknown")
            break
            
        case .Unsupported:
            println("Peripheral - CoreBluetooth BLE hardware is unsupported on this platform")
            break
            
        default:
            break
        }
        
    }
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
