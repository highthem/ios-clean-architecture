//
//  GradientView.swift
//  CleanArchitecture
//
//  Created by Su Ho V. on 12/18/18.
//  Copyright © 2018 mlsuho. All rights reserved.
//

import UIKit

@IBDesignable
final class GradientView: UIView {
    @IBInspectable
    var color: UIColor = .white {
        didSet {
            setupLayer()
        }
    }

    override public class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }

    private func setupLayer() {
        guard let layer = layer as? CAGradientLayer else { return }
        layer.colors = (0...10)
            .map { CGFloat($0) }
            .map { $0/10 }
            .map { color.withAlphaComponent($0).cgColor }
    }
}
