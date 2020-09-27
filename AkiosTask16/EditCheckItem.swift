//
//  EditCheckItem.swift
//  AkiosTask16
//
//  Created by Nekokichi on 2020/08/24.
//  Copyright © 2020 Nekokichi. All rights reserved.
//

import UIKit

class EditCheckItem: UIViewController {

    @IBOutlet private weak var editItemTextField: UITextField!

    var indexPathRow: Int!
    var selectedCheckItem: CheckItem!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        editItemTextField.text = selectedCheckItem.text
    }

    @IBAction private func completeEditingCheckItem(_ sender: Any) {
        //入力したテキストを渡されたデータに代入
        guard let inputItemText = editItemTextField.text else {
            return
        }
        selectedCheckItem.text = inputItemText

        performSegue(withIdentifier: "editItemUnWind", sender: nil)
    }

}
