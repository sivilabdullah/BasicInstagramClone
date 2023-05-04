//
//  UploudViewController.swift
//  BasicInstagramClone
//
//  Created by abdullah's Ventura on 5.05.2023.
//

import UIKit
import PhotosUI
import FirebaseStorage
import FirebaseFirestore
import Firebase
class UploudViewController: UIViewController, PHPickerViewControllerDelegate{
   
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(accessGallery))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func accessGallery(){
        //MARK: - Image Picker
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker,animated: true)
    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self){
            let previousImage = imageView.image
            itemProvider.loadObject(ofClass: UIImage.self){[weak self] image, error in
                DispatchQueue.main.async {
                    //select image process
                    guard let self = self, let image = image as? UIImage, self.imageView.image == previousImage else {return}
                    self.imageView.image = image
                }
            }
        }
    }
    func alert (title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(okBtn)
        present(alert, animated: true)
    }
    
    @IBAction func uploadBtnClicked(_ sender: Any) {
        //MARK: - Storage
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("Media")
        
        let uuid = UUID().uuidString
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.alert(title: "upload error", message: error?.localizedDescription ?? "undefined error")
                }else{
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            
                            //MARK: - Database
                            
                            let firestoreDatabase = Firestore.firestore()
                            var ref: DocumentReference? = nil
                            let firestorePosts = ["imageUrl":imageUrl! , "postedBy": Auth.auth().currentUser!.email!, "postComment": self.commentTF.text!, "date":FieldValue.serverTimestamp(), "likes": 0] as [String : Any]
                            ref = firestoreDatabase.collection("Posts").addDocument(data: firestorePosts, completion: { error in
                                if error != nil {
                                    self.alert(title: "database error", message: error?.localizedDescription ?? "undefined error")
                                }else{
                                    self.imageView.image = UIImage(named: "image")
                                    self.commentTF.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                    if let tabBarController = self.tabBarController {
                                               let transition = CATransition()
                                        transition.type = CATransitionType.moveIn
                                               transition.duration = 0.3
                                               transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                                               tabBarController.view.layer.add(transition, forKey: nil)
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
