//
//  GameData.swift
//  GuruGuruLabyrinth
//
//  Created by Minho Choi on 2020/09/01.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import Foundation
import UIKit

class DataSet {
    
    // level data
    
    let level1 = Level(size: 4, levelName: "Easy", fogDistance: 0, skyBrightness: "art.scnassets/sky/Sky_Day_BlueSky_Equirect.png")
    let level2 = Level(size: 8, levelName: "Normal", fogDistance: 10, skyBrightness: "art.scnassets/sky/Epic_BlueSunset_EquiRect_flat.png")
    let level3 = Level(size: 12, levelName: "Hard", fogDistance: 8, skyBrightness: "art.scnassets/sky/AllSky_Overcast4_Low.png")
    let level4 = Level(size: 16, levelName: "Extreme", fogDistance: 6, skyBrightness: "art.scnassets/sky/AllSky_Night_MoonBurst Equirect.png")
    let level5 = Level(size: 20, levelName: "Impossible", fogDistance: 3, skyBrightness: "art.scnassets/sky/AllSky_Space_AnotherPlanet Equirect.png")

    lazy var levelArray: [Level] = [level1, level2, level3, level4, level5]
    
    // ball data
    
    let gold = Ball(
        name: "Gold Ball",
        diffuse: "art.scnassets/ball/TexturesCom_Metal_GoldOld_1K_albedo.tif",
        metallic: "art.scnassets/ball/TexturesCom_Metal_GoldOld_1K_metallic.tif",
        normal: "art.scnassets/ball/TexturesCom_Metal_GoldOld_1K_normal.tif",
        roughness: "art.scnassets/ball/TexturesCom_Metal_GoldOld_1K_roughness.tif",
        occlusion: "art.scnassets/ball/TexturesCom_Metal_GoldOld_1K_ao.tif",
        displacement: "art.scnassets/ball/TexturesCom_Metal_GoldOld_1K_height.tif",
        emissive: nil,
        mask: nil,
        alpha: nil,
        mass: 10,
        friction: 0.2,
        damping: 0,
        angularDamping: 0
        )
    
    let cardboard = Ball(
        name: "Cardboard Ball",
        diffuse: "art.scnassets/ball/TexturesCom_Cardboard_Dirty_1K_albedo.tif",
        metallic: nil,
        normal: "art.scnassets/ball/TexturesCom_Cardboard_Dirty_1K_normal.tif",
        roughness: "art.scnassets/ball/TexturesCom_Cardboard_Dirty_1K_roughness.tif",
        occlusion: nil,
        displacement: "art.scnassets/ball/TexturesCom_Cardboard_Dirty_1K_height.tif",
        emissive: nil,
        mask: nil,
        alpha: nil,
        mass: 1,
        friction: 0.7,
        damping: 0.3,
        angularDamping: 0.2
        )
        
    let concrete = Ball(
        name: "Concrete Ball",
        diffuse: "art.scnassets/ball/TexturesCom_Concrete_RoughWall_1K_albedo.tif",
        metallic: nil,
        normal: "art.scnassets/ball/TexturesCom_Concrete_RoughWall_1K_normal.tif",
        roughness: "art.scnassets/ball/TexturesCom_Concrete_RoughWall_1K_roughness.tif",
        occlusion: "art.scnassets/ball/TexturesCom_Concrete_RoughWall_1K_ao.tif",
        displacement: "art.scnassets/ball/TexturesCom_Concrete_RoughWall_1K_height.tif",
        emissive: nil,
        mask: nil,
        alpha: nil,
        mass: 9,
        friction: 0.6,
        damping: 0.2,
        angularDamping: 0
        )
    
    let camouflage = Ball(
        name: "Camouflage Ball",
        diffuse: "art.scnassets/ball/TexturesCom_Fabric_Camouflage2_1K_albedo.tif",
        metallic: nil,
        normal: "art.scnassets/ball/TexturesCom_Fabric_Camouflage2_1K_normal.tif",
        roughness: "art.scnassets/ball/TexturesCom_Fabric_Camouflage2_1K_roughness.tif",
        occlusion: nil,
        displacement: "art.scnassets/ball/TexturesCom_Fabric_Camouflage2_1K_height.tif",
        emissive: nil,
        mask: nil,
        alpha: "art.scnassets/ball/TexturesCom_Fabric_Camouflage2_1K_alpha.tif",
        mass: 3,
        friction: 0.7,
        damping: 0.1,
        angularDamping: 0.1
        )
    
    let wood = Ball(
        name: "Wood Ball",
        diffuse: "art.scnassets/ball/TexturesCom_Wood_OakVeneer_512_albedo.tif",
        metallic: nil,
        normal: "art.scnassets/ball/TexturesCom_Wood_OakVeneer_512_normal.tif",
        roughness: "art.scnassets/ball/TexturesCom_Wood_OakVeneer_512_roughness.tif",
        occlusion: nil,
        displacement: nil,
        emissive: nil,
        mask: nil,
        alpha: nil,
        mass: 6,
        friction: 0.4,
        damping: 0.1,
        angularDamping: 0
        )
    
    let moss = Ball(
        name: "Moss Ball",
        diffuse: "art.scnassets/ball/TexturesCom_Nature_Moss_1K_albedo.tif",
        metallic: nil,
        normal: "art.scnassets/ball/TexturesCom_Nature_Moss_1K_normal.tif",
        roughness: "art.scnassets/ball/TexturesCom_Nature_Moss_1K_roughness.tif",
        occlusion: "art.scnassets/ball/TexturesCom_Nature_Moss_1K_ao.tif",
        displacement: "art.scnassets/ball/TexturesCom_Nature_Moss_1K_height.tif",
        emissive: nil,
        mask: nil,
        alpha: nil,
        mass: 4,
        friction: 0.8,
        damping: 0.3,
        angularDamping: 0.4
        )
    
    lazy var ballArray: [Ball] = [gold, cardboard, concrete, camouflage, wood, moss]
    
    let concreteWall = WallTexture(
        name: "Concrete Wall",
        diffuse: "art.scnassets/wall/TexturesCom_Concrete_WaffleSlab_512_albedo.tif",
        metallic: nil,
        normal: "art.scnassets/wall/TexturesCom_Concrete_WaffleSlab_512_normal.tif",
        roughness: "art.scnassets/wall/TexturesCom_Concrete_WaffleSlab_512_roughness.tif",
        occlusion: "art.scnassets/wall/TexturesCom_Concrete_WaffleSlab_512_ao.tif",
        displacement: "art.scnassets/wall/TexturesCom_Concrete_WaffleSlab_512_height.tif",
        emissive: nil,
        mask: nil,
        alpha: nil
        )
    
    let brickWall = WallTexture(
        name: "Brick Wall",
        diffuse: "art.scnassets/wall/TexturesCom_Brick_Medieval_1K_albedo.tif",
        metallic: nil,
        normal: "art.scnassets/wall/TexturesCom_Brick_Medieval_1K_normal.tif",
        roughness: "art.scnassets/wall/TexturesCom_Brick_Medieval_1K_roughness.tif",
        occlusion: "art.scnassets/wall/TexturesCom_Brick_Medieval_1K_ao.tif",
        displacement: "art.scnassets/wall/TexturesCom_Brick_Medieval_1K_height.tif",
        emissive: nil,
        mask: nil,
        alpha: nil
        )
    
    let metalWall = WallTexture(
        name: "Brick Wall",
        diffuse: "art.scnassets/wall/TexturesCom_Metal_RustedSheet_1K_albedo.tif",
        metallic: nil,
        normal: "art.scnassets/wall/TexturesCom_Metal_RustedSheet_1K_normal.tif",
        roughness: "art.scnassets/wall/TexturesCom_Metal_RustedSheet_1K_roughness.tif",
        occlusion: "art.scnassets/wall/TexturesCom_Metal_RustedSheet_1K_ao.tif",
        displacement: "art.scnassets/wall/TexturesCom_Metal_RustedSheet_1K_height.tif",
        emissive: nil,
        mask: nil,
        alpha: nil
        )
    
    let paintWall = WallTexture(
        name: "Brick Wall",
        diffuse: "art.scnassets/wall/TexturesCom_Paint_Scratched_1K_albedo.tif",
        metallic: "art.scnassets/wall/TexturesCom_Paint_Scratched_1K_metallic.tif",
        normal: "art.scnassets/wall/TexturesCom_Paint_Scratched_1K_normal.tif",
        roughness: "art.scnassets/wall/TexturesCom_Paint_Scratched_1K_roughness.tif",
        occlusion: nil,
        displacement: nil,
        emissive: nil,
        mask: nil,
        alpha: nil
        )
    
    let treeWall = WallTexture(
        name: "Brick Wall",
        diffuse: "art.scnassets/wall/TexturesCom_Nature_TreeBark_1K_albedo.tif",
        metallic: nil,
        normal: "art.scnassets/wall/TexturesCom_Nature_TreeBark_1K_normal.tif",
        roughness: "art.scnassets/wall/TexturesCom_Nature_TreeBark_1K_roughness.tif",
        occlusion: "art.scnassets/wall/TexturesCom_Nature_TreeBark_1K_ao.tif",
        displacement: "art.scnassets/wall/TexturesCom_Nature_TreeBark_1K_height.tif",
        emissive: nil,
        mask: nil,
        alpha: nil
        )
        
    lazy var wallArray: [WallTexture] = [concreteWall, brickWall, metalWall, paintWall, treeWall]
}
