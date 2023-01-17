import UIKit
import Foundation

class DetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.detailLabel.text = ""
    }
    
    //var data_Detail : ItemJson!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var detailImage: UIImageView!
    
    @IBOutlet weak var detailSubTitle: UILabel!
    
    @IBOutlet weak var detailCost: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
