//
//  Draw.swift
//  MyFirstApplication
//
//  Created by Dmytro Hetman on 18.05.2022.
//

import Foundation
import UIKit

struct BigBookmark {
    
    static func setImageToSupplementaryView(for imageView: UIImageView) -> UIView {
        imageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        print("here")
        let bookmarkSize = Const.bookmarkSize
        let supplementaryView = UIView()
        supplementaryView.frame = CGRect(x: imageView.bounds.midX - CGFloat(bookmarkSize/3.0), y: imageView.bounds.midY - CGFloat(bookmarkSize/2.0), width: CGFloat(bookmarkSize/1.5), height: CGFloat(bookmarkSize))
        supplementaryView.backgroundColor = .clear
        supplementaryView.alpha = 0.0
        drawBookmark(in: supplementaryView)
        print(imageView.frame.width)
        print(imageView.bounds.midX)
        print(CGFloat(bookmarkSize/3.0))
        print(CGFloat(bookmarkSize/1.5))
        imageView.addSubview(supplementaryView)
        
        return supplementaryView
    }
    
    private static func drawBookmark(in view: UIView) {
        view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        print("draw")
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: view.frame.width, y: 0))
        path.addLine(to: CGPoint(x: view.frame.width, y: view.frame.height))
        path.addLine(to: CGPoint(x: view.frame.width/2.0, y: view.frame.height*CGFloat(0.75)))
        path.addLine(to: CGPoint(x: 0, y: view.frame.height))
        path.close()
        
        
        let bigBookmarksShapeLayer = CAShapeLayer()
        bigBookmarksShapeLayer.frame = view.bounds
        bigBookmarksShapeLayer.path = path.cgPath
        
        bigBookmarksShapeLayer.fillColor = UIColor.white.cgColor
        
        view.layer.addSublayer(bigBookmarksShapeLayer)
    }
    
}
