//
//  AppsTableViewController.swift
//  AppExplorer
//
//  Created by Cardasis, Jonathan (J.) on 7/13/16.
//  Copyright © 2016 Cardasis, Jonathan (J.). All rights reserved.
//

import UIKit

class AppsTableViewController: UITableViewController {

    
    var applications: [SystemApplication] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 188/255.0, blue: 212/255.0, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName : UIFont(name: "Helvetica-Bold", size: 18)!]
        
        tableView.register(UINib(nibName: "AppTableViewCell", bundle: nil), forCellReuseIdentifier: "AppCell")
        tableView.separatorStyle = .none
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        
        
        // Get all apps installed on the device
        self.applications = SystemApplicationManager.sharedManager.allInstalledApplications()
        
        tableView.reloadData()
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applications.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppCell", for: indexPath) as! AppTableViewCell
        
        let application = applications[indexPath.row]
        cell.application = application //associate the app to the cell
        
        cell.appIconView.image = application.icon
        cell.title.text = application.name ?? "???" //use question marks if appname doesnt exist
        
        
        if application.type == .system {
            cell.typeTag.backgroundColor = cell.typeTag.primaryColor
            cell.typeTag.text = "System"
        } else {
            cell.typeTag.backgroundColor = cell.typeTag.secondaryTagColor
            cell.typeTag.text = "User"
        }
        
        cell.launchButton.tag = indexPath.row
        cell.launchButton.addTarget(self, action: #selector(launchAppButtonPressed), for: .touchUpInside)
        
        return cell
    }
    
    //MARK: temporary use to print contents of app from /Applications folder
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? AppTableViewCell else{
            return
        }
        
        let constructedURL = "/Applications/\(cell.application!.executableName!).app"
        DirectoryReader.printContents(constructedURL)
    }
    
    
    //MARK: - Other Functions
    func launchAppButtonPressed(_ sender: UIButton){
        let tappedCell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! AppTableViewCell
 
        if let application = tappedCell.application {
            SystemApplicationManager.sharedManager.openApplication(application)
        }
    }

}
