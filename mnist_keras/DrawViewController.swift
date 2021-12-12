//
//  DrawViewController.swift
//  mnist_keras
//
//  Created by t032fj on 2021/12/11.
//

import UIKit

class DrawViewController: UIViewController, UINavigationBarDelegate {
    
    @IBOutlet weak var drawImage: UIImageView!
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var navbar: UINavigationBar!
    
    let canvas = Canvas()
    
    let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleClear), for: .touchUpInside)
        return button
    }()
//
    @objc func handleClear() {
        
        canvas.clear()
        
        drawImage.image = nil
        predictionLabel.text = ""
    }
    
    fileprivate func SetUpLayout() {
        let stackView = UIStackView(arrangedSubviews: [
            clearButton
        ])

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let unit = view.frame.width / 4
        
        view.addSubview(canvas)
        canvas.backgroundColor = .white
        canvas.frame = CGRect(x: unit/2 , y:unit, width:unit*3, height:unit*3)
        
        SetUpLayout()
        
        navbar.items![0].title = "Drawing_Model"
        navbar.delegate = self
        navbar.barTintColor = .rgb(red: 200, green: 200, blue: 200)
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    var preCount: String = ""
    
    @IBAction func exchangeButton(_ sender: Any) {
        
        let viewController = ViewController()
        let myImage = canvas.GetImage() as UIImage
        
        let imgSize: Int = 28
        let imageShape: CGSize = CGSize(width: imgSize, height: imgSize)
        let imagePixel = myImage.resize(to: imageShape).getPixelBuffer()
        
        let reverseimage = viewController.imageFromARGB32Bitmap(pixels: imagePixel, width: 28, height: 28)
        
        guard let reversedimage = CIImage(image: reverseimage ?? myImage) else {
            fatalError("Could not Convert")
        }
        
        drawImage.image = reverseimage

        preCount = viewController.imagePrediction(image: reversedimage)
        predictionLabel.text = preCount
    }
    
    @IBAction func CameraViewButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}

extension UIView {

    func GetImage() -> UIImage{

        // キャプチャする範囲を取得.
        let rect = self.bounds

        // ビットマップ画像のcontextを作成.
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!

        // 対象のview内の描画をcontextに複写する.
        self.layer.render(in: context)

        // 現在のcontextのビットマップをUIImageとして取得.
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!

        // contextを閉じる.
        UIGraphicsEndImageContext()

        return capturedImage
    }
}
