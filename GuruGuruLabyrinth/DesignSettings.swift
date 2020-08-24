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
        static let popUpRadiusToBoundsWidth: CGFloat = 0.1
        static let buttonLengthToBoundsWidthPhone: CGFloat = 0.1
        static let buttonLengthToBoundsWidthPad: CGFloat = 0.15
        static let buttonRadiusToBoundsWidth: CGFloat = 0.05
        
        //static let cornerOffsetToCornerRadius: CGFloat = 0.33
    }
    private var buttonRadius: CGFloat {
        return sceneView.frame.width * SizeRatio.buttonRadiusToBoundsWidth
    }
    
    private var buttonLength: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return sceneView.frame.width * SizeRatio.buttonLengthToBoundsWidthPhone
        } else {
            return sceneView.frame.width * SizeRatio.buttonLengthToBoundsWidthPad
        }
    }
    
    private var popUpWidth: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return sceneView.frame.width * SizeRatio.popUpWidthToBoundsWidthPhone
        } else {
            return sceneView.frame.width * SizeRatio.popUpWidthToBoundsWidthPad
        }
    }
    
    private var popUpHeight: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return sceneView.frame.height * SizeRatio.popUpHeightToBoundsHeightPhone
        } else {
            return sceneView.frame.height * SizeRatio.popUpHeightToBoundsHeightPad
        }
    }
    
    private var popUpRadius: CGFloat {
        return sceneView.frame.width * SizeRatio.popUpRadiusToBoundsWidth
    }
}
