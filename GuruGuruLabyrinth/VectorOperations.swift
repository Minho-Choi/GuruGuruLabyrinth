//
//  VectorOperations.swift
//  TreeGame
//
//  Created by Brian Advent on 26.04.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import Foundation
import SceneKit


func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3(x:left.x + right.x, y: left.y + right.y, z: left.z + right.z)
}

func -(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3(x:left.x - right.x, y: left.y - right.y, z: left.z - right.z)
}

func +=( left: inout SCNVector3, right: SCNVector3) {
    left = left + right
}

func yRot(vector3: SCNVector3, vector4: SCNVector4) -> SCNVector3 {
    let angle = vector4.w
    let calculatedVector = SCNVector3(vector3.x * cos(angle) - vector3.z * sin(angle), vector3.y, vector3.x * sin(angle) + vector3.z * cos(angle))
    return calculatedVector
}
