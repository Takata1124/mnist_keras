//
//  CaluculateViewController.swift
//  mnist_keras
//
//  Created by t032fj on 2021/12/14.
//

import UIKit
import CoreML
import Vision

class CaluculateViewController: UIViewController, UINavigationBarDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var pageCount: Int = 0
    
    @IBOutlet weak var canvas: UIImageView!
    @IBOutlet weak var predictLabel: UILabel!
    @IBOutlet weak var revisedImage: UIImageView!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var shootLabel: UILabel!
    @IBOutlet weak var revisedLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    let title_name = "Mark"
    
    var preCount: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.isEditing = false
        
        navbar.items![0].title = title_name
        navbar.delegate = self
        navbar.barTintColor = .rgb(red: 200, green: 200, blue: 200)

        shootLabel.text = ""
        revisedLabel.text = ""
        predictLabel.text = ""
    }

    @IBAction func cameraTap(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            print("カメラは利用できます")
            
            present(imagePicker, animated: true, completion: nil)
            
        } else {
            print("カメラは利用できません")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            canvas.image = userimage
            shootLabel.text = "撮影画像"
            
            let imgSize: Int = 28
            let imageShape: CGSize = CGSize(width: imgSize, height: imgSize)
            let imagePixel = userimage.resize(to: imageShape)
            revisedImage.image = imagePixel
            revisedLabel.text = "加工画像"
            
            guard let ciimage = CIImage(image: imagePixel ) else {
                fatalError("Could not Convert")
            }
            
            let preimage = mark_imagePrediction(image: ciimage)
            
            predictLabel.text = preimage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func mark_imagePrediction(image: CIImage) -> String {
        
        guard let coreMLModel = try? VNCoreMLModel(for: h5_mark_model().model) else {
            fatalError("Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: coreMLModel) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else { return }
            
            print(results)
            
            if let classification = results.first {
                self.preCount = classification.identifier
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
        return preCount
    }
}
