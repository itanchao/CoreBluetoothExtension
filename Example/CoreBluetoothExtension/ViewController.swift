//
//  ViewController.swift
//  CoreBluetoothExtension
//
//  Created by itanchao on 06/21/2018.
//  Copyright (c) 2018 itanchao. All rights reserved.
//

import UIKit
import CoreBluetoothExtension
class ViewController: UIViewController {
    
    let central = CBCentralManager.manager()
    let centrale = CBCentralManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centrale.didUpdateState { (p) in
            print(p)
        }
        central.didUpdateState {
            print($0)
        }
        centrale.scanForPeripherals(withServices: nil, options: nil, duration: 30, responseBlock: {q,w,e,r in
            print(q)
        }) {
            print("stop")
        }

//        CBCentralManager().didUpdateState { (_) in
//            
//        }
        central.scanForPeripherals(withServices: nil, options: nil, duration: 30, responseBlock: {q,w,e,r in
            print(q)
        }) {
            print("stop")
        }
//        CBCentralManager().centralManagerDidUpdateState { (_) in
//            
//        }
//        CBCentralManager().centralManagerDidUpdateState { (_) in
//
//        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

