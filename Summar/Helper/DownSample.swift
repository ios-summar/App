//
//  DownSample.swift
//  Summar
//
//  Created by ukBook on 2023/02/17.
//  https://stackoverflow.com/questions/42538599/kingfisher-image-resize-on-image-loaded-from-url king fisher imageresize

import Foundation
import UIKit

func downSample(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat) -> UIImage {
    let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
    let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions)!
    let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
    let downsampleOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
                             kCGImageSourceShouldCacheImmediately: true,
                             kCGImageSourceCreateThumbnailWithTransform: true,
                             kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
    let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)!
    return UIImage(cgImage: downsampledImage)
}

func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {

    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
}

func resize(image: UIImage, newWidth: CGFloat) -> UIImage {
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale

    let size = CGSize(width: newWidth, height: newHeight)
    let render = UIGraphicsImageRenderer(size: size)
    let renderImage = render.image { context in
        image.draw(in: CGRect(origin: .zero, size: size))
    }
    
    return renderImage
}
