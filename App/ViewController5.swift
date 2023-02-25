//
//  ViewController5.swift
//  test3d
//
//  Created by ito on 2022/01/05.
//

import UIKit


//表示されている画像のタップ座標用変数
var tapPoint = CGPoint(x: 0, y: 0)


class ViewController5: UIViewController {
    var myImageView = UIImageView()
    let image = ConvertModel.getUIImageFromDocumentsDirectory(name: "map"+ViewController6.GlobalVariable.FloorNumber)
    
    //let image = UIImage(url: "http://157.80.72.24/images/map"+ViewController6.GlobalVariable.FloorNumber+".png")
    //元の画像のタップ座標用変数
    var originalTapPoint = CGPoint(x: 0, y: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myImageView.frame.size = self.view.frame.size
        myImageView.image = image
        

        // 画像の縦横サイズ比率を変えずに制約に合わせる
        myImageView.contentMode = UIView.ContentMode.scaleAspectFit
        let a = UIImageView(image: image)

        let imageSize: CGSize
        //UIImageの向きによって縦横を変える
        switch image.imageOrientation.rawValue {
            //imageOrientationが3のとき（右に90°回転している）
        case 3:
            imageSize = CGSize(width: image.size.height, height: image.size.width)
        default:
            imageSize = CGSize(width: image.size.width, height: image.size.height)
           }

        //UIImageViewのサイズを表示されている画像のサイズに合わせる
        if imageSize.width > imageSize.height {
            myImageView.frame.size.height = imageSize.height/imageSize.width * myImageView.frame.width
        }else{
            myImageView.frame.size.width = imageSize.width/imageSize.height * myImageView.frame.height
        }

        //表示位置を真ん中にする
        myImageView.center = self.view.center

        //画像のタップイベント有効化
        myImageView.isUserInteractionEnabled = true
        myImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapAction(sender:))))
        
        
        self.view.addSubview(myImageView)
    }


    //画像のどこの座標をタップしたかを取得する関数
    @objc func tapAction(sender:UITapGestureRecognizer){

        tapPoint = sender.location(in: myImageView)
        
        let dateFormatter = DateFormatter()
        // フォーマット設定
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        // ロケール設定（端末の暦設定に引きづられないようにする）
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        // タイムゾーン設定（端末設定によらず固定にしたい場合）
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        
        let drawView = DrawView(frame: self.view.bounds)
        self.view.addSubview(drawView)
        
        //向きによって元の画像のタップ座標を変える(右に90°回転している場合)
        switch image.imageOrientation.rawValue {
        case 3:
            originalTapPoint.x = image.size.height/myImageView.frame.height * tapPoint.y
            originalTapPoint.y = image.size.width - (image.size.width/myImageView.frame.width * tapPoint.x)

        default:
            originalTapPoint.x = image.size.width/myImageView.frame.width * tapPoint.x
            originalTapPoint.y = image.size.height/myImageView.frame.height * tapPoint.y
        }
        
        /*
        let alert: UIAlertController = UIAlertController(title: "アラート表示", message: "目的地はここで良いですか？", preferredStyle:  UIAlertController.Style.alert)

        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            let strDate = dateFormatter.string(from: Date())
            self.appendText(string: "TapSaccess:"+strDate)
            self.uploadToServer()
        
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.destructive, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            let ViewController5 = self.storyboard?.instantiateViewController(withIdentifier: "ViewController5") as! ViewController5
            ViewController5.modalPresentationStyle = .fullScreen
            self.present(ViewController5, animated: false, completion: nil)
            print("Cancel")
        })
        let backAction: UIAlertAction = UIAlertAction(title: "ホームに戻る", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            let ViewController6 = self.storyboard?.instantiateViewController(withIdentifier: "ViewController6") as! ViewController6
            ViewController6.modalPresentationStyle = .fullScreen

            self.present(ViewController6, animated: true, completion: nil)
            print("back")
        })

        // ③ UIAlertControllerにActionを追加
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        alert.addAction(backAction)
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
        print(round(originalTapPoint.x))
        print(round(originalTapPoint.y))
         */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    
    func uploadToServer() {
 
        let alert = UIAlertController(title: "Loading", message: "Please wait...", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        
        let urlString: String = "number=" + ViewController6.GlobalVariable.FloorNumber + "&tap_x=" + "\(round(self.originalTapPoint.x))" + "&tap_y=" + "\(round(self.originalTapPoint.y))"
        print("urlString = " + urlString)
        var request: URLRequest = URLRequest(url: URL(string: "http://157.80.72.24/MakePath.php")!)
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
                self.appendText(string: "MakePathFin:"+strDate)
                let messageAlert = UIAlertController(title: "Success", message: responseString, preferredStyle: .alert)
                messageAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    let ViewController6 = self.storyboard?.instantiateViewController(withIdentifier: "ViewController6") as! ViewController6
                    ViewController6.modalPresentationStyle = .fullScreen
                    self.present(ViewController6, animated: true, completion: nil)
                }))
 
                self.present(messageAlert, animated: true, completion: nil)
            })
        })
        
    }
    
}


class DrawView: UIView {
 
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.clear;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        // ここにUIBezierPathを記述する
        let circle = UIBezierPath(arcCenter: CGPoint(x: tapPoint.x, y: tapPoint.y), radius: 10, startAngle: 0, endAngle: CGFloat(Double.pi)*2, clockwise: true)
        // 内側の色
        UIColor(red: 0, green: 0, blue: 1, alpha: 0.3).setFill()
        // 内側を塗りつぶす
        circle.fill()
        // 線の色
        UIColor(red: 0, green: 0, blue: 1, alpha: 1.0).setStroke()
        // 線の太さ
        circle.lineWidth = 2.0
        // 線を塗りつぶす
        circle.stroke()
    }
 
}


class ConvertModel: NSObject {
    // DocumentsDirectoryからUIImageを取得
    public static func getUIImageFromDocumentsDirectory(name: String) -> UIImage {
        let dirPath = getdocumentsDirectory().appendingPathComponent(name)
        let image = UIImage(contentsOfFile: dirPath.path)
        if (image == nil) {
            return UIImage(systemName: "mappin.and.ellipse")!
        }
        return image!
    }
 
    // ファイルを保存するディレクトリのURLを取得
    private static func getdocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
