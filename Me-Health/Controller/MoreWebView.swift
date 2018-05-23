import UIKit
import SwifterSwift
import WebKit

class MoreWebView: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var giveURL = ""
    @IBOutlet weak var webView: WKWebView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfig)
        
        view = webView
        
        let urlObj = URL(string: self.giveURL)
        let urlRequest = URLRequest(url: urlObj!)
        self.webView.load(urlRequest)
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
