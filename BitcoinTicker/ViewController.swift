//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbols = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loadingAnimator: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        hideLoadingViews()
        //loadingAnimator.stopAnimating()
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        getBitcoinData(url: finalURL, position: row)
    }
//    
//    //MARK: - Networking
//    /***************************************************************/
    
    func getBitcoinData(url: String, position: Int) {
        showLoadingViews()
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    self.hideLoadingViews()
                   // self.loadingAnimator.stopAnimating()
                    let bitcoinJSON : JSON = JSON(response.result.value!)
                    self.updateBitcoinJSON(json: bitcoinJSON, position: position)

                } else {
                    self.hideLoadingViews()
            //        self.loadingAnimator.stopAnimating()
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "⚠️"
                }
            }

    }

    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitcoinJSON(json : JSON, position : Int) {
        
        if let priceResult = json["ask"].double {
            bitcoinPriceLabel.text = "\(currencySymbols[position]) \(priceResult)"
        } else {
            bitcoinPriceLabel.text = "N/A"
        }
    }
    
    func hideLoadingViews() {
        self.loadingLabel.isHidden = true
        self.loadingAnimator.stopAnimating()
    }
    
    func showLoadingViews() {
        self.bitcoinPriceLabel.text = "Price"
        self.loadingLabel.isHidden = false
        self.loadingAnimator.startAnimating()
    }
}

