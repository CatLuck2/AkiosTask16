//
//  ViewController.swift
//  AkiosTask15
//
//  Created by Nekokichi on 2020/08/22.
//  Copyright © 2020 Nekokichi. All rights reserved.
//
/*
 UserDefaultに保存
 いつ保存する？
 チェック項目を編集した時
 データを追加した時
 どのように保存する？
 タプルで保存
 */

import UIKit

//Codable用
struct CheckItem: Codable {
    var text: String
    var keyCheck: Bool
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var checkListTableView: UITableView!

    private let ud = UserDefaults.standard
    //チェックリスト
    private var checkList: [CheckItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        //UserDefaultからデータを取得
        if let codableData = ud.data(forKey: "checkList") {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try? jsonDecoder.decode([CheckItem].self, from: codableData)
            checkList = decodedData!
        }

        //checkListTableViewの設定
        checkListTableView.delegate = self
        checkListTableView.dataSource = self
        checkListTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customcell")
    }

    /* TableView */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //CustomCellを生成
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! CustomCell
        //CustomCell内のUIに値を入れる
        cell.configure(checkItem: checkList[indexPath.row])
        cell.accessoryType = .detailButton
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //チェック状態を反転させる
        checkList[indexPath.row].keyCheck.toggle()

        //UserDefaultに保存
        addCheckListToUD(checkListData: checkList)

        //checkListTableViewを更新
        checkListTableView.reloadRows(at: [indexPath], with: .automatic)
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "editItemSegue", sender: indexPath.row)
    }
    /* TableView */

    //UserDefaultにチェックリストを保存
    func addCheckListToUD(checkListData: [CheckItem]) {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        let encodedData = try? jsonEncoder.encode(checkList)
        ud.set(encodedData, forKey: "checkList")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editItemSegue" {
            let nvc = segue.destination as! UINavigationController
            let editCheckItemVC = nvc.topViewController as! EditCheckItem
            guard let indexpathrow = checkListTableView.indexPathForSelectedRow?.row else {
                return
            }
            editCheckItemVC.indexPathRow = indexpathrow
            editCheckItemVC.selectedCheckItem = checkList[indexpathrow]
        }
    }

    @IBAction private func unwindToVC(_ unwindSegue: UIStoryboardSegue) {
        //AddCheckItemで入力したデータを追加
        if unwindSegue.identifier == "addItemUnWind" {
            //チェック項目を追加
            let addCheckItemVC = unwindSegue.source as! AddCheckItem
            checkList.append(addCheckItemVC.checkItem)

            //UserDefaultに保存
            addCheckListToUD(checkListData: checkList)

            //checkListTableViewを更新
            checkListTableView.reloadData()
        }

        //EditCheckItemで編集したデータを更新
        if unwindSegue.identifier == "editItemUnWind" {
            let editCheckItemVC = unwindSegue.source as! EditCheckItem
            checkList[editCheckItemVC.indexPathRow] = editCheckItemVC.selectedCheckItem

            //UserDefaultに保存
            addCheckListToUD(checkListData: checkList)

            //checkListTableViewを更新
            checkListTableView.reloadData()
        }
    }

}
