//
//  ViewController.swift
//  Caption Me
//
//  Created by Sena Kristiawan on 15/05/24.
//

import UIKit
import ARKit
import RealityKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate{
    var arSession: ARSession?
    var speechRecognizer: SpeechRecognizer?
    
    @IBOutlet var sceneView: ARSCNView!
//    @IBOutlet var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        sceneView.delegate = self
//        sceneView.session.delegate = self
//        sceneView.automaticallyUpdatesLighting = true
        speechRecognizer = SpeechRecognizer()
//        arSession = ARSession()
//        sceneView.delegate = arSession
        
        setupView()
        
//        sceneView.scene.rootNode.addChildNode(arSession?.setupContentNode())
    }
    
    func resetTracking() {
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        if #available(iOS 13.0, *) {
            configuration.maximumNumberOfTrackedFaces = ARFaceTrackingConfiguration.supportedNumberOfTrackedFaces
        }
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
    }
    
    private func setupView() {


        if let speechRecognizer = speechRecognizer {
            addChild(speechRecognizer)
            view.addSubview(speechRecognizer.view)
            speechRecognizer.didMove(toParent: self)
        }

//        let arSessionNode = ARSession()
//        
//        sceneView.scene.rootNode.addChildNode(arSessionNode.contentNode)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // AR experiences typically involve moving the device without
        // touch input for some time, so prevent auto screen dimming.
        UIApplication.shared.isIdleTimerDisabled = true
        
        // "Reset" to run the AR session for the first time.
        resetTracking()
    }
    
    private func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            self.displayErrorMessage(title: "The AR session failed.", message: errorMessage)
        }
    }
    
    func displayErrorMessage(title: String, message: String) {
        // Present an alert informing about the error that has occurred.
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.resetTracking()
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }

}



