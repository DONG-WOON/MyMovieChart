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
    
    @IBOutlet weak var indicater: UIActivityIndicatorView!
    
    var mvo: MovieVO!
    
    override func viewDidLoad() {
        
        self.webView.navigationDelegate = self
        
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
//MARK: - WKNavigationDelegate 프로토콜 구현
extension DetailViewController: WKNavigationDelegate {
    // 웹뷰가 웹 페이지를 읽어올지 말지 결정 메소드
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        guard let url = navigationAction.request.url?.absoluteString else {
            return
        }
        if (url.starts(with: "https://")) {
            decisionHandler(.cancel)
        }
    }
    
    // 웹 뷰가 콘텐츠를 로드하기 시작할 때 호출되는 메소드 ! 아직 URL이 유효하지 않거나 온라인 상태일 때도 호출된다는 점에서 didCommit과 다르다.
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    
    // 웹 뷰카 콘텐츠를 받기 시작할 때 호출되는 메소드! 대표적으로 로딩상태 표시
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.indicater.startAnimating()
    }
    
    // 웹 뷰가 콘텐츠 로딩을 완전히 마쳤을 때 호출되는 메소드!
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.indicater.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.indicater.stopAnimating()
        self.alert("상세페이지를 읽어오지 못했습니다.") {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}
extension UIViewController {
    func alert(_ message: String, onClick: (() -> Void)? = nil) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "취소", style: .cancel) { (_) in onClick?()
        })
        DispatchQueue.main.async {
            self.present(controller, animated: false)
        }
    }
}
