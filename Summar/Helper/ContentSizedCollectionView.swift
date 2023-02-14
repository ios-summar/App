//
//  ContentSizedCollectionView.swift
//  Summar
//
//  Created by plsystems on 2023/02/14.
//

import Foundation
import UIKit

final class ContentSizedCollectionView: UICollectionView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
