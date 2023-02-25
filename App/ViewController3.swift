//
//  ViewController3.swift
//  test3d
//
//  Created by ito on 2021/12/16.
//
import SceneKit
import UIKit
import SCNLine

extension UIImage {
    public convenience init(url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}

var app:AppDelegate = UIApplication.shared.delegate as! AppDelegate

class ViewController3: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//txtファイル読み込み//
        var fileData:[[String]] = []

        //ファイルデータを突っ込む変数
        var csvString = ""
        
        let pathURL = NSURL(string: "http://157.80.72.24/jsons/path.txt")
        
        do {
        //ここでは文字コードをUTF8で指定
           csvString = try NSString(contentsOf: pathURL as! URL, encoding: String.Encoding.utf8.rawValue) as String
        } catch let error as NSError {
           print(error.localizedDescription)
        }
        //","区切りで配列に追加
        csvString.enumerateLines { (line, stop) -> () in
           fileData.append(line.components(separatedBy: ","))
        }

        
        //print(fileData[1][2])
        
        let w = 32.64
        let h = 24.48
        
//scene作成
        // SCNView を構築して UIViewController のビューに設定する
        let scnView = SCNView(frame: self.view.frame)
        scnView.backgroundColor = UIColor.gray// 背景を黒色に
        scnView.allowsCameraControl = true // ユーザーによる視点操作を可能に
        scnView.showsStatistics = true // 描画パフォーマンス情報を表示
        self.view = scnView

        // SCNScene を SCNView に設定する
        let scene = SCNScene()
        scnView.scene = scene

        // カメラをシーンに追加する
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 35)
        scene.rootNode.addChildNode(cameraNode)

        // 無指向性の光源をシーンに追加する
        let omniLight = SCNLight()
        omniLight.type = .omni
        let omniLightNode = SCNNode()
        omniLightNode.light = omniLight
        omniLightNode.position = SCNVector3(x: -100, y: 0, z: 100)
        scene.rootNode.addChildNode(omniLightNode)

        // あらゆる方向から照らす光源をシーンに追加する
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.color = UIColor.darkGray
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        scene.rootNode.addChildNode(ambientLightNode)
        
        let plane = SCNPlane(width: w, height: h)
 
        //テクスチャのマテリアルを生成
        let tex = SCNMaterial()
        let f1 = UIImage(url: "http://157.80.72.24/DetectImages/map1f.png")
        tex.isDoubleSided = true
        tex.diffuse.contents = f1

        plane.materials = [tex]
        
        let planeNode = SCNNode(geometry: plane)
    
        // 配置する場所を決める
        planeNode.position = SCNVector3(x: 0, y: 0, z: -6)
    
        // ノードをシーンに追加する
        scene.rootNode.addChildNode(planeNode)
        
        let plane2 = SCNPlane(width: w, height: h)

        //テクスチャのマテリアルを生成
        let tex2 = SCNMaterial()
        tex2.diffuse.contents = UIImage(url: "http://157.80.72.24/DetectImages/map2f.png")
        tex2.isDoubleSided = true
        
        plane2.materials = [tex2]
        
        let planeNode2 = SCNNode(geometry: plane2)

        // 配置する場所を決める
        planeNode2.position = SCNVector3(x: 0, y: 0, z: 0)

        // ノードをシーンに追加する
        scene.rootNode.addChildNode(planeNode2)
    
    
    
        let plane3 = SCNPlane(width: w, height: h)
        //テクスチャのマテリアルを生成
        let tex3 = SCNMaterial()
        tex3.diffuse.contents = UIImage(url: "http://157.80.72.24/DetectImages/map3f.png")
        tex3.isDoubleSided = true
        plane3.materials = [tex3]
     
        let planeNode3 = SCNNode(geometry: plane3)

        // 配置する場所を決める
        planeNode3.position = SCNVector3(x: 0, y: 0, z: 6)

        // ノードをシーンに追加する
        scene.rootNode.addChildNode(planeNode3)
        
        //現在位置の球
        let sphere = SCNSphere(radius: 0.2)
        let sphereNode = SCNNode(geometry: sphere)
        sphere.firstMaterial?.diffuse.contents  = UIColor.red
        sphereNode.position = SCNVector3(x: Float(fileData[0][0])!, y: Float(fileData[0][1])!, z: Float(fileData[0][2])!)
        scene.rootNode.addChildNode(sphereNode)
        let billboardConstraint = SCNBillboardConstraint()
        let plane4 = SCNPlane(width: 2.5, height: 1.0)
        let tex4 = SCNMaterial()
        tex4.diffuse.contents = UIImage(named:"here")
        tex4.isDoubleSided = true
        plane4.materials = [tex4]
        let planeNode4 = SCNNode(geometry: plane4)
        planeNode4.constraints = [billboardConstraint]
        // 配置する場所を決める
        planeNode4.position = SCNVector3(x: Float(fileData[0][0])!, y: Float(fileData[0][1])!, z: Float(fileData[0][2])!+1.0)
        // ノードをシーンに追加する
        scene.rootNode.addChildNode(planeNode4)
        let action1 = SCNAction.move(by: SCNVector3(0,0,0.5), duration: 0.75)
        let action2 = SCNAction.move(by: SCNVector3(0,0,-0.5), duration: 0.75)
        let action = SCNAction.sequence([action1, action2])
        let Loop = SCNAction.repeatForever(action)
        planeNode4.runAction(Loop)
        
        //目的地の球
        let sphere2 = SCNSphere(radius: 0.2)
        let sphereNode2 = SCNNode(geometry: sphere2)
        sphere2.firstMaterial?.diffuse.contents  = UIColor.cyan
        sphereNode2.position = SCNVector3(x: Float(fileData[fileData.count-1][0])!, y: Float(fileData[fileData.count-1][1])!, z: Float(fileData[fileData.count-1][2])!)
        scene.rootNode.addChildNode(sphereNode2)
        
        
        
        let cone = SCNCone(topRadius: 0, bottomRadius: 0.3, height: 0.6)

        let coneNode = SCNNode(geometry: cone)
        cone.firstMaterial?.diffuse.contents  = UIColor.cyan
        coneNode.position = SCNVector3(x: Float(fileData[fileData.count-1][0])!, y: Float(fileData[fileData.count-1][1])!, z: Float(fileData[fileData.count-1][2])!+0.5)
        coneNode.eulerAngles.x = -.pi / 2
        scene.rootNode.addChildNode(coneNode)
        coneNode.runAction(Loop)
        
        let str3 = "3F"
        let text3 = SCNText(string: str3, extrusionDepth: 0.2)
        text3.font = UIFont.systemFont(ofSize: 1.5)
        // テキストの色を設定する
        // SCNText には最大5つの要素があり、それぞれに SCNMaterial を指定できる
        let m1 = SCNMaterial()
        m1.diffuse.contents = UIColor.black // 前面に赤色
        // back material
        let m2 = SCNMaterial()
        m2.diffuse.contents = UIColor.black // 背面に緑色
        // extruded sides material
        let m3 = SCNMaterial()
        m3.diffuse.contents = UIColor.white // 側面に青色
        text3.materials = [m1, m2, m3]
        // テキストノードを用意する
        let textNode3 = SCNNode(geometry: text3)
        // テキストノードの中心を座標の基準にする
        let (min, max) = (textNode3.boundingBox)
        let textBoundsWidth = (max.x - min.x)
        let textBoundsheight = (max.y - min.y)
        textNode3.pivot = SCNMatrix4MakeTranslation(textBoundsWidth/2 + min.x, textBoundsheight/2 + min.y, 0)
        // テキストを配置する場所を決める nは距離
        let n:Float = 1.0
        textNode3.position = SCNVector3(x: -Float(w)/2-n, y: 0, z: 6.0)
        textNode3.constraints = [billboardConstraint]
        // テキストノードをシーンに追加する
        scene.rootNode.addChildNode(textNode3)
        
        let str2 = "2F"
        let text2 = SCNText(string: str2, extrusionDepth: 0.2)
        text2.font = UIFont.systemFont(ofSize: 1.5)
        // テキストの色を設定する
        text2.materials = [m1, m2, m3]
        // テキストノードを用意する
        let textNode2 = SCNNode(geometry: text2)

        textNode2.pivot = SCNMatrix4MakeTranslation(textBoundsWidth/2 + min.x, textBoundsheight/2 + min.y, 0)
        // テキストを配置する場所を決める
        textNode2.position = SCNVector3(x: -Float(w)/2-n, y: 0, z: 0)
        textNode2.constraints = [billboardConstraint]
        // テキストノードをシーンに追加する
        scene.rootNode.addChildNode(textNode2)
        
        let str = "1F"
        let text = SCNText(string: str, extrusionDepth: 0.2)
        text.font = UIFont.systemFont(ofSize: 1.5)
        // テキストの色を設定する
        text.materials = [m1, m2, m3]
        // テキストノードを用意する
        let textNode = SCNNode(geometry: text)

        textNode.pivot = SCNMatrix4MakeTranslation(textBoundsWidth/2 + min.x, textBoundsheight/2 + min.y, 0)
        // テキストを配置する場所を決める
        textNode.position = SCNVector3(x: -Float(w)/2-n, y: 0, z: -5.9)
        textNode.constraints = [billboardConstraint]
        // テキストノードをシーンに追加する
        scene.rootNode.addChildNode(textNode)
        
        
        
        
        
        // 経路生成
        let drawingNode = SCNLineNode(with: [],radius: 0.1,edges: 10,maxTurning: 10)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        material.isDoubleSided = true
        drawingNode.lineMaterials = [material]
        
        for i in 0..<fileData.count/3 {
            drawingNode.add(point: SCNVector3(Double(fileData[i][0])!,Double(fileData[i][1])!,Double(fileData[i][2])!))
        }

        scene.rootNode.addChildNode(drawingNode)
        
        
        // 経路生成
        let drawingNode2 = SCNLineNode(with: [],radius: 0.1,edges: 10,maxTurning: 10)
        
        drawingNode2.lineMaterials = [material]
        
        for i in fileData.count/3-1..<fileData.count*2/3 {
            drawingNode2.add(point: SCNVector3(Double(fileData[i][0])!,Double(fileData[i][1])!,Double(fileData[i][2])!))
        }

        scene.rootNode.addChildNode(drawingNode2)
        
        // 経路生成
        let drawingNode3 = SCNLineNode(with: [],radius: 0.1,edges: 10,maxTurning: 10)
        
        drawingNode3.lineMaterials = [material]
        
        for i in fileData.count*2/3-1..<fileData.count {
            drawingNode3.add(point: SCNVector3(Double(fileData[i][0])!,Double(fileData[i][1])!,Double(fileData[i][2])!))
        }

        scene.rootNode.addChildNode(drawingNode3)
        
        //log作成
        let dateFormatter = DateFormatter()
        // フォーマット設定
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        // ロケール設定（端末の暦設定に引きづられないようにする）
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        // タイムゾーン設定（端末設定によらず固定にしたい場合）
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let strDate = dateFormatter.string(from: Date())
        self.appendText(string: "3Dmap-view:"+strDate)


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
}


