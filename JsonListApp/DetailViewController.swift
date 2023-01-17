import UIKit
import Foundation
import SafariServices

class DetailViewController: UIViewController,SFSafariViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.detailLabel.text = ""
    }
    
    //var data_Detail : ItemJson!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var detailImage: UIImageView!
    
    @IBOutlet weak var detailSubTitle: UILabel!
    
    @IBOutlet weak var detailCost: UILabel!
    
    @IBAction func tapImage(_ sender: Any) {
        
        let safariViewController  = SFSafariViewController(url :detailUrl )
            safariViewController.delegate = self

            present(safariViewController, animated: true, completion: nil)
    
    }
    
    //2-4 SafariViewを閉じる時のdelegate関数
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        // SafariViewを閉じる
        dismiss(animated: true, completion: nil)
    }
    
    var detailUrl : URL = URL(fileURLWithPath: "")
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
