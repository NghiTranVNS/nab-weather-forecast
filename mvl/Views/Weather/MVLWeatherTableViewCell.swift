//
//  MVLWeatherTableViewCell.swift
//  mvl
//
//  Created by Mr Nghi Tran Kien Nghi on 5/9/22.
//

import UIKit
import Kingfisher

class MVLWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func cleanUI() {
        iconImageView.image = nil
        dateLabel.text = nil
        tempLabel.text = nil
        pressureLabel.text = nil
        humidityLabel.text = nil
        descriptionLabel.text = nil
    }
}

extension MVLWeatherTableViewCell {
    func bindWeather(_ weather: MVLWeather) {
        //Clear reused data first
        cleanUI()
        
        //Set data to display
        dateLabel.text = weather.dateDescription()
        tempLabel.text = weather.temperatureDescription()
        pressureLabel.text = weather.pressureDescription()
        humidityLabel.text = weather.humidityDescription()
        descriptionLabel.text = weather.shortDescription()
        
        //http://openweathermap.org/img/wn/10d@2x.png
        iconImageView.kf.setImage(with: URL(string: "http://openweathermap.org/img/wn/\(weather.icon)@2x.png"))
    }
}
