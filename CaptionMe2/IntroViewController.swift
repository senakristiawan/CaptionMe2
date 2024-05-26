import UIKit

class IntroViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 246/255, green: 255/255, blue: 189/255, alpha: 1)
        
//        let startButton = UIButton(type: .system)
//        startButton.setTitle("Start", for: .normal)
//        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
//        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
//        
//        view.addSubview(startButton)
//        
//        startButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
            performSegue(withIdentifier: "showARView", sender: self)
        }
}
