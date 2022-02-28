//
//  ViewController.swift
//  mnist_keras
//
//  Created by t032fj on 2021/12/02.
//

import UIKit
import CoreML
import Vision
import SideMenu

//public struct PixelData {
//
//    var a: UInt8
//    var r: UInt8
//    var g: UInt8
//    var b: UInt8
//}

//class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UINavigationBarDelegate {
//
//    @IBOutlet weak var canvas: UIImageView!
//    @IBOutlet weak var predictLabel: UILabel!
//    @IBOutlet weak var revisedImage: UIImageView!
//    @IBOutlet weak var navbar: UINavigationBar!
//    @IBOutlet weak var shootLabel: UILabel!
//    @IBOutlet weak var revisedLabel: UILabel!
//
//    let imagePicker = UIImagePickerController()
//    let title_name = "Title"
//
////    var menu: SideMenuNavigationController?
//    var pageCount: Int = 1
//    var preCount: String = ""
//
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//
//        imagePicker.delegate = self
//        imagePicker.sourceType = .camera
//        imagePicker.isEditing = false
//
//        navbar.items![0].title = title_name
//        navbar.delegate = self
//        navbar.barTintColor = .rgb(red: 200, green: 200, blue: 200)
//
////        menu = SideMenuNavigationController(rootViewController: MenuListController())
////        menu?.leftSide = true
////
////        SideMenuManager.default.leftMenuNavigationController = menu
//
//        shootLabel.text = ""
//        revisedLabel.text = ""
//        predictLabel.text = ""
//    }
//
//    @IBAction func didTapMenu(_ sender: Any) {
//
////        present(menu!, animated: true)
//    }
//
//    @IBAction func instanceTrans(_ sender: Any) {
//
//        let storyboard = UIStoryboard(name: "Caluculator", bundle: nil)
//        let caluculateViewController = storyboard.instantiateViewController(withIdentifier: "CaluculateViewController") as! CaluculateViewController
//        caluculateViewController.modalPresentationStyle = .fullScreen
//        self.present(caluculateViewController, animated: true, completion: nil)
//    }
//
//
//    func position(for bar: UIBarPositioning) -> UIBarPosition {
//        return .topAttached
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        if let userimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//
//            canvas.image = userimage
//            shootLabel.text = "撮影画像"
//
//            let imgSize: Int = 28
//            let imageShape: CGSize = CGSize(width: imgSize, height: imgSize)
//            let imagePixel = userimage.resize(to: imageShape).getPixelBuffer()
//
//            let reverseimage = imageFromARGB32Bitmap(pixels: imagePixel, width: 28, height: 28)
//            revisedImage.image = reverseimage
//            revisedLabel.text = "加工画像"
//
//            guard let reverseimage = CIImage(image: reverseimage ?? userimage) else {
//                fatalError("Could not Convert")
//            }
//
//            let preimage = imagePrediction(image: reverseimage)
//
//            predictLabel.text = preimage
//        }
//
//        dismiss(animated: true, completion: nil)
//    }
//
//    @IBAction func cameraTap(_ sender: Any) {
//
//        if UIImagePickerController.isSourceTypeAvailable(.camera){
//
//            print("カメラは利用できます")
//            present(imagePicker, animated: true, completion: nil)
//
//        } else {
//            print("カメラは利用できません")
//        }
//    }
//
//    func imagePrediction(image: CIImage) -> String {
//
//        guard let coreMLModel = try? VNCoreMLModel(for: h5_model().model) else {
//            fatalError("Loading CoreML Model Failed")
//        }
//
//        let request = VNCoreMLRequest(model: coreMLModel) { request, error in
//            // results は confidence の高い（そのオブジェクトである可能性が高い）
//            // 順番に sort された Array で返ってきます
//            guard let results = request.results as? [VNClassificationObservation] else { return }
//
//            print(results)
//
//            if let classification = results.first {
////                self.predictLabel.text = "予測した数字は\(classification.identifier)です"
//                //                self.predictLabel.text = "\(classification.confidence)"
//                self.preCount = classification.identifier
//            }
//        }
//
//        let handler = VNImageRequestHandler(ciImage: image)
//
//        do {
//            try handler.perform([request])
//        } catch {
//            print(error)
//        }
//
//        return preCount
//    }
    
//    func imageFromARGB32Bitmap(pixels: [PixelData], width: Int, height: Int) -> UIImage? {
//
//        guard width > 0 && height > 0 else { return nil }
//        guard pixels.count == width * height else { return nil }
//
//        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
//        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
//        let bitsPerComponent = 8
//        //4byte
//        let bitsPerPixel = 32
//
//        var data = pixels // Copy to mutable []
//        guard let providerRef = CGDataProvider(data: NSData(bytes: &data,
//                                length: data.count * MemoryLayout<PixelData>.size)
//            )
//            else { return nil }
//
//        guard let cgim = CGImage(
//            width: width,
//            height: height,
//            bitsPerComponent: bitsPerComponent,
//            bitsPerPixel: bitsPerPixel,
//            bytesPerRow: width * MemoryLayout<PixelData>.size,
//            space: rgbColorSpace,
//            bitmapInfo: bitmapInfo,
//            provider: providerRef,
//            decode: nil,
//            shouldInterpolate: true,
//            intent: .defaultIntent
//            )
//            else { return nil }
//
//        return UIImage(cgImage: cgim)
//    }
//}

