//
//  ViewController.swift
//  Catstagram-Starter
//
//  Created by Luke Parham on 2/9/17.
//  Copyright © 2017 Luke Parham. All rights reserved.
//

import UIKit
import CoreMotion

class CatFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, URLSessionDelegate {
    private let kCatCellIdentifier = "CatCell"
    private let screensFromBottomToLoadMoreCats: CGFloat = 2.5
    
    private var photoFeed: PhotoFeedModel?
    private let tableView = UITableView(frame: CGRect.zero, style: .plain)
    private let activityIndicatorView = UIActivityIndicatorView(style: .gray)
    
    private let motionManager = CMMotionManager()
    
    private var lastY = 0.0
    
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.logs.Catstagram")
        configuration.isDiscretionary = true
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = "Catstagram"
        
        self.tableView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        self.tableView.delegate = self
        self.tableView.dataSource = self
//        
//        let timer = Timer(timeInterval: 5.0, target: self, selector: #selector(CatFeedViewController.sendLogs), userInfo: nil, repeats: true)
//        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoFeed = PhotoFeedModel(imageSize: imageSizeForScreenWidth())
        view.backgroundColor = UIColor.white
        
        refreshFeed()
        
        self.view.addSubview(tableView)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(CatPhotoTableViewCell.classForCoder(), forCellReuseIdentifier: kCatCellIdentifier)
        
        tableView.addSubview(activityIndicatorView)
        
        //Add this to reduce motion work
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: .main, withHandler:{ deviceMotion, error in
            guard let deviceMotion = deviceMotion else { return }
            guard abs(deviceMotion.rotationRate.y - self.lastY) > 0.1 else { return } //[NOTES]: Add this to stop unneccessary calculations
            
            let xRotationRate = CGFloat(deviceMotion.rotationRate.x)
            let yRotationRate = CGFloat(deviceMotion.rotationRate.y)
            let zRotationRate = CGFloat(deviceMotion.rotationRate.z)
            
            self.lastY = deviceMotion.rotationRate.y
            //            print("y \(yRotationRate) and x \(xRotationRate) and z\(zRotationRate)")
            
            if abs(yRotationRate) > (abs(xRotationRate) + abs(zRotationRate)) {
                for cell in self.tableView.visibleCells as! [CatPhotoTableViewCell] {
                    cell.panImage(with: yRotationRate)
                }
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = self.view.bounds
        activityIndicatorView.center = CGPoint(x: self.view.bounds.size.width/2.0, y: self.view.bounds.size.height/2.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func refreshFeed() {
        guard let photoFeed = photoFeed else { return }
        
        activityIndicatorView.startAnimating()
        photoFeed.refreshFeed(with: 4) { (photoModels) in
            self.activityIndicatorView.stopAnimating()
            self.insert(newRows: photoModels)
            self.requestComments(forPhotos: photoModels)
            self.loadPage()
        }
    }
    
    func loadPage() {
        guard let photoFeed = photoFeed else { return }
        
        photoFeed.requestPage(with: 20) { (photoModels) in
            self.insert(newRows: photoModels)
            self.requestComments(forPhotos: photoModels)
        }
    }
    
    func insert(newRows photoModels: [PhotoModel]) {
        guard let photoFeed = photoFeed else { return }
        
        var indexPaths = [IndexPath]()
        
        let newTotal = photoFeed.numberOfItemsInFeed()
        for i in (newTotal - photoModels.count)..<newTotal {
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        tableView.insertRows(at: indexPaths, with: .none)
    }
    
    func requestComments(forPhotos photoModels: [PhotoModel]) {
        guard let photoFeed = photoFeed else { return }
        /*
        for photoModel in photoModels {
            photoModel.commentFeed.refreshFeed(with: { (commentModels) in
                let rowNum = photoFeed.index(of: photoModel)
                let indexPath = IndexPath(row: rowNum, section: 0)
                if (tableView.cellForRow(at: indexPath) as? CatPhotoTableViewCell) != nil {
                    if let firstCell = tableView.visibleCells.first,
                        let visibleCellPath = tableView.indexPath(for: firstCell) {
                        if indexPath.row < visibleCellPath.row {
                            let width = view.bounds.size.width
                            let commentViewHeight = CommentView.height(forCommentFeed: photoModel.commentFeed, withWidth:width)
                            
                            tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: tableView.contentOffset.y + commentViewHeight)
                        }
                    }
                }
            })
        }
 */
    }
    
    //MARK: Table View Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCatCellIdentifier, for: indexPath) as! CatPhotoTableViewCell
        cell.layer.cornerRadius = 40.0
        cell.clipsToBounds = true
        
        //        print(cell)
        
        cell.updateCell(with: photoFeed?.object(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let photoModel = photoFeed?.object(at: indexPath.row) {
            return CatPhotoTableViewCell.height(forPhoto: photoModel, with: self.view.bounds.size.width)
        }
        return 0
    }
    
    //MARK: Table View DataSource
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoFeed?.numberOfItemsInFeed() ?? 0
    }
    
    //MARK: Scroll View Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let screensFromBottom = (scrollView.contentSize.height - scrollView.contentOffset.y)/UIScreen.main.bounds.size.height;
        
        if screensFromBottom < screensFromBottomToLoadMoreCats {
            self.loadPage()
        }
    }
    
    //MARK: Helpers
    func imageSizeForScreenWidth() -> CGSize {
        let screenRect = UIScreen.main.bounds
        let scale = UIScreen.main.scale
        
        return CGSize(width: screenRect.width * scale, height: screenRect.width * scale)
    }
    
    func resetAllData() {
        photoFeed?.clearFeed()
        tableView.reloadData()
        self.refreshFeed()
    }
}

extension CatFeedViewController {
    @objc func sendLogs() {
        let headers = [
            "cookie": "foo=bar; bar=baz",
            "accept": "application/json",
            "content-type": "application/x-www-form-urlencoded"
        ]
        
        var postData = "foo=bar".data(using: String.Encoding.utf8)!
        postData.append("&bar=baz".data(using: String.Encoding.utf8)!)
        
        var request = URLRequest(
            url: URL(string: "https://mockbin.org/bin/d7fc711e-dc00-4a53-93e2-870a35163685?foo=bar&foo=baz")!,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10)
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let uploadTask = session.dataTask(with: request)
        uploadTask.resume()
        //        let session = URLSession(configuration: config)
        //        let uploadTask = session.uploadTask(with: request, from: nil) { (data, response, error) in
        //            if let error = error {
        //                print(error)
        //            }
        //            if let response = response {
        //                print(response)
        //            }
        //        }
        //        uploadTask.resume()
    }
    
    func getFileURL(fileName: String) -> URL? {
        let manager = FileManager.default
        let dirURL = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        if let dirURL = dirURL {
            return dirURL.appendingPathComponent(fileName)
        }
        return nil
    }
}
