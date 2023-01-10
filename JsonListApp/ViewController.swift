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
        
        
        //1. nibでCellのIdentifierを設定する
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        
    }
    
    //1 storyboardとの紐付け
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spaButton: UIButton!
    
    @IBAction func tapSpaButton(_ sender: Any) {
        showJsonList()
    }
    
    //0-1 温泉情報のlist
    var jsonList : [(name:String , station:String , cost1:String ,cost2 :String, walk: String, imageUrl: URL,url:URL)] = []
    
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
                        if let name = item.name ,
                           let station = item.station ,
                           let cost1 = item.cost1,
                           let cost2 = item.cost2 ,
                           let walk = item.walk,
                           let imageUrl = item.imageUrl,
                           let url = item.url
                        {
                            // 1つの温泉をタプルでまとめて管理
                            let jsonAll = (
                                name,station,cost1,cost2,walk,imageUrl,url
                            )
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for:indexPath) as! TableViewCell
        //旧式let cell = tableView.dequeueReusableCell(withIdentifier: "spaCell", for:indexPath) as UITableViewCell
        
        // 温泉のタイトル設定
        
        cell.Title.text = jsonList[indexPath.row].name
        cell.SubTitle.text = "\(jsonList[indexPath.row].station)駅　\(jsonList[indexPath.row].walk)分"
        cell.Cost.text =
        "平日\(jsonList[indexPath.row].cost1)円　土日祝: \(jsonList[indexPath.row].cost2)円"
        
        
        if let imageData = try? Data(contentsOf: jsonList[indexPath.row].imageUrl) {
            
            cell.ImageView?.image = UIImage(data: imageData)
        }
        return cell
        
        
    }
    
    //2-3 Cell選択時に呼ばれるdelegateメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // ハイライト解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        // SFSafariViewを開く
        let safariViewController  = SFSafariViewController(url: jsonList[indexPath.row].url)
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
