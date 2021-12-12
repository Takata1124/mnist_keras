//
//  ViewController.swift
//  mnist_keras
//
//  Created by t032fj on 2021/12/02.
//

import UIKit
import CoreML
import Vision

public struct PixelData {
    
    var a: UInt8
    var r: UInt8
    var g: UInt8
    var b: UInt8
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UINavigationBarDelegate {
    
    @IBOutlet weak var canvas: UIImageView!
    @IBOutlet weak var predictLabel: UILabel!
    @IBOutlet weak var revisedImage: UIImageView!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var shootLabel: UILabel!
    @IBOutlet weak var revisedLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.isEditing = false
        
        navbar.items![0].title = "Mnist_Model"
        navbar.delegate = self
        navbar.barTintColor = .rgb(red: 200, green: 200, blue: 200)
        
        shootLabel.text = ""
        revisedLabel.text = ""
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            canvas.image = userimage
            shootLabel.text = "撮影画像"
            
            let imgSize: Int = 28
            let imageShape: CGSize = CGSize(width: imgSize, height: imgSize)
            let imagePixel = userimage.resize(to: imageShape).getPixelBuffer()

            let reverseimage = imageFromARGB32Bitmap(pixels: imagePixel, width: 28, height: 28)
            revisedImage.image = reverseimage
            revisedLabel.text = "加工画像"
            
            guard let reverseimage = CIImage(image: reverseimage ?? userimage) else {
                fatalError("Could not Convert")
            }
            
            guard let ciimage = CIImage(image: userimage) else {
                fatalError("Could not Convert")
            }
            
            imagePrediction(image: reverseimage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraTap(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            print("カメラは利用できます")
            
            present(imagePicker, animated: true, completion: nil)
            
        } else {
            print("カメラは利用できません")
        }
    }
    
    func imagePrediction(image: CIImage) {
        
        guard let coreMLModel = try? VNCoreMLModel(for: h5_model().model) else {
            fatalError("Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: coreMLModel) { request, error in
            // results は confidence の高い（そのオブジェクトである可能性が高い）
            // 順番に sort された Array で返ってきます
            guard let results = request.results as? [VNClassificationObservation] else { return }
            
            print(results)
            
            if let classification = results.first {
                self.predictLabel.text = "予測した数字は\(classification.identifier)です"
                //                self.predictLabel.text = "\(classification.confidence)"
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    func imageFromARGB32Bitmap(pixels: [PixelData], width: Int, height: Int) -> UIImage? {
        
        guard width > 0 && height > 0 else { return nil }
        guard pixels.count == width * height else { return nil }

        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let bitsPerComponent = 8
        //4byte
        let bitsPerPixel = 32

        var data = pixels // Copy to mutable []
        guard let providerRef = CGDataProvider(data: NSData(bytes: &data,
                                length: data.count * MemoryLayout<PixelData>.size)
            )
            else { return nil }

        guard let cgim = CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: width * MemoryLayout<PixelData>.size,
            space: rgbColorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
            )
            else { return nil }

        return UIImage(cgImage: cgim)
    }
    
    @IBAction func drawTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "DrawView", bundle: nil)
        let drawViewController = storyboard.instantiateViewController(withIdentifier: "DrawViewController")
        drawViewController.modalPresentationStyle = .fullScreen
        self.present(drawViewController, animated: true, completion: nil)
    }
    
}

extension UIImage {
    
    //画像を指定のサイズにリサイズする（参考サイトのコードそのまま）。
    func resize(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize.width, height: newSize.height), true, 1.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    //画像をpixelDataに変換。
    //Mnistのデータは数字が白で背景が黒のため、RGBを反転
    
    func getPixelBuffer() -> [PixelData]
    {
        guard let cgImage = self.cgImage else {
            return []
        }
        let bytesPerRow = cgImage.bytesPerRow
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let pixelData = cgImage.dataProvider!.data! as Data
        
        var pixels = [PixelData]()
        
        for j in 0..<height {
            for i in 0..<width {
                let pixelInfo = bytesPerRow * j + i * bytesPerPixel
                let r = CGFloat(pixelData[pixelInfo])
                let g = CGFloat(pixelData[pixelInfo+1])
                let b = CGFloat(pixelData[pixelInfo+2])
//                let a = CGFloat(pixelData[pixelInfo+3])
                
                let r_uint: UInt8 = UInt8.init(r)
                let g_uint: UInt8 = UInt8.init(g)
                let b_uint: UInt8 = UInt8.init(b)
//                let a_uint: UInt8 = UInt8.init(a)
                
                let uint_change: UInt8 = UInt8.init(Float(255))
                
                let r_uint_rev: UInt8 = uint_change - r_uint
                let g_uint_rev: UInt8 = uint_change - g_uint
                let b_uint_rev: UInt8 = uint_change - b_uint
//                let a_uint_rev: UInt8 = uint_change - a_uint

                let red = PixelData(a: 255, r: r_uint_rev, g: g_uint_rev, b: b_uint_rev)
                pixels.append(red)
            }
        }
        
        return pixels
    }
}
