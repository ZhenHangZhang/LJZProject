//
//  LJZCustomTableViewCell.swift
//  LJZProject
//
//  Created by zhanghangzhen on 2016/12/2.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit

class LJZCustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var addressL: UILabel!

    @IBOutlet weak var priceL: UILabel!
    @IBAction func nav(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "nav"), object: mocel)
    }
    
    @IBAction func detail(_ sender: Any) {
    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "detail"), object: mocel)
    }
    var index : NSIndexPath?
    var mocel : LJZParkInfoModel?{
        didSet{
            if mocel?.address != nil {
                addressL.text = mocel?.address
            }
            if mocel?.name != nil {
                let str = NSString.localizedStringWithFormat("%d.%@", ((index?.row)! + 1),(mocel?.name)!)
                titleL.text = str as String
                if (mocel?.name?.contains("占道"))! {
                    addressL.text = mocel?.name
                }
            }
            if (mocel?.feePredict != nil) {
                priceL.text = "下一小时预测收费:" + "\(mocel?.feePredict)" + "元"
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
