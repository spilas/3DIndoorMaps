//
//  ViewController6.swift
//  test3d
//
//  Created by ito on 2022/01/10.
//

import UIKit

var number:String = "2"
var count:Int = 0


class ViewController6: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    struct GlobalVariable{
        static var FloorNumber = String()
    }
    
    @IBOutlet weak var showMenuButton: UIButton!

    @IBOutlet weak var Map3D: UIButton!
    @IBOutlet weak var DestinationMenuButton: UIButton!
    @IBOutlet weak var savePicture: UIButton!
    @IBOutlet weak var showAlbum: UIButton!
    @IBOutlet weak var HomeButton: UIButton!
    
    
    @IBOutlet var cameraView : UIImageView!
    @IBOutlet var label : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showMenuButton.setImage(UIImage(systemName: "camera"), for: .normal)

        DestinationMenuButton.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal)
        showAlbum.setImage(UIImage(systemName: "photo"), for: .normal)
        savePicture.setImage(UIImage(systemName: "tray.and.arrow.down.fill"), for: .normal)
        
        showMenuButton.layer.cornerRadius = 30.0
        DestinationMenuButton.layer.cornerRadius = 30.0

        Map3D.layer.cornerRadius = 30.0
        savePicture.layer.cornerRadius = 30.0
        showAlbum.layer.cornerRadius = 30.0
        HomeButton.layer.cornerRadius = 20.0
        
        label.text = "[カメラ]ボタンを押してフロアマップを撮影してください"
        
        let dateFormatter = DateFormatter()
        // フォーマット設定
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        // ロケール設定（端末の暦設定に引きづられないようにする）
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        // タイムゾーン設定（端末設定によらず固定にしたい場合）
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
//Cameraのメニュー
        let items = UIMenu(title: "More", options: .displayInline, children: [
            UIAction(title: "1F", image: UIImage(systemName: "square.3.stack.3d.bottom.filled"), handler: { _ in
                print("1F")
                number = "1"
                
                //log作成
                let strDate = dateFormatter.string(from: Date())
                self.appendText(string: "============================")
                self.appendText(string: "Camera-1F:"+strDate)
                
                let sourceType:UIImagePickerController.SourceType =
                    UIImagePickerController.SourceType.camera
                // カメラが利用可能かチェック
                if UIImagePickerController.isSourceTypeAvailable(
                    UIImagePickerController.SourceType.camera){
                    // インスタンスの作成
                    let cameraPicker = UIImagePickerController()
                    cameraPicker.sourceType = sourceType
                    cameraPicker.delegate = self
                    self.present(cameraPicker, animated: true, completion: nil)
                    
                }
                else{
                    self.label.text = "error"
                    
                }
            }),
            UIAction(title: "2F", image: UIImage(systemName: "square.3.stack.3d.middle.filled"), handler: { _ in
                print("2F")
                number = "2"
                //log作成
                let strDate = dateFormatter.string(from: Date())
                self.appendText(string: "Camera-2F:"+strDate)
                
                let sourceType:UIImagePickerController.SourceType =
                    UIImagePickerController.SourceType.camera
                // カメラが利用可能かチェック
                if UIImagePickerController.isSourceTypeAvailable(
                    UIImagePickerController.SourceType.camera){
                    // インスタンスの作成
                    let cameraPicker = UIImagePickerController()
                    cameraPicker.sourceType = sourceType
                    cameraPicker.delegate = self
                    self.present(cameraPicker, animated: true, completion: nil)
                    
                }
                else{
                    self.label.text = "error"
                    
                }
            }),
            UIAction(title: "3F", image: UIImage(systemName: "square.3.stack.3d.top.filled"), handler: { _ in
                print("3F")
                number = "3"
                
                //log作成
                let strDate = dateFormatter.string(from: Date())
                self.appendText(string: "Camera-3F:"+strDate)
                
                let sourceType:UIImagePickerController.SourceType =
                    UIImagePickerController.SourceType.camera
                // カメラが利用可能かチェック
                if UIImagePickerController.isSourceTypeAvailable(
                    UIImagePickerController.SourceType.camera){
                    // インスタンスの作成
                    let cameraPicker = UIImagePickerController()
                    cameraPicker.sourceType = sourceType
                    cameraPicker.delegate = self
                    self.present(cameraPicker, animated: true, completion: nil)
                    
                }
                else{
                    self.label.text = "error"
                    
                }
            })
        ])
        showMenuButton.showsMenuAsPrimaryAction = true
        //itemの追加
        showMenuButton.menu = UIMenu(title: "", children: [items])
        
//目的地入力のメニュー
        let items2 = UIMenu(title: "More", options: .displayInline, children: [
            UIAction(title: "1F", image: UIImage(systemName: "square.3.stack.3d.bottom.filled"), handler: { _ in
                print("1F")
                //log作成
                let strDate = dateFormatter.string(from: Date())
                self.appendText(string: "Destination-1F:"+strDate)
                ViewController6.GlobalVariable.FloorNumber = "1"
                let ViewController5 = self.storyboard?.instantiateViewController(withIdentifier: "ViewController5") as! ViewController5
                ViewController5.modalPresentationStyle = .fullScreen

                self.present(ViewController5, animated: true, completion: nil)
                
            }),
            UIAction(title: "2F", image: UIImage(systemName: "square.3.stack.3d.middle.filled"), handler: { _ in
                print("2F")
                //log作成
                let strDate = dateFormatter.string(from: Date())
                self.appendText(string: "Destination-2F:"+strDate)
                ViewController6.GlobalVariable.FloorNumber = "2"
                let ViewController5 = self.storyboard?.instantiateViewController(withIdentifier: "ViewController5") as! ViewController5
                ViewController5.modalPresentationStyle = .fullScreen
                self.present(ViewController5, animated: true, completion: nil)
                
            }),
            UIAction(title: "3F", image: UIImage(systemName: "square.3.stack.3d.top.filled"), handler: { _ in
                print("3F")
                //log作成
                let strDate = dateFormatter.string(from: Date())
                self.appendText(string: "Destination-3F:"+strDate)
                ViewController6.GlobalVariable.FloorNumber = "3"
                let ViewController5 = self.storyboard?.instantiateViewController(withIdentifier: "ViewController5") as! ViewController5
                ViewController5.modalPresentationStyle = .fullScreen
                self.present(ViewController5, animated: true, completion: nil)
                
            })
        ])
        DestinationMenuButton.showsMenuAsPrimaryAction = true
        //itemの追加
        DestinationMenuButton.menu = UIMenu(title: "", children: [items2])
        
    }
    @IBAction func menuButtonPushed(_ sender: Any) {}
    
    @IBAction func Map3D(_ sender: Any) {
        //log作成
        let dateFormatter = DateFormatter()
        // フォーマット設定
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        // ロケール設定（端末の暦設定に引きづられないようにする）
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        // タイムゾーン設定（端末設定によらず固定にしたい場合）
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let strDate = dateFormatter.string(from: Date())
        self.appendText(string: "3Dmap:"+strDate)
    }
    func addfile() {
        var documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var filename:String
        switch number{
        case "1":
            filename = "map1.png"
        case "2":
            filename = "map2.png"
        case "3":
            filename = "map3.png"
        default:
            filename = "test.png"
        }
        
        let path = documentDirectoryFileURL.appendingPathComponent(filename)
        documentDirectoryFileURL = path
        let inimage:UIImage! = cameraView.image
        
        let imageData: Data = inimage!.pngData()!
        
        do {
            try imageData.write(to: documentDirectoryFileURL)
            print("成功した")
        } catch {
            print("失敗した")
        }
    }
    
    //log書き込み関数
    func writingToFile(text: String) {
        guard let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("フォルダURL取得エラー")
        }
        let fileURL = dirURL.appendingPathComponent("log.txt")
        do {
            try text.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("failed to write: \(error)")
        }
    }
    
    func appendText(string: String) {
        guard let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("フォルダURL取得エラー")
        }
        let fileURL = dirURL.appendingPathComponent("log.txt")
        do {
            let fileHandle = try FileHandle(forWritingTo: fileURL)
            let stringToWrite = "\n" + string
            fileHandle.seekToEndOfFile()
            fileHandle.write(stringToWrite.data(using: String.Encoding.utf8)!)
            
        } catch let error as NSError {
            print("Error: \(error)")
        }
    }
    
    
    //　撮影が完了時した時に呼ばれる
    func imagePickerController(_ imagePicker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        if let pickedImage = info[.originalImage]
            as? UIImage {
            
            cameraView.contentMode = .scaleAspectFit
            cameraView.image = pickedImage

            
        }
        addfile()
        //閉じる処理
        imagePicker.dismiss(animated: true, completion: nil)
        if number=="3" {
            self.uploadToServer()
            self.label.text = "[目的地]ボタンを押して目的地を設定してください"
        }
        else{
            self.uploadToServer2()
            self.label.text = "[カメラ]ボタンを押して次のフロアマップを撮影してください"
        }
        
    }
    
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        label.text = "Canceled"
    }
    
    
    
    
    // 写真を保存
    @IBAction func savePicture(_ sender : Any) {
        let image:UIImage! = cameraView.image
        
        if image != nil {
            UIImageWriteToSavedPhotosAlbum(
                image,
                self,
                #selector(ViewController6.image(_:didFinishSavingWithError:contextInfo:)),
                nil)
        }
        else{
            label.text = "image Failed !"
        }
        
    }
    
    // 書き込み完了結果の受け取り
    @objc func image(_ image: UIImage,
                     didFinishSavingWithError error: NSError!,
                     contextInfo: UnsafeMutableRawPointer) {
        
        if error != nil {
            print(error.code)
            label.text = "Save Failed !"
        }
        else{
            label.text = "Save Succeeded"
        }
    }
    
    
    
    func uploadToServer() {
        let inimage:UIImage! = cameraView.image
        let imageData: Data = inimage!.pngData()!
        let imageStr: String = imageData.base64EncodedString()
 
        let alert = UIAlertController(title: "Loading", message: "Please wait...", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
 
        let urlString: String = "imageStr=" + imageStr + "&number=" + number 
    
        var request: URLRequest = URLRequest(url: URL(string: "http://157.80.72.24/upload.php")!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = urlString.data(using: .utf8)
 
        NSURLConnection.sendAsynchronousRequest(request, queue: .main, completionHandler: { (request, data, error) in
 
            guard let data = data else {
                return
            }
 
            let responseString: String = String(data: data, encoding: .utf8)!
            print("my_log = " + responseString)
 
            alert.dismiss(animated: true, completion: {
                //log作成
                let dateFormatter = DateFormatter()
                // フォーマット設定
                dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                // ロケール設定（端末の暦設定に引きづられないようにする）
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                // タイムゾーン設定（端末設定によらず固定にしたい場合）
                dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
                let strDate = dateFormatter.string(from: Date())
                self.appendText(string: "segmenFin:"+strDate)
                let messageAlert = UIAlertController(title: "Success", message: responseString, preferredStyle: .alert)
                messageAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    
                }))
 
                self.present(messageAlert, animated: true, completion: nil)
            })
        })
        
    }
    func uploadToServer2() {
        let inimage:UIImage! = cameraView.image
        let imageData: Data = inimage!.pngData()!
        let imageStr: String = imageData.base64EncodedString()
 
    //    let alert = UIAlertController(title: "Loading", message: "Please wait...", preferredStyle: .alert)
    //    present(alert, animated: true, completion: nil)
 
        let urlString: String = "imageStr=" + imageStr + "&number=" + number
    
        var request: URLRequest = URLRequest(url: URL(string: "http://157.80.72.24/upload.php")!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = urlString.data(using: .utf8)
 
        NSURLConnection.sendAsynchronousRequest(request, queue: .main, completionHandler: { (request, data, error) in
 
            guard let data = data else {
                return
            }
 
            let responseString: String = String(data: data, encoding: .utf8)!
            print("my_log = " + responseString)
 
       /*     alert.dismiss(animated: true, completion: {
 
                let messageAlert = UIAlertController(title: "Success", message: responseString, preferredStyle: .alert)
                messageAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    //
                }))
 
                self.present(messageAlert, animated: true, completion: nil)
            }) */
        })
        
    }
   
    // アルバムを表示
    @IBAction func showAlbum(_ sender : Any) {
        let sourceType:UIImagePickerController.SourceType =
            UIImagePickerController.SourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
            label.text = "Tap the [カメラ] to save a picture"

        }
        else{
            label.text = "error"
            
        }
        
    }
  
    
}

