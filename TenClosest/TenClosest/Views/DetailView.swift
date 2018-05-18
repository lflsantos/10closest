//
//  DetailView.swift
//  TenClosest
//
//  Created by Lucas Santos on 18/05/18.
//  Copyright © 2018 Lucas Santos. All rights reserved.
//

import UIKit

class DetailView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var open = false {
        didSet{
            openLabel.text = open ? "Sim" : "Não"
        }
    }
    var rating : Float = 0.0 {
        didSet{
            ratingLabel.text = String(rating)
        }
    }
    
    var price = 0 {
        didSet{
            var label : String
            switch price {
            case 0:
                label = "Gratuito"
            case 1:
                label = "Barato"
            case 2:
                label = "Moderado"
            case 3:
                label = "Caro"
            case 4:
                label = "Muito caro"
            default:
                label = ""
            }
            priceLabel.text = label
        }
    }
    
    
    var locationModel : LocationModel? = nil{
        didSet{
            if let location = locationModel {
                nameLabel.text = location.name
                adressLabel.text = location.formatted_address
                if let open = location.open{
                    self.open = open
                }
                if let price = location.price_level{
                    self.price = price
                }
                if let rating = location.rating{
                    self.rating = rating
                }
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    func initView(){
        Bundle.main.loadNibNamed("DetailView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        adressLabel.text = ""
        ratingLabel.text = ""
        openLabel.text = ""
        priceLabel.text = ""
    }
}
