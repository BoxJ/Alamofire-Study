//
//  ViewController.swift
//  AlamofireDemo
//
//  Created by jingliang on 2019/8/16.
//  Copyright © 2019 FotoPlace. All rights reserved.
//

import UIKit
import Alamofire

struct BoxBackgroundManger {
    
    static let shared = BoxBackgroundManger()
    
    let manager: SessionManager = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.BoxJing.backgroundDownload")
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.sharedContainerIdentifier = "group.com.BoxJing.backgroundDownload"
        return SessionManager(configuration: configuration)
    }()
}

class ViewController: UIViewController {

    let urlStr = "https://www.apiopen.top/satinGodApi"
//    let urlStr = "http://3g.163.com/touch/reconstruct/article/list/BA10TA81wangning/10-2.html"
    let videoUrlStr = "http://cache.fotoplace.cc/181114/13404389/3832bf181a42f3b372156659dac6b731.mp4"
    
    var manager = SessionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        urlSessionTest()
        
//        downloadVideo()
        
//        downLoadWithMonitor()
        
//        alamofireRequest()
    }
    
    func urlSessionTest() {
        URLSession.shared.dataTask(with: URL(string: urlStr)!) { (data, response, error) in
            if error == nil {
                print("拿到数据：\n\(String(describing: response))")
            }
        }.resume()
    }
    func downloadVideo() {
//        var urlRequest=URLRequest.init(url: URL(string: videoUrlStr)!)
//        urlRequest.setValue("https://www.fotoplace.cc", forHTTPHeaderField: "Referer")
//        URLSession.shared.downloadTask(with: urlRequest) { (url, response, error) in
//            if error == nil {
//                print("拿到数据：\n\(String(describing: response))")
//                do {
//                    try FileManager.default.moveItem(at: url!, to: URL(fileURLWithPath: NSHomeDirectory().appending("/Documents/video.mp4")))
//                } catch {
//
//                }
//            }
//            }.resume()
        URLSession.shared.downloadTask(with: URL(string: videoUrlStr)!) { (url, response, error) in
            if error == nil {
                print("视频下载完成的地址：\n\(String(describing: url))")
                do {
                    try FileManager.default.moveItem(at: url!, to: URL(fileURLWithPath: NSHomeDirectory().appending("/Documents/video.mp4")))
                } catch {

                }
            }
        }.resume()
    }
    
    func downLoadWithMonitor() {
        let config=URLSessionConfiguration.background(withIdentifier: "boxJing")
        let urlSession = URLSession.init(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        urlSession.downloadTask(with: URL(string: videoUrlStr)!).resume()
    }
    
    func alamofireRequest() {
        Alamofire.request(urlStr)
            .response { (response) in
                print(response)
        }
//        Alamofire.request(urlStr, parameters: ["type":"1","page":"1"])
//            .response { (response) in
//                print(response)
//            }
//        SessionManager.default.adapter=BoxAdapter()
//        SessionManager.default.retrier=BoxRetrier()
//        SessionManager.default.request(urlStr)
//            .response { (response) in
//                debugPrint("response method called \(response.timeline)")
//            }
//            .validate { (request, response, data) -> Request.ValidationResult in
//                print("validate method called")
////                return .failure(NSError.init(domain: "BoxJing", code: 50500, userInfo: nil))
//                guard let _ = data else {
//                    return .failure(NSError.init(domain: "BoxJing", code: 50500, userInfo: nil))
//                }
//                if response.statusCode == 404 {
//                    return .failure(NSError.init(domain: "BoxJing", code: 50404, userInfo: nil))
//                }
//                return .success
//        }
        
        let boxResponseSerlizer = DataResponseSerializer<String>.init(serializeResponse: { (request, response, data, error) -> Result<String> in
            print("原始数据：\(String(describing: response))")
            return .success("一个阿狸")
        })
        SessionManager.default
            .request(urlStr, parameters: ["type":"1","page":"1"])
            .response(responseSerializer: boxResponseSerlizer) { (boxResponse) in
                print(boxResponse)
            }
    }
    
    func alamofireDownload() {
        
//        let configuration=URLSessionConfiguration.background(withIdentifier: "com.BoxJing.backgroundDownload")
//        manager = SessionManager(configuration: configuration)
        BoxBackgroundManger.shared.manager.download(videoUrlStr) { (url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
            let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(response.suggestedFilename ?? "video0818.mp4")
            return (fileUrl!,[.createIntermediateDirectories,.removePreviousFile])
            }
            .downloadProgress { (progress) in
                print("进度：\(progress)")
            }
            .response { (downloadResponse) in
                print("回调信息：\(downloadResponse)")
        }
//        manager.backgroundCompletionHandler = {
//            print("下载完成了！！！")
//        }
        
//        let configuration=URLSessionConfiguration.background(withIdentifier: "com.BoxJing.backgroundDownload")
//        manager = SessionManager(configuration: configuration)
//        manager.download(videoUrlStr) { (url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
//            let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(response.suggestedFilename ?? "video0818.mp4")
//            return (fileUrl!,[.createIntermediateDirectories,.removePreviousFile])
//            }
//            .downloadProgress { (progress) in
//                print("进度：\(progress)")
//            }
//            .response { (downloadResponse) in
//                print("回调信息：\(downloadResponse)")
//        }
//        manager.backgroundCompletionHandler = {
//            print("下载完成了！！！")
//            DispatchQueue.main.async {
//                guard let appDele = UIApplication.shared.delegate as? AppDelegate, let backgroundHandle=appDele.backgroundSessionCompletionHandler else {return}
//                backgroundHandle()
//            }
//        }
        
        
//        SessionManager.default.download(videoUrlStr) { (url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
//            let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(response.suggestedFilename ?? "video0818.mp4")
//            return (fileUrl!,[.createIntermediateDirectories,.removePreviousFile])
//            }
//            .downloadProgress { (progress) in
//                print("进度：\(progress)")
//            }
//            .response { (downloadResponse) in
//                print("回调信息：\(downloadResponse)")
//        }
    }
    
    func alamofireUpload() {
        
        let dataInstep = self.readDataFromBundle(fileNameStr: "instep", type: "png")
        let dataRewarded = self.readDataFromBundle(fileNameStr: "rewarded", type: "png")
        
        SessionManager.default
            .upload(multipartFormData: { (mutilPartData) in
                mutilPartData.append("BoxJing".data(using: .utf8)!, withName: "name")
                mutilPartData.append("boy".data(using: .utf8)!, withName: "gender")
                mutilPartData.append("2016-08-25".data(using: .utf8)!, withName: "birthday")
//                mutilPartData.append(dataInstep as! Data, withName: "instepFileName")
//                mutilPartData.append(dataRewarded as! Data, withName: "rewardedFileName")
            }, to: "http://www.fotoplace.cc") { (result) in
                print(result)
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let upload,_,_):
                    upload.response(completionHandler: { (response) in
                        print("结果:\(response)")
                    })
                }
        }
    }
    
    fileprivate func readDataFromBundle(fileNameStr:String,type:String) -> Any? {
        let path = Bundle.main.path(forResource: fileNameStr, ofType: type);
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            return data;
        } catch let error as Error? {
            print(error?.localizedDescription ?? "")
            return nil;
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        alamofireDownload()
//        alamofireRequest()
        alamofireUpload()
    }
}
extension ViewController:URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        try! FileManager.default.moveItem(at: location, to: URL(fileURLWithPath: NSHomeDirectory().appending("/Documents/video.mp4")))
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("=====> \(Double(totalBytesWritten)/Double(totalBytesExpectedToWrite))\n")
    }
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            guard let appDele = UIApplication.shared.delegate as? AppDelegate, let backgroundHandle=appDele.backgroundSessionCompletionHandler else {return}
            backgroundHandle()
        }
    }
}
class BoxAdapter:RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        debugPrint("走进了adapt方法：\(urlRequest)")
        var boxRequest = urlRequest
        boxRequest.setValue("BoxJing", forHTTPHeaderField: "BoxSign")
        return boxRequest
    }
}
class BoxRetrier:RequestRetrier {
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        debugPrint("Retrier should method")
        completion(true,1.0) //1秒后重试
    }
}

