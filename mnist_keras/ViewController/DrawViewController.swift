//
//  DrawViewController.swift
//  mnist_keras
//
//  Created by t032fj on 2021/12/11.
//

import UIKit
import CoreML
import Vision

class DrawViewController: UIViewController, UINavigationBarDelegate {
    
    @IBOutlet weak var drawImage: UIImageView!
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var navbar: UINavigationBar!
    
    let canvas = Canvas()
    var preCount: String = ""
    let title_name = "DrawView"
    
    let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleClear), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let unit = view.frame.width / 4
        
        view.addSubview(canvas)
        canvas.backgroundColor = .white
        canvas.frame = CGRect(x: unit/2 , y:unit, width:unit*3, height:unit*3)
        navbar.items![0].title = title_name
        navbar.delegate = self
        navbar.barTintColor = .rgb(red: 200, green: 200, blue: 200)
        
        SetUpLayout()
    }
    
    private func SetUpLayout() {
        
        let stackView = UIStackView(arrangedSubviews: [
            clearButton
        ])
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    @objc func handleClear() {
        
        canvas.clear()
        drawImage.image = nil
        predictionLabel.text = ""
    }
    
    @IBAction func exchangeButton(_ sender: Any) {
        
        let myImage = canvas.GetImage() as UIImage
        let imgSize: Int = 28
        let imageShape: CGSize = CGSize(width: imgSize, height: imgSize)
        let imagePixel = myImage.resize(to: imageShape).getPixelBuffer()
        let reverseimage = imageFromARGB32Bitmap(pixels: imagePixel, width: 28, height: 28)
        
        guard let reversedimage = CIImage(image: reverseimage ?? myImage) else {
            fatalError("Could not Convert")
        }
        
        drawImage.image = reverseimage
        preCount = imagePrediction(image: reversedimage)
        predictionLabel.text = preCount
    }
    
    func imagePrediction(image: CIImage) -> String {
        
        guard let coreMLModel = try? VNCoreMLModel(for: h5_model().model) else {
            fatalError("Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: coreMLModel) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else { return }
            
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
    
    func imageFromARGB32Bitmap(pixels: [PixelData], width: Int, height: Int) -> UIImage? {
        
        guard width > 0 && height > 0 else { return nil }
        guard pixels.count == width * height else { return nil }
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let bitsPerComponent = 8
        let bitsPerPixel = 32
        
        var data = pixels
        guard let providerRef = CGDataProvider(data: NSData(bytes: &data,length: data.count * MemoryLayout<PixelData>.size)) else { return nil }
        
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
