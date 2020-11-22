//
//  ViewController.swift
//  VacCalc
//
//  Created by Sumrudhi Jadhav on 11/21/20.
//  Copyright © 2020 CATS. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var inStockTextField: UITextField!
    @IBOutlet weak var neededTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var hospital: Hospital?
    
    // MARK: UITextFieldDelegate
     
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing
        saveButton.isEnabled = false
    }
     
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {

         // Hide the keyboard

         textField.resignFirstResponder()
         return true

     }
     
     func textFieldDidEndEditing(_ textField: UITextField) {
         updateSaveButtonState()
         navigationItem.title = nameTextField.text
     }
    
    // MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways
        let isPresentingInAddHospitalMode = presentingViewController is UINavigationController
        if isPresentingInAddHospitalMode{
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ViewController is not inside a navigation controller")
        }
        
    }
    
    // This method lets you configure a view controller before it's presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("the save button was not pressed, cancelling", log: OSLog.default, type:.debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let inStock = inStockTextField.text ?? ""
        let needed = neededTextField.text ?? ""
        let photo = photoImageView.image
        
        // Set the meal to be passed to HospitalTableViewController after the unwind degue
        hospital = Hospital(name: name, inStock: inStock, needed: needed, photo: photo)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ _picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Actions
    
    @IBAction func enterTapped(_ sender: Any) {
        textView.isScrollEnabled = false
        textView.text = "In the hospital at \(nameTextField.text!), there are \(inStockTextField.text!).\nThere are \(neededTextField.text!)."
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard
        nameTextField.resignFirstResponder()
        inStockTextField.resignFirstResponder()
        neededTextField.resignFirstResponder()

        // UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()

        // Only allow photos to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self

        // Make sure ViewController is notified when the user picks an image
        present(imagePickerController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        // Handle the text field's user input through delegate callbacks
        
        nameTextField.delegate = self
        inStockTextField.delegate = self
        neededTextField.delegate = self
        
        // Set up views if editing an existing Hospital
        if let hospital = hospital {
            navigationItem.title = hospital.name
            nameTextField.text = hospital.name
            inStockTextField.text = hospital.inStock
            neededTextField.text = hospital.needed
            photoImageView.image = hospital.photo
        }
        
        // Enable the Save button only if the text field has a valid Hospital name
        updateSaveButtonState()
        
        
    }
    
    // MARK: Private Methods
    
    private func updateSaveButtonState() {
        //Disable the Save button if the text field is empty
        let nameText = nameTextField.text ?? ""
        let inStockText = inStockTextField.text ?? ""
        let neededText = neededTextField.text ?? ""
        saveButton.isEnabled = !nameText.isEmpty
        saveButton.isEnabled = !inStockText.isEmpty
        saveButton.isEnabled = !neededText.isEmpty

    }
}
