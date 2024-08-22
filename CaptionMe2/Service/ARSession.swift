//
//  ARSession.swift
//  Caption Me
//
//  Created by Sena Kristiawan on 20/05/24.
//
// yg ini ga kepake
// diapus aja mas -Mas Rama

import SceneKit
import ARKit
import UIKit
//import RealityKit

class ARSession: NSObject, ARSCNViewDelegate{
    var textNode: SCNText!
    var planeNode: SCNNode!
    var occlusionNode: SCNNode!
//    var contentNode: SCNNode!

    var contentNode: SCNNode {
        let contentNode = SCNNode()
        let textNodeHolder = SCNNode()
        let planeNode = SCNNode()
        textNodeHolder.geometry = textNode
        textNodeHolder.position = SCNVector3(0, 0, -0.1)
        contentNode.addChildNode(textNodeHolder)
        contentNode.addChildNode(planeNode)
        return contentNode
    }

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let sceneView = renderer as? ARSCNView,
              let faceAnchor = anchor as? ARFaceAnchor else { return nil }

        // Get the face anchor's transform
        let faceTransform = faceAnchor.transform

        // Create a text node with the initial text (empty string)
        textNode = SCNText(string: "", extrusionDepth: 0.1)
        textNode.firstMaterial!.diffuse.contents = UIColor.black
        textNode.font = UIFont.systemFont(ofSize: 1)

        // Create a plane node (optional)
        let plane = SCNPlane(width: 1, height: 1)
        plane.firstMaterial!.diffuse.contents = UIColor.white
        planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3(0.4, 0.4, 0.4)

        // Set the text node holder's position and orientation based on the face anchor's transform
        occlusionNode = SCNNode()
        occlusionNode.geometry = textNode
        occlusionNode.position = SCNVector3(faceTransform.columns.3.x, faceTransform.columns.3.y, faceTransform.columns.3.z)
        occlusionNode.orientation = SCNVector4(faceTransform.columns.0.x, faceTransform.columns.0.y, faceTransform.columns.0.z, 0)
        
        contentNode.addChildNode(planeNode)
        contentNode.addChildNode(occlusionNode)

        return contentNode
    }

    func updateText(text: String) {
        print("Masuk ke update text")
        textNode?.string = text
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARFaceAnchor
        else { return }

        // Update the text node holder's position and orientation based on the face anchor's transform
//        let faceTransform = faceAnchor.transform
//        occlusionNode.position = SCNVector3(faceTransform.columns.3.x, faceTransform.columns.3.y, faceTransform.columns
    
    
    }
}
