//
//  ViewController.swift
//  shareDocument
//
//  Created by Karthik on 21/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import UIKit
import QuickLook
import SafariServices
import WebKit

class TrackFileHandler: FileAccessible {
    var fileURL: URL
    
    init(trackURL: URL) {
        fileURL = trackURL
    }
}

class ViewController: UIViewController {
    
    var previewURL: URL?
    
    var fileObserver: DirectoryObserver?
    
    var isFileModified: Bool = false
    
    lazy var webView = WKWebView(frame: self.view.frame)
    
    let numbersButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        
        button.setTitle("View Numbers document", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(didTapNumbersButton(sender:)), for: .touchUpInside)
        
        button.isSelected = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    let playButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        
        button.setTitle("View Document", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(didTapPlayButton(sender:)), for: .touchUpInside)
        
        button.isSelected = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let hiddenButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        
        button.setTitle("View hidden Document", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(didTapHiddenButton(sender:)), for: .touchUpInside)
        
        button.isSelected = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let imageButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        
        button.setTitle("View image", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(didTapImageButton(sender:)), for: .touchUpInside)
        
        button.isSelected = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let textButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        
        button.setTitle("View text file", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(didTapTextButton(sender:)), for: .touchUpInside)
        
        button.isSelected = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    @objc
    func didTapNumbersButton(sender: UIButton) {
        viewNumbers()
    }
    
    @objc
    func didTapTextButton(sender: UIButton) {
        viewText()
    }
    
    @objc
    func didTapImageButton(sender: UIButton) {
        viewImage()
    }
    
    @objc
    func didTapPlayButton(sender: UIButton) {
        viewDoc()
    }
    
    @objc
    func didTapHiddenButton(sender: UIButton) {
        viewHiddenDoc()
    }
    
    func viewNumbers() {
        let url = Bundle.main.path(forResource: "numbers", ofType: "numbers")!
        let fileUrl = URL(fileURLWithPath: url)
        
        let fileHandler = TrackFileHandler(trackURL: fileUrl)
        self.previewURL = fileHandler.documentsPath.appendingPathComponent("numbers.numbers")
        
        presentPreviewController()
    }
    
    func viewText() {
        let url = Bundle.main.path(forResource: "1", ofType: "txt")!
        let fileUrl = URL(fileURLWithPath: url)
        
        let fileHandler = TrackFileHandler(trackURL: fileUrl)
        self.previewURL = fileHandler.documentsPath.appendingPathComponent("1.txt")
        
        presentPreviewController()
    }
    
    func viewImage() {
        let url = Bundle.main.path(forResource: "image", ofType: "png")!
        let fileUrl = URL(fileURLWithPath: url)
        
        let fileHandler = TrackFileHandler(trackURL: fileUrl)
        self.previewURL = fileHandler.documentsPath.appendingPathComponent("image.png")
        
        presentPreviewController()
    }
    
    func viewHiddenDoc() {
        let url = Bundle.main.path(forResource: "cv", ofType: "pdf")!
        let fileUrl = URL(fileURLWithPath: url)
        
        let fileHandler = TrackFileHandler(trackURL: fileUrl)
        self.previewURL = fileHandler.documentsPath.appendingPathComponent(".hidden.pdf")
        
        presentPreviewController()
    }
    
    func viewDoc() {
        let url = Bundle.main.path(forResource: "cv", ofType: "pdf")!
        let fileUrl = URL(fileURLWithPath: url)
        
        let fileHandler = TrackFileHandler(trackURL: fileUrl)
        self.previewURL = fileHandler.documentsPath.appendingPathComponent("xx.pdf")
        
        presentPreviewController()
    }
    
    func presentPreviewController() {
        let previewController = QLPreviewController()
        previewController.dataSource = self
        previewController.delegate = self
        
//        let safari = SFSafariViewController(url: self.previewURL!)
        
//        webView.loadFileURL(self.previewURL!, allowingReadAccessTo: previewURL!)
//        WKWebView.load()
//        let vc = UIViewController()
//        vc.view = webView
//
//        if let videoURL:URL = URL(string: "https://www.youtube.com/watch?v=R1rasAqv0Sg&list=PLStop6KRgf_4rUJl-NZD3U0m6kzC2v-Xz&index=2&t=0s") {
//            let request:URLRequest = URLRequest(url: videoURL)
//            webView.load(request)
//        }
        
        self.isFileModified = false
        self.present(previewController, animated: true) { [weak self] in
            self?.fileObserver = DirectoryObserver(withFilePath: self?.previewURL!.path ?? "test")
            self?.fileObserver?.onFileEvent = {
                print("kk file event updated")
                self?.isFileModified = true
            }
        }
        
//        let controller = UIDocumentInteractionController(url: self.previewURL)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupViews()
        
        copyNumbers()
        copyText()
        copyFile()
        addImage()
        hiddenFile()
        
    }
    
    func setupViews() {
        view.addSubview(playButton)
        view.addSubview(hiddenButton)
        view.addSubview(imageButton)
        view.addSubview(textButton)
        view.addSubview(numbersButton)
        
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        hiddenButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        hiddenButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        hiddenButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        hiddenButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        
        imageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        imageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        imageButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
        
        textButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        textButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        textButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        
        numbersButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        numbersButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        numbersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        numbersButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100).isActive = true
    }
    
    func copyNumbers() {
        let url = Bundle.main.path(forResource: "numbers", ofType: "numbers")!
        let fileUrl = URL(fileURLWithPath: url)
        
        let fileHandler = TrackFileHandler(trackURL: fileUrl)
        print("file exists \(fileHandler.fileExists()) at url \(fileUrl.path)")
        
        let destURL = fileHandler.documentsPath.appendingPathComponent("numbers.numbers")
        print("file exists destination \(fileHandler.fileExists(at: destURL)) at url \(destURL.path)")
        
        let destFileHandler = TrackFileHandler(trackURL: destURL)
        
        if !destFileHandler.fileExists() {
            destFileHandler.copyFileToDocumentsPath(sourcePath: fileUrl) {
            }
        }
    }
    
    func copyText() {
        let url = Bundle.main.path(forResource: "1", ofType: "txt")!
        let fileUrl = URL(fileURLWithPath: url)
        
        let fileHandler = TrackFileHandler(trackURL: fileUrl)
        print("file exists \(fileHandler.fileExists()) at url \(fileUrl.path)")
        
        let destURL = fileHandler.documentsPath.appendingPathComponent("1.txt")
        print("file exists destination \(fileHandler.fileExists(at: destURL)) at url \(destURL.path)")
        
        let destFileHandler = TrackFileHandler(trackURL: destURL)
        
        if !destFileHandler.fileExists() {
            destFileHandler.copyFileToDocumentsPath(sourcePath: fileUrl) {
            }
        }
    }
    
    
    func addImage() {
        let url = Bundle.main.path(forResource: "image", ofType: "png")!
        let fileUrl = URL(fileURLWithPath: url)
        
        let fileHandler = TrackFileHandler(trackURL: fileUrl)
        print("file exists \(fileHandler.fileExists()) at url \(fileUrl.path)")
        
        let destURL = fileHandler.documentsPath.appendingPathComponent("image.png")
        print("file exists destination \(fileHandler.fileExists(at: destURL)) at url \(destURL.path)")
        
        let destFileHandler = TrackFileHandler(trackURL: destURL)
        
        if !destFileHandler.fileExists() {
            destFileHandler.copyFileToDocumentsPath(sourcePath: fileUrl) {
            }
        }
    }
    
    func hiddenFile() {
        let url = Bundle.main.path(forResource: "cv", ofType: "pdf")!
        let fileUrl = URL(fileURLWithPath: url)
        
        let fileHandler = TrackFileHandler(trackURL: fileUrl)
        print("file exists \(fileHandler.fileExists()) at url \(fileUrl.path)")
        
        let destURL = fileHandler.documentsPath.appendingPathComponent(".hidden.pdf")
        print("file exists destination \(fileHandler.fileExists(at: destURL)) at url \(destURL.path)")
        
        let destFileHandler = TrackFileHandler(trackURL: destURL)
        
        if !destFileHandler.fileExists() {
            destFileHandler.copyFileToDocumentsPath(sourcePath: fileUrl) {
                        var resourceValues = URLResourceValues()
                        resourceValues.isHidden = true
                        resourceValues.isExcludedFromBackup = true
                        do {
                            try destFileHandler.fileURL.setResourceValues(resourceValues)
                        } catch {
                            print("error setting resource values \(error)")
                        }
            }
        }
        
        destFileHandler.printResourceValues()
        print("\(String(describing: destFileHandler.attribures()!))")
    }
    
    func copyFile() {
        let url = Bundle.main.path(forResource: "cv", ofType: "pdf")!
        let fileUrl = URL(fileURLWithPath: url)
        
        let fileHandler = TrackFileHandler(trackURL: fileUrl)
        print("file exists \(fileHandler.fileExists()) at url \(fileUrl.path)")
        
        let destURL = destinationURL()
        print("file exists destination \(fileHandler.fileExists(at: destURL)) at url \(destURL.path)")
        
        let destFileHandler = TrackFileHandler(trackURL: destURL)
        
        if !destFileHandler.fileExists() {
            destFileHandler.copyFileToDocumentsPath(sourcePath: fileUrl) {
                
            }
        }
    }
    
    func destinationURL() -> URL {
        let fileUrl = URL(fileURLWithPath: "url")
        let fileHandler = TrackFileHandler(trackURL: fileUrl)
        return fileHandler.documentsPath.appendingPathComponent("xx.pdf")
    }

}

extension ViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.previewURL! as QLPreviewItem
    }
}

extension ViewController: UIDocumentInteractionControllerDelegate {
    /// If presenting atop a navigation stack, provide the navigation controller in order to animate in a manner consistent with the rest of the platform
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
}

extension ViewController: QLPreviewControllerDelegate {
    func previewController(_ controller: QLPreviewController, editingModeFor previewItem: QLPreviewItem) -> QLPreviewItemEditingMode {
        return .updateContents
    }
    
    func previewController(_ controller: QLPreviewController, didSaveEditedCopyOf previewItem: QLPreviewItem, at modifiedContentsURL: URL) {
        print("kk saved")
    }
    
    func previewController(_ controller: QLPreviewController, didUpdateContentsOf previewItem: QLPreviewItem) {
        print("kk updated")
    }
    
    func previewControllerWillDismiss(_ controller: QLPreviewController) {
        print("kk will dismiss")
    }
    
    func previewControllerDidDismiss(_ controller: QLPreviewController) {
        print("kk did dismiss")
        
        if isFileModified {
            viewNumbers()
        }
    }
}


extension ViewController: NSFilePresenter {
    var presentedItemURL: URL? {
        return destinationURL()
    }
    
    var presentedItemOperationQueue: OperationQueue {
        return OperationQueue.main
    }
    
    func presentedSubitemDidChange(at url: URL) {
        print("item changed \(url)")
    }
}

