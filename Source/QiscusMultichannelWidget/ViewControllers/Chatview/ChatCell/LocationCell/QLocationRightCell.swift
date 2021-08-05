//
//  QLocationRightCell.swift
//  QiscusMultichannelWidget
//
//  Created by Qiscus on 22/07/21.
//

import QiscusCore
import MapKit
import SwiftyJSON

class QLocationRightCell: UIBaseChatCell {
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbNameHeight: NSLayoutConstraint!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var ivBaloon: UIImageView!
    @IBOutlet weak var ivStatus: UIImageView!
    @IBOutlet weak var locationContainer: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    var menuConfig = enableMenuConfig()
    var message: QMessage? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setMenu()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(QLocationLeftCell.openMap))
        self.mapView.addGestureRecognizer(tapRecognizer)
        self.locationContainer.tintColor = ColorConfiguration.rightBubbleColor
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleMassage(_:)),
                                               name: Notification.Name("selectedCell"),
                                               object: nil)
    }
    
    @objc func handleMassage(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let json = JSON(userInfo)
            let commentId = json["commentId"].string ?? "0"
            if let message = self.message {
                if message.id == commentId {
                    self.contentView.backgroundColor = UIColor(red:39/255, green:177/255, blue:153/255, alpha: 0.1)
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.setMenu()
        // Configure the view for the selected state
    }
    
    override func present(message: QMessage) {
        // parsing payload
        self.bindData(message: message)
        
    }
    
    override func update(message: QMessage) {
        self.bindData(message: message)
    }
    
    func bindData(message: QMessage){
        self.message = message
        self.contentView.backgroundColor = UIColor.clear
        self.setupBalon(message: message)
        self.status(message: message)
        
        self.lbTime.text = AppUtil.dateToHour(date: message.date())
        let data = message.payload
        let payload = JSON(data)
        
        self.locationLabel.text = payload["name"].stringValue
        let address = payload["address"].stringValue
        self.addressView.text = address
        
        let lat = CLLocationDegrees(payload["latitude"].doubleValue)
        let long = CLLocationDegrees(payload["longitude"].doubleValue)
        
        let center = CLLocationCoordinate2DMake(lat, long)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        let newPin = MKPointAnnotation()
        newPin.coordinate = center
        self.mapView.setRegion(region, animated: false)
        self.mapView.addAnnotation(newPin)
        
    }
    
    func status(message: QMessage){
        
        switch message.status {
        case .deleted:
//            ivStatus.image = UIImage(named: "ic_deleted")?.withRenderingMode(.alwaysTemplate)
            break
        case .sending, .pending:
            lbTime.textColor = ColorConfiguration.timeLabelTextColor
                        ivStatus.tintColor = ColorConfiguration.timeLabelTextColor
            lbTime.text = TextConfiguration.sharedInstance.sendingText
            ivStatus.image = UIImage(named: "ic_info_time", in: QiscusMultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            break
        case .sent:
            lbTime.textColor = ColorConfiguration.timeLabelTextColor
            ivStatus.tintColor = ColorConfiguration.timeLabelTextColor
            ivStatus.image = UIImage(named: "ic_sending", in: QiscusMultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)

            break
        case .delivered:
            lbTime.textColor = ColorConfiguration.timeLabelTextColor
            ivStatus.tintColor = ColorConfiguration.timeLabelTextColor
            ivStatus.image = UIImage(named: "ic_read", in: QiscusMultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            break
        case .read:
            lbTime.textColor = ColorConfiguration.timeLabelTextColor
            ivStatus.tintColor = ColorConfiguration.readMessageColor
            ivStatus.image = UIImage(named: "ic_read", in: QiscusMultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            break
        case . failed:
            lbTime.textColor = ColorConfiguration.failToSendColor
            lbTime.text = TextConfiguration.sharedInstance.failedText
            ivStatus.image = UIImage(named: "ic_warning", in: QiscusMultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            ivStatus.tintColor = ColorConfiguration.failToSendColor
            break
        case .deleting:
            ivStatus.image = UIImage(named: "ic_deleted",in: QiscusMultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            break
        }
    }
    
    func setupBalon(message: QMessage){
        self.ivBaloon.image = self.getBallon()
        self.lbNameHeight.constant = 0
        self.ivBaloon.layer.cornerRadius = 5
        self.ivBaloon.tintColor = ColorConfiguration.rightBubbleColor
        self.ivBaloon.backgroundColor = ColorConfiguration.rightBubbleColor
       
    }
    
    @objc func openMap(){
        let payload = JSON(self.comment?.payload)
        
        let latitude: CLLocationDegrees = payload["latitude"].doubleValue
        let longitude: CLLocationDegrees = payload["longitude"].doubleValue
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = payload["name"].stringValue
        mapItem.openInMaps(launchOptions: options)
    }
    
}
