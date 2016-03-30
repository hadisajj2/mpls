//
//  ViewController.swift
//  MapTracer
//
//  Created by Seyyed Sajjadpour on 1/10/1395 AP.
//  Copyright © 1395 Seyyed Sajjadpour. All rights reserved.
//

import UIKit

class MainMenuController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("mapTitle")!
        return cell
    }

}

