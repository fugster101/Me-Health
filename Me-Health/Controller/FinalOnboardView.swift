import UIKit
import SwifterSwift
import AVFoundation
import Photos

class FinalOnboardView: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var userImage: UIButtonX!
    @IBOutlet weak var userName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.delegate = self
    }
    @IBAction func getStartedFucntion(_ sender: Any) {
        if userName.text != nil && userName.text != ""{
            let userDefaults = UserDefaults()
            userDefaults.set(true, forKey: "onboardComplete")
            userDefaults.set(self.userName.text?.firstUppercased, forKey: "userName")
            userDefaults.synchronize()
            performSegue(withIdentifier: "seguetoMain", sender: self)
        }
        else{
            userName.shake()
        }
    }
    
    @IBAction func imagePickerfunc(_ sender: Any) {
        
        let actionController = UIAlertController(title: nil , message: nil,  preferredStyle: .actionSheet)
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "Use Camera", style: .default) { (action) in
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                    if granted{
                        self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
                        self.imagePicker.sourceType = .camera
                        self.imagePicker.allowsEditing = true
                        
                        DispatchQueue.main.async {
                            self.present(self.imagePicker, animated: true, completion: nil)
                        }
                    }
                })
            }
            actionController.addAction(cameraAction)
        }
        
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoAction = UIAlertAction(title: "Use Photo Libary", style: .default) { (action) in
                
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == PHAuthorizationStatus.authorized{
                        self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                        self.imagePicker.sourceType = .photoLibrary
                        self.imagePicker.allowsEditing = true
                        DispatchQueue.main.async {
                            self.present(self.imagePicker, animated: true, completion: nil)
                        }
                    }
                })
            }
            actionController.addAction(photoAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionController.addAction(cancelAction)
        
        present(actionController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let userchosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        self.userImage.imageView?.contentMode = .scaleAspectFill
        self.userImage.imageView?.cornerRadius = 50
        self.userImage.cornerRadius = userImage.frame.width / 2
        self.userImage.setImage(userchosenImage, for: .normal)
        
        let userDefaults = UserDefaults()
        let imageData:NSData = UIImagePNGRepresentation((self.userImage.imageView?.image)!)! as NSData
        userDefaults.set(imageData, forKey: "userImage")
        userDefaults.synchronize()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
}
