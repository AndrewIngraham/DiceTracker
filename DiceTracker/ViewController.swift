//
//  ViewController.swift
//  DiceTracker
//
//  Created by Andrew Ingraham on 11/16/23.
//

// UIViewController: The UIViewController class defines the shared behavior that’s common to all view controllers. You rarely create instances of the UIViewController class directly. Instead, you subclass UIViewController and add the methods and properties needed to manage the view controller’s view hierarchy.


import UIKit
import CoreData

class ViewController: UIViewController {
    
    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard container != nil else {
            fatalError("This view needs a persistent container.")
        } // <guard 'expression' else> checks to see if the condition is NOT MET. In this instance, if (container != nil), else will not run. If container == nil, else will run which in this instance throws a fatalError
    } // Makes sure the container does load.
    
}
