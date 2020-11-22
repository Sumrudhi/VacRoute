//
//  HospitalTableViewController.swift
//  VacCalc
//
//  Created by Sumrudhi Jadhav on 11/22/20.
//  Copyright © 2020 CATS. All rights reserved.
//

import UIKit
import os.log

class HospitalTableViewController: UITableViewController {

    // MARK: Properties
    
    var hospitals = [Hospital]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved hospitals, otherwise load sample data
        if let savedHospitals = loadHospitals() {
            hospitals += savedHospitals
        } else {
            // Load the sample data
            loadSampleHospitals()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return hospitals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        // Table view cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "HospitalTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HospitalTableViewCell  else {
            fatalError("The dequeued cell is not an instance of HospitalTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let hospital = hospitals[indexPath.row]
        
        cell.nameLabel.text = hospital.name
        cell.photoImageView.image = hospital.photo
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            hospitals.remove(at: indexPath.row)
            saveHospitals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)

        switch(segue.identifier ?? "") {

        case "AddItem":
            os_log("Adding a new hospital.", log: OSLog.default, type: .debug)

        case "ShowDetail":
            guard let hospitalDetailViewController = segue.destination as? ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }

            guard let selectedHospitalCell = sender as? HospitalTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }

            guard let indexPath = tableView.indexPath(for: selectedHospitalCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }

            let selectedHospital = hospitals[indexPath.row]
            hospitalDetailViewController.hospital = selectedHospital

        default:
            break
        }
    }
    

    // MARK: Actions
    @IBAction func unwindToHospitalList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ViewController, let hospital = sourceViewController.hospital {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                hospitals[selectedIndexPath.row] = hospital
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new hospital.
                let newIndexPath = IndexPath(row: hospitals.count, section: 0)
                
                hospitals.append(hospital)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the hospitals
            saveHospitals()
        }
    }
    
    
    // MARK: Private Methods
    
    private func loadSampleHospitals() {
        let photo1 = UIImage(named : "hospital1")
        let photo2 = UIImage(named : "hospital2")
        let photo3 = UIImage(named : "hospital3")
        
        guard let hospital1 = Hospital(name: "Medical Center of Princetown, 88 Princeton Hightstown Rd # 202, Princeton Junction, NJ 08550", inStock: "5 Vaccines in Stock", needed: "7 Vaccines Needed", photo: photo1) else{
            fatalError("Unable to instantiate hospital1")
        }
        
        guard let hospital2 = Hospital(name: "Children's Hospital Of Philadelphia, 101 Plainsboro Road​, Plainsboro Township, NJ 08536", inStock: "9 Vaccines in Stock", needed: "20 Vaccines Needed", photo: photo2) else{
            fatalError("Unable to instantiate hospital2")
        }
        
        guard let hospital3 = Hospital(name: "Princeton Hospital, 25 Plainsboro Rd, Princeton, NJ 08540", inStock: "1 Vaccine in Stock", needed: "35 Vaccines Needed", photo: photo3) else{
            fatalError("Unable to instantiate hosptial3")
        }
        
        hospitals += [hospital1, hospital2, hospital3]
    }
    
    private func saveHospitals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(hospitals, toFile: Hospital.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Hospitals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadHospitals() -> [Hospital]? {
       return NSKeyedUnarchiver.unarchiveObject(withFile: Hospital.ArchiveURL.path) as? [Hospital]
    }
    
}
