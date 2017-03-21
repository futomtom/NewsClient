
import UIKit
class HeaderView : UICollectionReusableView {
    @IBOutlet var label: UILabel!
    
    var title = "" {
        didSet {
            label.text = title
        }
    }
    
    override func prepareForReuse() {
        title = ""
    }
}
