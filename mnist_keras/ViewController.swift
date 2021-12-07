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

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var canvas: UIImageView!
    @IBOutlet weak var predictLabel: UILabel!
    @IBOutlet weak var reviesedImage: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.isEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            canvas.image = userimage
            
            let imgSize: Int = 28
            let imageShape: CGSize = CGSize(width: imgSize, height: imgSize)
            let imagePixel = userimage.resize(to: imageShape).getPixelBuffer()

            let reverseimage = imageFromARGB32Bitmap(pixels: imagePixel, width: 28, height: 28)
            reviesedImage.image = reverseimage
            
            guard let reverseimage = CIImage(image: reverseimage ?? userimage) else {
                fatalError("Could not Convert")
            }
            print(type(of: reverseimage))
            
            guard let ciimage = CIImage(image: userimage) else {
                fatalError("Could not Convert")
            }
            
//            imagePrediction(image: ciimage)
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
                self.predictLabel.text = classification.identifier
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
    
    //画像をpixelBufferに変換。ただし参考サイトのコードを一部変更して、
    //ピクセル値を二値化はせずに0.0〜1.0の値として扱う（元々のモデルに合わせる）
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
                let a = CGFloat(pixelData[pixelInfo+3])
                
                let r_uint: UInt8 = UInt8.init(r)
                let g_uint: UInt8 = UInt8.init(g)
                let b_uint: UInt8 = UInt8.init(b)
                let a_uint: UInt8 = UInt8.init(a)
                
                let uint_change: UInt8 = UInt8.init(Float(255))
                
                let r_uint_rev: UInt8 = uint_change - r_uint
                let g_uint_rev: UInt8 = uint_change - g_uint
                let b_uint_rev: UInt8 = uint_change - b_uint
                let a_uint_rev: UInt8 = uint_change - a_uint
                
                print(r_uint, r_uint_rev)

//                let red = PixelData(a: a_uint, r: r_uint, g: g_uint, b: b_uint)
                let red = PixelData(a: 255, r: r_uint_rev, g: g_uint_rev, b: b_uint_rev)
                pixels.append(red)
            }
        }
        
        return pixels
    }
}
