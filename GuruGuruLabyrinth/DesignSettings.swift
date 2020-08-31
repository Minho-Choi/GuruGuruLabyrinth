//
//  DesignSettings.swift
//  GuruGuruLabyrinth
//
//  Created by Minho Choi on 2020/08/24.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import SpriteKit

extension GameViewController {
    
    private struct SizeRatio {
        static let popUpWidthToBoundsWidthPhone: CGFloat = 0.8
        static let popUpHeightToBoundsHeightPhone: CGFloat = 0.5
        static let popUpWidthToBoundsWidthPad: CGFloat = 0.7
        static let popUpHeightToBoundsHeightPad: CGFloat = 0.7
        static let popUpRadiusToBoundsWidth: CGFloat = 0.05
        static let popUpStrokeThicknessToBoundsWidthRatio: CGFloat = 0.04
        
        static let buttonLengthToBoundsWidthPhone: CGFloat = 0.1
        static let buttonLengthToBoundsWidthPad: CGFloat = 0.08
        static let buttonRadiusToButtonLength: CGFloat = 0.2
        static let buttonStrokeThicknessToButtonLength: CGFloat = 0.1
        
        static let timerWidthToBoundsWidthPhone: CGFloat = 0.2
        static let timerAspectRatio: CGFloat = 0.5
    }
    internal var buttonRadius: CGFloat {
        return SizeRatio.buttonRadiusToButtonLength * buttonLength
    }
    
    internal var buttonLength: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return sceneView.frame.height * SizeRatio.buttonLengthToBoundsWidthPhone
        } else {
            return sceneView.frame.height * SizeRatio.buttonLengthToBoundsWidthPad
        }
    }
    
    internal var buttonPosition: CGPoint {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return CGPoint(x: sceneView.frame.width * 0.92, y: sceneView.frame.height * 0.86)
        } else {
            return CGPoint(x: sceneView.frame.width * 0.92, y: sceneView.frame.height * 0.90)
        }
    }
    
    internal var buttonStrokeThickness: CGFloat {
        return SizeRatio.buttonStrokeThicknessToButtonLength * buttonLength
    }
    
    internal var popUpWidth: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return sceneView.frame.width * SizeRatio.popUpWidthToBoundsWidthPhone
        } else {
            return sceneView.frame.width * SizeRatio.popUpWidthToBoundsWidthPad
        }
    }
    
    internal var popUpHeight: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return sceneView.frame.height * SizeRatio.popUpHeightToBoundsHeightPhone
        } else {
            return sceneView.frame.height * SizeRatio.popUpHeightToBoundsHeightPad
        }
    }
    
    internal var popUpRadius: CGFloat {
        return sceneView.frame.width * SizeRatio.popUpRadiusToBoundsWidth
    }
    
    internal var popUpPosition: CGPoint {
        return CGPoint(x: sceneView.frame.midX - popUpWidth / 2, y: sceneView.frame.midY - popUpHeight / 2)
    }
    
    internal var popUpStrokeThickness: CGFloat {
        return sceneView.frame.width * SizeRatio.popUpStrokeThicknessToBoundsWidthRatio
    }
}
