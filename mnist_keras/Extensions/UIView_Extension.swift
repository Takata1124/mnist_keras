//
//  UIView_Extension.swift
//  mnist_keras
//
//  Created by t032fj on 2022/02/28.
//

import Foundation
import UIKit

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

