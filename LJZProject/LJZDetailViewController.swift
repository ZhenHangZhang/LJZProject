//
//  LJZDetailViewController.swift
//  LJZProject
//
//  Created by zhanghangzhen on 2016/12/9.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit

class LJZDetailViewController: UITableViewController{
    var model : LJZParkInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibcell = UINib.init(nibName: "LJZDetailTableViewCell", bundle: nil)
        tableView.register(nibcell, forCellReuseIdentifier: "reuseIdentifier")
        let nib = UINib.init(nibName: "LJZDetailHeaderView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! LJZDetailHeaderView
        DispatchQueue.global().async {
            // 子线程下载数据
            let urlStr = NSString.localizedStringWithFormat("https://pic.ezparking.com.cn/rtpi-service/parking?key=P01890EQ52678RTX&type=photo&id=%@&file=%@", (self.model?.id)!,(self.model?.photo)!)
            let url = URL(string:urlStr as String)
            let data: Data?
            do {
                data =  try? Data(contentsOf: url!)
            }catch {
                print("网络下载数据失败！")
            }
            let iamge = UIImage(data: data!)
            DispatchQueue.main.async(execute: {
                 v.imgV.image = iamge
            })
        }
        v.frame = CGRect(x: 0, y: 0, width: SCREEN_W , height: 180)
        tableView.tableHeaderView = v
        tableView.tableFooterView = UIView()
    }

   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as!LJZDetailTableViewCell
        ZHZDLog(model?.name)
        if indexPath.section == 0 {
            cell.titleL?.text = "停车场名称:"
            cell.subTieleL?.text = model?.name
        }else if indexPath.section == 1 {
            cell.titleL?.text = "标志性建筑物:"
            cell.subTieleL?.text = model?.address

        }else if indexPath.section == 2 {
            cell.titleL?.text = "车位数:"
          
        }else if indexPath.section == 3 {
            cell.titleL?.text = "主干道:"
            cell.subTieleL?.text = model?.mainRoad
        }else if indexPath.section == 4 {
            cell.titleL?.text = "支路近侧:"
            cell.subTieleL?.text = model?.nearSide
        }else if indexPath.section == 5 {
            cell.titleL?.text = "支路远侧:"
            cell.subTieleL?.text = model?.farSide
        }else if indexPath.section == 6 {
            cell.titleL?.text = "收费标准:"
            cell.subTieleL?.text = model?.feeText
        }
        return cell
    }
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
