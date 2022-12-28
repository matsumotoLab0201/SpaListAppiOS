//
//  ViewController.swift
//  JsonListApp
//  Created by ko_matsumoto on 2022/12/14.
//

import UIKit
import SafariServices

class ViewController: UIViewController,UISearchBarDelegate, UITableViewDataSource,UITableViewDelegate,SFSafariViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //1 storyboardとの紐付け
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spaButton: UIButton!

    @IBAction func tapSpaButton(_ sender: Any) {
        showJsonList()
    }
    
    //0-1 温泉情報のlist
    var jsonList : [(name:String , link:URL , image:URL , subtitle:String)] = []

    //0 URLSessonによるjsonの取得
    func showJsonList(){

        guard let req_url = URL(string: "https://raw.githubusercontent.com/matumotokohei/TestJson3/master/json/sample.json") else {
            return
        }
        print(req_url)
        
        let req = URLRequest(url: req_url)

        let session = URLSession(configuration: .default, delegate: nil,delegateQueue: OperationQueue.main)
        
        //0-2 taskにて@GET行う
        
        let task = session.dataTask(with: req, completionHandler: {
            (data , response , error) in
            
            session.finishTasksAndInvalidate()

            do {
                // JSONDecoderのインスタンス取得
                let decoder = JSONDecoder()
                // 受け取ったJSONデータをパース（解析）して格納
                let json = try decoder.decode(ResultJson.self, from: data!)
                
                // print(json)
                
                // 温泉情報が取得できているか確認
                if let items = json.item {
                    // 温泉のリストを初期化
                    self.jsonList.removeAll()
                    // 取得している温泉の数だけ処理
                    for item in items {
                        // 温泉の名称、メーカー名、掲載URL、画像URLをアンラップ
                        if let name = item.name , let link = item.url , let image = item.image ,
                        let subtitle = item.subtitle {
                            // 1つの温泉をタプルでまとめて管理
                            let jsonAll = (name,link,image,subtitle)
                            // 温泉の配列へ追加
                            self.jsonList.append(jsonAll)
                        }
                    }
                    // Table Viewを更新する
                    self.tableView.reloadData()
                    
                    if let okashidbg = self.jsonList.first {
                        print ("----------------")
                        print ("okashiList[0] = \(okashidbg)")
                    }
                }
                
            } catch {
                // エラー処理
                print("エラーが出ました")
            }
        })
        
        //0-3 taskの実施(ダウンロード開始)
        task.resume()
    }
    
    //2-1 Cellの総数を返すdatasourceメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 温泉リストの総数
        return jsonList.count
    }
  
    //2-2 Cellに値を設定するdatasourceメソッド
    //lat Cellのセル名をstoryboadと一致させる必要がある
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 今回表示を行う、Cellオブジェクト（1行）を取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "spaCell", for:indexPath) as UITableViewCell
        cell.detailTextLabel?.numberOfLines=0
        
        
        // 温泉のタイトル設定
        cell.textLabel?.text = jsonList[indexPath.row].name
        cell.detailTextLabel?.text = jsonList[indexPath.row].subtitle
        // 温泉画像を取得
        if let imageData = try? Data(contentsOf: jsonList[indexPath.row].image) {
            // 正常に取得できた場合は、UIImageで画像オブジェクトを生成して、Cellに温泉画像を設定
            cell.imageView?.image = UIImage(data: imageData)
        }
        // 設定済みのCellオブジェクトを画面に反映
        return cell
        
    }
    
    //2-3 Cell選択時に呼ばれるdelegateメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // ハイライト解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        // SFSafariViewを開く
        let safariViewController  = SFSafariViewController(url: jsonList[indexPath.row].link)
        
        // delegateの通知先を自分自身
        safariViewController.delegate = self
        
        // SafariViewが開かれる
        present(safariViewController, animated: true, completion: nil)
        
    }
    
    //2-4 SafariViewを閉じる時のdelegate関数
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        // SafariViewを閉じる
        dismiss(animated: true, completion: nil)
    }
        
}
