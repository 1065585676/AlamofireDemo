//
//  AlamofireRequestViewController.swift
//  HttpGetPost
//
//  Created by wangyuanyuan on 19/10/2016.
//  Copyright © 2016 wangyuanyuan. All rights reserved.
//

import UIKit

import Alamofire

class AlamofireRequestViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var urlText: UITextField!
    @IBOutlet weak var requestMethodPicker: UIPickerView!
    @IBOutlet weak var responseHandlePicker: UIPickerView!
    @IBOutlet weak var parameterKeyText: UITextField!
    @IBOutlet weak var parameterValueText: UITextField!
    @IBOutlet weak var parametersTableView: UITableView!
    @IBOutlet weak var responseMsgTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let requestMethodArray = [
        "get","post"
    ]
    let responseHandleArray = [
        "Original","Data","JSON","String","PropertyList"
    ]
    
    var parametersKeyArray: [String] = []
    var parametersValueArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        urlText.delegate = self
        parameterKeyText.delegate = self
        parameterValueText.delegate = self
        
        requestMethodPicker.dataSource = self
        requestMethodPicker.delegate = self
        responseHandlePicker.dataSource = self
        responseHandlePicker.delegate = self
        
        parametersTableView.dataSource = self
        parametersTableView.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.OKTapped(textField)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        if textField.textColor != UIColor.black {
        //            textField.text = ""
        //            textField.textColor = UIColor.black
        //        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        //        if (textField.text?.isEmpty)! {
        //            switch textField.restorationIdentifier! {
        //            case "UrlResID":
        //                textField.text = "https://httpbin.org/get"
        //            case "KeyResID":
        //                textField.text = "Key"
        //            case "ValueResID":
        //                textField.text = "Value"
        //            default:
        //                textField.text = "!ERROR DATA!"
        //            }
        //            textField.textColor = UIColor.lightGray
        //        }
    }
    
    // MARK: Start Request
    @IBAction func OKTapped(_ sender: AnyObject) {
        
        ResignAllTextFieldFirstResponder(forView: self.view)
        
        guard urlText.text != nil else {
            MyAlertWindow(msg: "Something Wrong:URL TextField is nill!")
            return
        }
        
        self.responseMsgTextView.text = ""
        activityIndicator.startAnimating()
        
        let requestUrl = urlText.text!
        if !requestUrl.isEmpty {
            let requestMethod = requestMethodArray[requestMethodPicker.selectedRow(inComponent: 0)]
            let responseType = responseHandleArray[responseHandlePicker.selectedRow(inComponent: 0)]
            
            var parameters: [String: String] = [:]
            for i in 0 ..< parametersKeyArray.count {
                parameters[parametersKeyArray[i]] = parametersValueArray[i]
            }
            
            switch (requestMethod, responseType) {
            case ("get", "Original"):
                Alamofire.request(requestUrl, method: .get, parameters: parameters).response(queue: nil, completionHandler: { (defaultDataResponse) in
                    print("Get Original Response Finished:")
                    self.responseMsgTextView.text = "Request: \(defaultDataResponse.request)" + "\n"
                    self.responseMsgTextView.text = self.responseMsgTextView.text + "Response: \(defaultDataResponse.response)" + "\n"
                    self.responseMsgTextView.text = self.responseMsgTextView.text + "Error: \(defaultDataResponse.error)" + "\n"
                    if let data = defaultDataResponse.data, let utf8Text = String(data: data, encoding: .utf8) {
                        self.responseMsgTextView.text = self.responseMsgTextView.text + "Data: \(utf8Text)" + "\n"
                    }
                    self.activityIndicator.stopAnimating()
                })
            case ("get", "Data"):
                Alamofire.request(requestUrl, method: .get, parameters: parameters).responseData(queue: nil, completionHandler: { (dataResponseData) in
                    print("Get Data Response Finished:")
                    self.responseMsgTextView.text = "Request: \(dataResponseData.request)" + "\n"
                    self.responseMsgTextView.text = self.responseMsgTextView.text + "Response: \(dataResponseData.response)" + "\n"
                    self.responseMsgTextView.text = self.responseMsgTextView.text+"Error: \(dataResponseData.result.error)" + "\n"
                    
                    if let data = dataResponseData.data, let utf8Text = String(data: data, encoding: .utf8) {
                        self.responseMsgTextView.text = self.responseMsgTextView.text + "Data: \(utf8Text)" + "\n"
                    }
                    
//                    switch dataResponseData.result {
//                    case .success(let value):
//                        print("Success")
//                    case .failure(let error):
//                        print("Failed")
//                    }
                    self.activityIndicator.stopAnimating()
                })
            case ("get", "JSON"):
                Alamofire.request(requestUrl, method: .get, parameters: parameters).responseJSON(queue: nil, completionHandler: { (dataResponseAny) in
                    print("Get JSON Response Finished:")
                    self.responseMsgTextView.text = "Request: \(dataResponseAny.request)" + "\n"
                    self.responseMsgTextView.text = self.responseMsgTextView.text + "Response: \(dataResponseAny.response)" + "\n"
                    self.responseMsgTextView.text = self.responseMsgTextView.text+"Error: \(dataResponseAny.result.error)" + "\n"
                    
                    if let data = dataResponseAny.data, let utf8Text = String(data: data, encoding: .utf8) {
                        self.responseMsgTextView.text = self.responseMsgTextView.text + "Data: \(utf8Text)" + "\n"
                    }

                    self.activityIndicator.stopAnimating()
                })
            case ("get", "String"):
                Alamofire.request(requestUrl, method: .get, parameters: parameters).responseString(queue: nil, encoding: nil, completionHandler: { (dataResponseString) in
                    print("Get String Response Finished:")
                    self.responseMsgTextView.text = "Request: \(dataResponseString.request)" + "\n"
                    self.responseMsgTextView.text = self.responseMsgTextView.text + "Response: \(dataResponseString.response)" + "\n"
                    self.responseMsgTextView.text = self.responseMsgTextView.text+"Error: \(dataResponseString.result.error)" + "\n"
                    
                    if let data = dataResponseString.data, let utf8Text = String(data: data, encoding: .utf8) {
                        self.responseMsgTextView.text = self.responseMsgTextView.text + "Data: \(utf8Text)" + "\n"
                    }
                    self.activityIndicator.stopAnimating()
                })
            case ("get", "PropertyList"):
                Alamofire.request(requestUrl, method: .get, parameters: parameters).responsePropertyList(queue: nil, completionHandler: { (dataResponseAny) in
                    print("Get PropertyList Response Finished:")
                    self.responseMsgTextView.text = "Request: \(dataResponseAny.request)" + "\n"
                    self.responseMsgTextView.text = self.responseMsgTextView.text + "Response: \(dataResponseAny.response)" + "\n"
                    self.responseMsgTextView.text = self.responseMsgTextView.text+"Error: \(dataResponseAny.result.error)" + "\n"
                    
                    if let data = dataResponseAny.data, let utf8Text = String(data: data, encoding: .utf8) {
                        self.responseMsgTextView.text = self.responseMsgTextView.text + "Data: \(utf8Text)" + "\n"
                    }
                    self.activityIndicator.stopAnimating()
                })
            case ("post", "Original"):
                Alamofire.request(requestUrl, method: .post, parameters: parameters).response(queue: nil, completionHandler: { (defaultDataResponse) in
                    print("Post Original Response Finished:")
                    self.responseMsgTextView.text = "Request: \(defaultDataResponse.request)" + "\n"
                    self.responseMsgTextView.text = self.responseMsgTextView.text + "Response: \(defaultDataResponse.response)" + "\n"
                    self.responseMsgTextView.text = self.responseMsgTextView.text + "Error: \(defaultDataResponse.error)" + "\n"
                    if let data = defaultDataResponse.data, let utf8Text = String(data: data, encoding: .utf8) {
                        self.responseMsgTextView.text = self.responseMsgTextView.text + "Data: \(utf8Text)" + "\n"
                    }
                    self.activityIndicator.stopAnimating()
                })
            case ("post", "Data"):
                Alamofire.request(requestUrl, method: .post, parameters: parameters).responseData(queue: nil, completionHandler: { (dataResponseData) in
                    print("Post Data Response Finished:")
                    self.responseMsgTextView.text = "Request: \(dataResponseData.request)" + "\n"
                    self.responseMsgTextView.text = self.responseMsgTextView.text + "Response: \(dataResponseData.response)" + "\n"
                    self.responseMsgTextView.text = self.responseMsgTextView.text + "Error: \(dataResponseData.result.error)" + "\n"
                    if let data = dataResponseData.data, let utf8Text = String(data: data, encoding: .utf8) {
                        self.responseMsgTextView.text = self.responseMsgTextView.text + "Data: \(utf8Text)" + "\n"
                    }
                    self.activityIndicator.stopAnimating()
                })
            case ("post", "JSON"):
                Alamofire.request(requestUrl, method: .post, parameters: parameters).responseJSON(queue: nil, completionHandler: { (dataResponseAny) in
                    print("Post JSON Response Finished:")
                    self.responseMsgTextView.text = "Request: \(dataResponseAny.request)" + "\n"
                    self.responseMsgTextView.text = self.responseMsgTextView.text + "Response: \(dataResponseAny.response)" + "\n"
                    self.responseMsgTextView.text = self.responseMsgTextView.text + "Error: \(dataResponseAny.result.error)" + "\n"
                    if let data = dataResponseAny.data, let utf8Text = String(data: data, encoding: .utf8) {
                        self.responseMsgTextView.text = self.responseMsgTextView.text + "Data: \(utf8Text)" + "\n"
                    }
                    self.activityIndicator.stopAnimating()
                })
            case ("post", "String"):
                Alamofire.request(requestUrl, method: .post, parameters: parameters).responseString(queue: nil, encoding: nil, completionHandler: { (dataResponseString) in
                    print("Post String Response Finished:")
                    self.responseMsgTextView.text = "Request: \(dataResponseString.request)" + "\n"
                    self.responseMsgTextView.text = self.responseMsgTextView.text + "Response: \(dataResponseString.response)" + "\n"
                    self.responseMsgTextView.text = self.responseMsgTextView.text + "Error: \(dataResponseString.result.error)" + "\n"
                    if let data = dataResponseString.data, let utf8Text = String(data: data, encoding: .utf8) {
                        self.responseMsgTextView.text = self.responseMsgTextView.text + "Data: \(utf8Text)" + "\n"
                    }
                    self.activityIndicator.stopAnimating()
                })
            case ("post", "PropertyList"):
                Alamofire.request(requestUrl, method: .get, parameters: parameters).responsePropertyList(queue: nil, completionHandler: { (dataResponseAny) in
                    print("Post PropertyList Response Finished:")
                    self.responseMsgTextView.text = "Request: \(dataResponseAny.request)" + "\n"
                    self.responseMsgTextView.text = self.responseMsgTextView.text + "Response: \(dataResponseAny.response)" + "\n"
                    self.responseMsgTextView.text = self.responseMsgTextView.text + "Error: \(dataResponseAny.result.error)" + "\n"
                    if let data = dataResponseAny.data, let utf8Text = String(data: data, encoding: .utf8) {
                        self.responseMsgTextView.text = self.responseMsgTextView.text + "Data: \(utf8Text)" + "\n"
                    }
                    self.activityIndicator.stopAnimating()
                })
            default:
                MyAlertWindow(msg: "!ERROR PATHED REQUEST!")
            }
        } else {
            MyAlertWindow(msg: "URL cannot be empty!")
        }
    }
    
    // MARK: AddParameter
    @IBAction func AddParameter(_ sender: AnyObject) {
        ResignAllTextFieldFirstResponder(forView: self.view)
        
        if let key = parameterKeyText.text, let value = parameterValueText.text {
            guard !key.isEmpty else {
                MyAlertWindow(msg: "Key cannot be empty!")
                return
            }
            
            if parametersKeyArray.contains(key) {
                let index = parametersKeyArray.index(of: key)
                if value.isEmpty {
                    parametersKeyArray.remove(at: index!)
                    parametersValueArray.remove(at: index!)
                } else {
                    parametersValueArray[index!] = value
                }
            } else {
                parametersKeyArray.append(key)
                parametersValueArray.append(value)
            }
            self.parametersTableView.reloadData()
        } else {
            MyAlertWindow(msg: "Something Wrong:Key or Value is nil!")
        }
    }
    
    // MARK: UIPickerViewDelegate
    // returns the number of 'columns' to display.
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    // returns the # of rows in each component..
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        switch pickerView.restorationIdentifier! {
        case "methodPicker":
            return requestMethodArray.count
        case "responsePicker":
            return responseHandleArray.count
        default:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        
        switch pickerView.restorationIdentifier! {
        case "methodPicker":
            pickerLabel.text = requestMethodArray[row]
        case "responsePicker":
            pickerLabel.text = responseHandleArray[row]
        default:
            pickerLabel.text = "!ERROR DATA!"
        }
        
        pickerLabel.font = UIFont(name: "System", size: 14)
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
    
    // MARK: UITabelViewDelegate
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parametersKeyArray.count
    }
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseID", for: indexPath)
        
        (cell.viewWithTag(101) as! UILabel).text = parametersKeyArray[indexPath.row]
        (cell.viewWithTag(102) as! UILabel).text = parametersValueArray[indexPath.row]
        
        return cell
    }
    
    // MARK: AlertWindow
    func MyAlertWindow(msg: String) {
        let alertController = UIAlertController(title: "提示", message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: ResignAllTextFieldFirstResponder
    func ResignAllTextFieldFirstResponder(forView view: UIView) {
        for v in view.subviews {
            if v is UITextField {
                v.resignFirstResponder()
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
