//
//  ViewController.swift
//  trusona
//
//  Created by shinri ishikawa on 2018/11/20.
//  Copyright © 2018年 inet. All rights reserved.
//

import UIKit
import TrusonaSDK

class CommonTrusonaViewController: UIViewController {
    let trusona = Trusona(
        token: Configs.TRUSONA_TOKEN,
        secret: Configs.TRUSONA_SECRET)
}
