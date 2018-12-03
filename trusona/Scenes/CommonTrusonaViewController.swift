//
//  CommonTrusonaViewController.swift
//  trusona
//
//  Created by shinri ishikawa on 2018/11/27.
//  Copyright © 2018年 inet. All rights reserved.
//

import Foundation
import SVGKit

// 共通ビューコントローラ。
class CommonTrusonaViewController : UIViewController {
    var trusonafy = Trusonafy()
    
    @IBOutlet weak var waitView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    // ロード時。
    override func viewDidLoad() {
        super.viewDidLoad()
        trusonafy.parent = self
    }
    
    func showAlert(title: String, message: String, completionHandler: (() -> ())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: Const.CLOSE, style: UIAlertAction.Style.default, handler: {    (action:UIAlertAction!) in
            if( completionHandler != nil ) {
                completionHandler!()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showWaitView(show: Bool) {
        DispatchQueue.main.async {
            if (self.waitView != nil && self.indicator != nil) {
                self.waitView.isHidden = !show
                self.indicator.isHidden = !show
                if( show ) {
                    self.indicator.startAnimating()
                } else {
                    self.indicator.stopAnimating()
                }
            }
        }
    }
    
    func urlEncode(string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
}
