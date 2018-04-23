//
//  CountryCodeVC.swift
//  Onboarding
//
//  Created by Appinventiv on 02/11/17.
//  Copyright © 2017 Gurdeep Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol SetContryCodeDelegate: class {
    func setCountryCode(country_info: JSONDictionary)
}

class CountryCodeVC: BaseSurfaceVC {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countryCodeTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var countryInfo = JSONDictionaryArray()
    var filteredCountryList = JSONDictionaryArray()
    weak var delegate: SetContryCodeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }

    private func initialSetup(){
        searchBar.autocapitalizationType = .words
        countryCodeTableView.delegate = self
        countryCodeTableView.dataSource = self
        searchBar.delegate = self
        self.readJson()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func readJson() {
        
        let file = Bundle.main.path(forResource: "countryData", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: file!))

        let jsonData = try? JSONSerialization.jsonObject(with: data!, options: []) as! JSONDictionaryArray
        
        self.countryInfo = jsonData!
        self.filteredCountryList = jsonData!
        self.countryCodeTableView.reloadData()

    }

    
    @IBAction func backbtnTap(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}


extension CountryCodeVC: UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredCountryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppClassID.CountryCodeCell.cellID, for: indexPath) as! CountryCodeCell
        let info = self.filteredCountryList[indexPath.row]
        cell.populateView(info: info)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = self.filteredCountryList[indexPath.row]

        self.delegate?.setCountryCode(country_info: info)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}

//MARK:- SearchBar Delegate
extension CountryCodeVC: UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.layoutIfNeeded()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        Global.print_Debug("Search Cancel")
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.containsEmoji{
            return false
        }
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Global.print_Debug(searchText)
        let filter = self.countryInfo.filter({ ($0["CountryEnglishName"] as? String ?? "").localizedCaseInsensitiveContains(searchBar.text!)
        })
        self.filteredCountryList = filter
        
        if let txt = searchBar.text , txt.isEmpty{
            self.filteredCountryList = self.countryInfo
        }
        self.countryCodeTableView.reloadData()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.layoutIfNeeded()
        return true
    }
}

//MARK:- CountryCodeCell
class CountryCodeCell: UITableViewCell {
    //MARK:- @IBOutlets
    @IBOutlet weak var countryCode: UILabel!
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func populateView(info: JSONDictionary){
        guard let code = info["CountryCode"] else{return}
        guard let name = info["CountryEnglishName"] as? String else{return}
        self.countryCode.text = "\(name)(+\(code))"
    }
}
