//
//  DrawViewController.swift
//  mnist_keras
//
//  Created by t032fj on 2021/12/11.
//

import UIKit

class Canvas: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(10)
        context.setLineCap(.butt)
        
        lines.forEach { (line) in
            
            for (i, p) in line.enumerated() {
                
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
        }

        context.strokePath()
    }
    
//    var line = [CGPoint]()
    var lines = [[CGPoint]]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append([CGPoint]())
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else { return }
        print(point)
        
        var cgpoint = CGPoint(x: Int(point.x) - 40, y: Int(point.y - 50))
        
        guard var lastLine = lines.popLast() else { return }
        lastLine.append(cgpoint)
        lines.append(lastLine)
        
        setNeedsDisplay()
    }
}

class DrawViewController: UIViewController {
    
    @IBOutlet weak var drawImage: UIImageView!
    
    let canvas = Canvas()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let unit = view.frame.width / 4
        
        view.addSubview(canvas)
        canvas.backgroundColor = .white
//        canvas.layer.borderColor = UIColor.black.cgColor
//        canvas.layer.borderWidth = 5
        canvas.frame = CGRect(x: unit/2 , y:unit, width:unit*3, height:unit*3)
    }
    
    @IBAction func exchangeButton(_ sender: Any) {
        
        let myImage = canvas.GetImage() as UIImage
        
        drawImage.image = myImage
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
