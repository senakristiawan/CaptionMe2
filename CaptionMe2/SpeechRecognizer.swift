import UIKit
import AVFoundation
import Speech

class SpeechRecognizer: UIViewController{
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var AR : ARSession?
    var mostRecentlyProcessedSegmentDuration: TimeInterval = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        AR = ARSession()
        SFSpeechRecognizer.requestAuthorization{ [unowned self] (authStatus) in
            switch authStatus{
            case .authorized:
                do{
                    try self.startRecording()
                }catch{
                    print("There was a problem starting the recording: \(error.localizedDescription)")
                    
                }
            case .denied:
                print("Akses denied")
            case .notDetermined:
                print("Speech recognition not recognized")
            case .restricted:
                print("Speech recognition restricted")
            @unknown default:
                print("Unknown authorization status")
            }
        }
    }
}

extension SpeechRecognizer{
    fileprivate func startRecording() throws{
        mostRecentlyProcessedSegmentDuration = 0

//        self.transcriptionOutputLabel.text = "Start recording"
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat){
            [unowned self] (buffer, _) in
//            print("Audio buffer received")
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        print("Audio engine start")
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request){
            (result, error) in
            if let error = error {
                print("Error during speech recognition: \(error.localizedDescription)")
                return
            }
            if let result = result {
                let transcription = result.bestTranscription.formattedString
                    print("Transcription : \(transcription)")
    //                self.transcriptOutputLabel.text = transcription
                    self.AR?.updateText(text: transcription)
                if transcription == "Indonesia"{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = storyboard.instantiateViewController(withIdentifier: "WinViewController") as! WinViewController
                        viewController.modalPresentationStyle = .fullScreen
                        self.present(viewController, animated: true, completion: nil)
                    
                }
            }
        }
    }
    fileprivate func stopRecording(){
        audioEngine.stop()
        request.endAudio()
        recognitionTask?.cancel()
        print("Recording stopped")
    }
}
