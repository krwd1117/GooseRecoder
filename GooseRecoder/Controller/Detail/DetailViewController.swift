//
//  DetailViewController.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/05.
//

import UIKit
import SnapKit
import MapKit

import RealmSwift

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var recordItem: RecordItem? = nil
    
    let realm = try! Realm()
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        
        let mark = Marker(
            title: recordItem?.address,
            subtitle: nil,
            coordinate: CLLocationCoordinate2D(
                latitude: recordItem?.latitude ?? 0.0,
                longitude: recordItem?.longitude ?? 0.0
            )
        )
        
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(
            latitude: recordItem?.latitude ?? 0.0,
            longitude: recordItem?.longitude ?? 0.0
        ), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
        
        mapView.addAnnotation(mark)
        
        mapView.scalesLargeContentImage = true
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = true
        
        mapView.layer.borderColor = UIColor.label.cgColor
        mapView.layer.borderWidth = 1
        mapView.layer.cornerRadius = 20
        
        return mapView
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = recordItem?.address
        label.textColor = .white
        label.layer.cornerRadius = 20
        label.textAlignment = .center
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        let date = recordItem?.date.components(separatedBy: "-")
        label.text = "\(date![0])년 \(date![1])월 \(date![2])일"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        let time = recordItem?.time.components(separatedBy: ":")
        label.text = "\(time![0])시 \(time![1])분 \(time![2])초"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .systemBackground
        tf.textColor = .label
        tf.text = recordItem?.memo
//        tf.placeholder = "메모를 입력하세요"
        tf.attributedPlaceholder = NSAttributedString(string: "메모를 입력하세요", attributes: [.foregroundColor: UIColor.systemGray])
        tf.layer.cornerRadius = 10
        tf.clearsOnBeginEditing = true
        tf.addLeftPadding()
        return tf
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.backgroundColor = RECORDCOLOR
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MAINCOLOR
        configureLayout()
        
        textField.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Configure
    
    private func configureLayout() {
        view.addSubview(addressLabel)
        addressLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(16)
            $0.height.equalTo(50)
            $0.trailing.leading.equalToSuperview().inset(16)
        }
        
        let dateStack = UIStackView(arrangedSubviews: [dateLabel, timeLabel])
        dateStack.distribution = .equalCentering
        
        view.addSubview(dateStack)
        dateStack.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(16)
            $0.trailing.leading.equalToSuperview().inset(16)
        }
        
        dateLabel.snp.makeConstraints {
            $0.width.equalTo(view.frame.width/2)
        }
        
        timeLabel.snp.makeConstraints {
            $0.width.equalTo(view.frame.width/2)
        }
        
        view.addSubview(textField)
        textField.snp.makeConstraints {
            $0.top.equalTo(dateStack.snp.bottom).offset(24)
            $0.trailing.leading.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(24)
            $0.trailing.leading.equalToSuperview().inset(16)
            $0.height.equalTo(mapView.snp.width)
        }
        
        let buttonStack = UIStackView(arrangedSubviews: [cancelButton, confirmButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .equalSpacing
        buttonStack.alignment = .center
        
        view.addSubview(buttonStack)
        buttonStack.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.trailing.leading.equalToSuperview().inset(16)
        }
        
        cancelButton.snp.makeConstraints {
            $0.width.equalTo(view.bounds.width/2 - 32)
            $0.height.equalTo(50)
        }
        
        confirmButton.snp.makeConstraints {
            $0.width.equalTo(view.bounds.width/2 - 32)
            $0.height.equalTo(50)
        }
        
    }
    
    // MARK: - Actions
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmButtonTapped() {
        guard let recordItem = recordItem else { return }
        let predicate = NSPredicate(format: "uuidString = %@", recordItem.uuidString)
        let record = realm.objects(Record.self).filter(predicate)
            do {
                try realm.write {
                    record[0].memo = textField.text ?? ""
                }
            } catch {
                print("ERROR: \(error.localizedDescription)")
            }
        dismiss(animated: true)
    }
    
    // MARK: - Helpers
    
}
