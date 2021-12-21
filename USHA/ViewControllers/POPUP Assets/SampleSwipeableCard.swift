//
//  SampleSwipeableCard.swift
//  Swipeable-View-Stack
//
//  Created by Phill Farrugia on 10/21/17.
//  Copyright © 2017 Phill Farrugia. All rights reserved.
//

import UIKit
import CoreMotion

class SampleSwipeableCard: SwipeableCardViewCard {

    @IBOutlet  weak var titleLabel: UILabel!
    @IBOutlet  weak var subtitleLabel: UILabel!
    @IBOutlet  weak var imgIcon: UIImageView!
    @IBOutlet  weak var btnAttachment: UIButton!

    @IBOutlet private weak var backgroundContainerView: UIView!
    @IBOutlet weak var backgroundHeight: NSLayoutConstraint!

    /// Core Motion Manager
    private let motionManager = CMMotionManager()

    /// Shadow View
    private weak var shadowView: UIView?

    /// Inner Margin
    private static let kInnerMargin: CGFloat = 20.0

    var viewModel: SampleSwipeableCellViewModel? {
        didSet {
            configure(forViewModel: viewModel)
        }
    }

    private func configure(forViewModel viewModel: SampleSwipeableCellViewModel?) {
        if let viewModel = viewModel {
            titleLabel.text = viewModel.sTitile
            subtitleLabel.text = viewModel.sTextMessage
            
            let documentType = viewModel.sAttachmentType
            
            if documentType == "Image"{

                guard let url = URL(string: mainUrlPowerPlus + "notificationupload/\(viewModel.sAttachementPath ?? "")") else { return }

                UIImage.loadFrom(url: url) { image in
                    self.imgIcon.image = image
                }
                
                self.btnAttachment.setTitle("VIEW IMAGE", for: .normal)
                self.btnAttachment.accessibilityValue = viewModel.sAttachementPath
                

            }else if documentType == "Document"{
                
                self.imgIcon.image = UIImage(named: "documentPop")
                self.btnAttachment.setTitle("VIEW DOCUMENT", for: .normal)

            self.btnAttachment.accessibilityValue = viewModel.sAttachementPath
            }else if documentType == "Video"{
                
                self.imgIcon.image = UIImage(named: "videoPop")
                self.btnAttachment.setTitle("VIEW VIDEO", for: .normal)

                self.btnAttachment.accessibilityValue = viewModel.sAttachementPath

            }else  if documentType == "Audio"{
                self.imgIcon.image = UIImage(named: "audioPop")
                self.btnAttachment.setTitle("LISTEN AUDIO", for: .normal)

                self.btnAttachment.accessibilityValue = viewModel.sAttachementPath
                
            }else{
                self.btnAttachment.isHidden = true
                self.imgIcon.image = UIImage(named: "TextPop")

            }
            
            self.backgroundHeight.constant = 0

            self.btnAttachment.addTarget(self, action: #selector(openAttachment), for: .touchUpInside)

            
            backgroundContainerView.layer.borderWidth = 1.0
            backgroundContainerView.layer.borderColor = UIColor.lightGray.cgColor
            backgroundContainerView.layer.cornerRadius = 14.0
            backgroundContainerView.frame = CGRect(x: 0, y: 0, width: 400, height: 200)
        }
    }

    @objc func openAttachment(_ sender : UIButton)    {
        
        let openUrl = mainUrlPowerPlus + "notificationupload/\(sender.accessibilityValue ?? "")"
        
        guard let url = URL(string: openUrl) else { return }
        UIApplication.shared.open(url)
        
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()

    //    configureShadow()
    }
    
    
    
    
    

    // MARK: - Shadow

    private func configureShadow() {
        // Shadow View
        self.shadowView?.removeFromSuperview()
        let shadowView = UIView(frame: CGRect(x: SampleSwipeableCard.kInnerMargin,
                                              y: SampleSwipeableCard.kInnerMargin,
                                              width: bounds.width - (2 * SampleSwipeableCard.kInnerMargin),
                                              height: bounds.height - (2 * SampleSwipeableCard.kInnerMargin)))
        insertSubview(shadowView, at: 0)
        self.shadowView = shadowView

        // Roll/Pitch Dynamic Shadow
//        if motionManager.isDeviceMotionAvailable {
//            motionManager.deviceMotionUpdateInterval = 0.02
//            motionManager.startDeviceMotionUpdates(to: .main, withHandler: { (motion, error) in
//                if let motion = motion {
//                    let pitch = motion.attitude.pitch * 10 // x-axis
//                    let roll = motion.attitude.roll * 10 // y-axis
//                    self.applyShadow(width: CGFloat(roll), height: CGFloat(pitch))
//                }
//            })
//        }
        self.applyShadow(width: CGFloat(0.0), height: CGFloat(0.0))
    }

    private func applyShadow(width: CGFloat, height: CGFloat) {
        if let shadowView = shadowView {
            let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 14.0)
            shadowView.layer.masksToBounds = false
            shadowView.layer.shadowRadius = 8.0
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: width, height: height)
            shadowView.layer.shadowOpacity = 0.15
            shadowView.layer.shadowPath = shadowPath.cgPath
        }
    }

}


extension UIImage {

    public static func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

}
