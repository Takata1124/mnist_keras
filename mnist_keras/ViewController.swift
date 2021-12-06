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
            
//            guard let pixeluiimage = imageFromARGB32Bitmap(pixels: imagePixel, width: 28, height: 28) else {
//
//                fatalError("Could not pixel")
//            }
            
            //            guard let pixelcgimage: CGImage = RBGImage(data: imagePixel, width: 28, height: 28)
            //
            //            let pixeluiImage = UIImage(cgImage: pixelcgimage)
            
            var pixels = [PixelData]()

            let red = PixelData(a: 255, r: 255, g: 0, b: 0)
            let green = PixelData(a: 255, r: 0, g: 255, b: 0)
            let blue = PixelData(a: 255, r: 0, g: 0, b: 255)

            for _ in 1...900 {
                pixels.append(red)
            }
//            for _ in 1...300 {
//                pixels.append(green)
//            }
//            for _ in 1...300 {
//                pixels.append(blue)
//            }

            let image = imageFromARGB32Bitmap(pixels: pixels, width: 30, height: 30)
            reviesedImage.image = image
            
            print(imagePixel)
            print(type(of: imagePixel))
            
            guard let ciimage = CIImage(image: userimage) else {
                fatalError("Could not Convert")
            }
            
            imagePrediction(image: ciimage)
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
    
    //    func RBGImage(data: [UInt8], width: Int, height: Int) -> CGImage? {
    //
    //        let bitsPerComponent = 8
    //        let numberOfComponents = 3
    //        let bitsPerPixel = bitsPerComponent * numberOfComponents
    //        let bytesPerPixel = bitsPerPixel / 8
    //
    //        guard width > 0, height > 0 else { return nil }
    //        guard width * height * numberOfComponents == data.count else { return nil }
    //
    //        return CGDataProvider(dataInfo: nil, data: data, size: data.count) { _,_,_ in }
    //            .flatMap {
    //                CGImage(width: width,
    //                        height: height,
    //                        bitsPerComponent: bitsPerComponent,
    //                        bitsPerPixel: bitsPerPixel,
    //                        bytesPerRow: width * bytesPerPixel,
    //                        space: CGColorSpaceCreateDeviceRGB(),
    //                        bitmapInfo: [],
    //                        provider: $0,
    //                        decode: nil,
    //                        shouldInterpolate: false,
    //                        intent: .defaultIntent)
    //        }
    //    }
    
    
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
    func getPixelBuffer() -> [UInt8]
    {
        guard let cgImage = self.cgImage else {
            return []
        }
        let bytesPerRow = cgImage.bytesPerRow
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let pixelData = cgImage.dataProvider!.data! as Data
        var buf : [UInt8] = []
        
        for j in 0..<height {
            for i in 0..<width {
                let pixelInfo = bytesPerRow * j + i * bytesPerPixel
                let r = CGFloat(pixelData[pixelInfo])
                let g = CGFloat(pixelData[pixelInfo+1])
                let b = CGFloat(pixelData[pixelInfo+2])
                
                let v: Float = floor(Float(r + g + b)/3.0)
                //                /255.0
//                let v_int: Int = Int(v)
                let v_uint: UInt8 = UInt8.init(v)
                
                buf.append(v_uint)
            }
        }
        return buf
    }
    
    
}
