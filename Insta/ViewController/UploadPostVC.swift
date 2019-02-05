//
//  UploadPostVC.swift
//  Insta
//
//  Created by gil yermiyah on 31/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit
import ProgressHUD

class UploadPostVC: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var selectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        tapGesture.numberOfTapsRequired = 1
        photo.isUserInteractionEnabled = true
        photo.addGestureRecognizer(tapGesture)
        self.clearData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.handlePost()
    }
    
    
    func handlePost() {
        print("handle Post")
        self.postButton.isEnabled = (selectedImage != nil)
        self.cancelButton.isEnabled = (selectedImage != nil)
        if self.postButton.isEnabled {
            self.postButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            self.postButton.backgroundColor = .lightGray
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
    }

    @IBAction func postButton_Action(_ sender: Any) {
        print("post Button press")
        view.endEditing(true)
        ProgressHUD.show("waiting...",interaction: false)
        if let profileImg = self.selectedImage, let imageData = profileImg.jpegData(compressionQuality: 0.1) {
            HelperService.uploadDataToServer(data: imageData, caption: self.captionTextView.text) {
                self.clearData()
                self.tabBarController?.selectedIndex = 0
            }
            
        } else{
            ProgressHUD.showError("Image can't be empty")
        }
    }
    @IBAction func removeAction(_ sender: UIBarButtonItem) {
        self.clearData()
    }
    
    func clearData(){
        print("clear data")
        self.captionTextView.text = ""
        self.photo.image = UIImage(named: "camera_photo")
        self.selectedImage = nil
        handlePost()
    }
    
    @objc func handleSelectPhoto(){
        print("handle Select Photo")
        let picker = UIImagePickerController()
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate //current vc
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
}

extension UploadPostVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("did finish picking media")
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                selectedImage = image
                photo.image = image
            }
            dismiss(animated: true, completion: nil)
    }
}
