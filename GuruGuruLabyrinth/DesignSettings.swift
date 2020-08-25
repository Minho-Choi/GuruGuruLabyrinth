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
        static let buttonLengthToBoundsWidthPad: CGFloat = 0.15
        static let buttonRadiusToBoundsWidth: CGFloat = 0.02
        static let buttonStrokeThicknessToBoundsWidthRatio: CGFloat = 0.01
        
        //static let cornerOffsetToCornerRadius: CGFloat = 0.33
    }
    internal var buttonRadius: CGFloat {
        return sceneView.frame.width * SizeRatio.buttonRadiusToBoundsWidth
    }
    
    internal var buttonLength: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return sceneView.frame.width * SizeRatio.buttonLengthToBoundsWidthPhone
        } else {
            return sceneView.frame.width * SizeRatio.buttonLengthToBoundsWidthPad
        }
    }
    
    internal var buttonPosition: CGPoint {
        return CGPoint(x: sceneView.frame.width * 0.85, y: sceneView.frame.height * 0.92)
    }
    
    internal var buttonStrokeThickness: CGFloat {
        return sceneView.frame.width * SizeRatio.buttonStrokeThicknessToBoundsWidthRatio
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