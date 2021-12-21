//
//  Base.lproj bn-IN.lproj en.lproj gu-IN.lproj hi-IN.lproj kn-IN.lproj ml-IN.lproj mr-IN.lproj pa-IN.lproj GradientView.swift
//  MatchpointGPS
//
//  Created by Amrit Singh on 8/11/17.
//  Copyright © 2017 foxsolution. All rights reserved.
//

import UIKit

let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0)

let colorMidal =  UIColor(red: 200.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0)

let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0)

@IBDesignable
class GradientView: UIView
{
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var startColor:   UIColor = colorTop { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = colorBottom { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.2 { didSet { updateLocations() }}
    //@IBInspectable var midalLocation: Double =   0.50 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.80 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors    = [startColor.cgColor, endColor.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }
}
