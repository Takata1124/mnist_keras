//
//  UIImage_Extension.swift
//  mnist_keras
//
//  Created by t032fj on 2022/02/28.
//

import Foundation
import UIKit

public struct PixelData {
    
    var a: UInt8
    var r: UInt8
    var g: UInt8
    var b: UInt8
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

