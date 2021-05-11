//
//  DetailViewController.swift
//  MyMovieChart
//
//  Created by 서동운 on 2021/05/11.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    
    var mvo: MovieVO!
    
    override func viewDidLoad() {
        NSLog("\(self.mvo.detail!), \(self.mvo.title!)")
        
        let navibar = self.navigationItem
        navibar.title = self.mvo.title
        
        if let url = self.mvo?.detail {
            if let urlObj = URL(string: url) {
                let req = URLRequest(url: urlObj)
                self.webView.load(req)
                if self.webView.isLoading {
                    print("로딩중")
                }
            }else{//잘못된 URL형식일 경우
                let alert = UIAlertController(title: "오류", message: "잘못된 URL입니다.", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "취소", style: .cancel){ (_) in
                    _ = self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: false, completion: nil)
            
            }
            
        
        }else{//URL값이 전달되지 않았을 경우
            let alert = UIAlertController(title: "오류", message: "URL이 누락되었습니다.", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel){ (_) in
                _ = self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: false, completion: nil)
        }
    }
}
