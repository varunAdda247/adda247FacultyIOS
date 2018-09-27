//
//  ADEmptyStateView.swift
//  Adda247
//
//  Created by Moazzam Ali Khan on 02/07/18.
//  Copyright © 2018 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import UIKit

class ADEmptyStateView: UIView {
    let containerWidth:CGFloat = 300.0
    let imageWidth:CGFloat = 162.0
    let imageHeight:CGFloat = 146.0
    let titleWidth:CGFloat = 250.0
    let titleHeight:CGFloat = 20.0
    let subtitleWidth:CGFloat = 220.0
    let buttonHeight:CGFloat = 30.0
    let titleTopSpacing:CGFloat = 24.0
    let subtitleTopSpacing:CGFloat = 4.0
    let buttonTopSpacing:CGFloat = 16.0

    private var imageView: UIImageView?
    private var titlelabel: UILabel?
    private var subTitleLabel: UILabel?
    var button: UIButton?
    private var containerView: UIView
    private var buttonTapCallback: (()->Void)?
    private var containerHeight:NSLayoutConstraint!
    
    convenience init(image:UIImage?,title:String?,subTitle:String?,buttonText:String?,buttonCallBack:(()->Void)?) {
        self.init(frame: CGRect.zero)
        self.addSubview(containerView)
        if image != nil {
            imageView = UIImageView(image: image)
            containerView.addSubview(imageView!)
        }
        if title != nil {
           titlelabel = UILabel(frame: CGRect.zero)
            titlelabel?.text = title
            titlelabel?.font = UIFont(name: "Avenir-Medium", size: 14.0)
            titlelabel?.textColor = UIColor(red: 3.0/255, green: 169.0/255, blue: 244.0/255, alpha: 1.0)
            titlelabel?.textAlignment = .center
            containerView.addSubview(titlelabel!)
        }
        if subTitle != nil {
            subTitleLabel = UILabel(frame: CGRect.zero)
            subTitleLabel?.text = subTitle
            subTitleLabel?.numberOfLines = 0
            subTitleLabel?.font = UIFont(name: "Avenir-Book", size: 12.0)
            subTitleLabel?.textColor = UIColor.black.withAlphaComponent(0.38)
            subTitleLabel?.textAlignment = .center
            containerView.addSubview(subTitleLabel!)
        }
        if buttonText != nil {
            button = UIButton(type: .custom)
            button?.backgroundColor = UIColor(red: 255.0/255, green: 64.0/255, blue: 129.0/255, alpha: 1.0)
            button?.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 12.0)
            button?.setTitleColor(UIColor.white, for: .normal)
            button?.setTitle(buttonText, for: .normal)
            button?.contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 16)
            button?.layer.cornerRadius = 2
            button?.layer.masksToBounds = true
            button?.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            containerView.addSubview(button!)
        }
        if  buttonCallBack != nil {
            buttonTapCallback = buttonCallBack
        }
        setupConstraints()
        self.backgroundColor = UIColor(red: 239.0/255, green: 239.0/255, blue: 244.0/255, alpha: 1.0)
        containerView.backgroundColor = UIColor.clear
    }
    
   
    override init(frame: CGRect) {
        containerView = UIView()
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped() {
        if (buttonTapCallback != nil) {
            buttonTapCallback!()
        }
    }
    
    
    func setupConstraints() {
        setContainerViewConstraints()
        var top:UIView = containerView
        if imageView != nil {
            setImageViewConstraints(top)
            top = imageView!
        }
        if titlelabel != nil {
            setTitleLabelConstraints(top)
            top = titlelabel!
        }
        if subTitleLabel != nil {
            setSubTitleConstraints(top)
            top = subTitleLabel!
        }
        if button != nil {
            setButtonConstraints(top)
            top = button!
        }
        top.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)


    }
    
    func setContainerViewConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        containerHeight = containerView.heightAnchor.constraint(equalToConstant: 0.0)
        containerHeight.isActive = true
        containerView.widthAnchor.constraint(equalToConstant: containerWidth).isActive = true

    }
    
    func setImageViewConstraints(_ top:UIView) {
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        if top == containerView {
            imageView?.topAnchor.constraint(equalTo: top.topAnchor).isActive = true
        }
        else {
            imageView?.topAnchor.constraint(equalTo: top.bottomAnchor).isActive = true
        }
        imageView?.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        imageView?.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        imageView?.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
        containerHeight.constant = containerHeight.constant+imageHeight
    }
    
    func setTitleLabelConstraints(_ top:UIView) {
        titlelabel?.translatesAutoresizingMaskIntoConstraints = false
        if top == containerView {
            titlelabel?.topAnchor.constraint(equalTo: top.topAnchor).isActive = true
        }
        else {
            titlelabel?.topAnchor.constraint(equalTo: top.bottomAnchor, constant: titleTopSpacing).isActive = true
            containerHeight.constant = containerHeight.constant+titleTopSpacing
        }
        titlelabel?.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        titlelabel?.widthAnchor.constraint(equalToConstant: titleWidth).isActive = true
        titlelabel?.heightAnchor.constraint(equalToConstant: titleHeight).isActive = true
        containerHeight.constant = containerHeight.constant+titleHeight

    }
    
    func setSubTitleConstraints(_ top:UIView) {
        subTitleLabel?.translatesAutoresizingMaskIntoConstraints = false
        if top == containerView {
            subTitleLabel?.topAnchor.constraint(equalTo: top.topAnchor).isActive = true
        }
        else {
            subTitleLabel?.topAnchor.constraint(equalTo: top.bottomAnchor, constant: subtitleTopSpacing).isActive = true
            containerHeight.constant = containerHeight.constant+subtitleTopSpacing

        }

        subTitleLabel?.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        subTitleLabel?.widthAnchor.constraint(equalToConstant: subtitleWidth).isActive = true
        //ADUtility.updateLabelFrame(label: subTitleLabel!, maxSize: CGSize(width: subtitleWidth, height: CGFloat.infinity))
        subTitleLabel?.heightAnchor.constraint(equalToConstant: subTitleLabel!.bounds.size.height).isActive = true
        containerHeight.constant = containerHeight.constant+subTitleLabel!.bounds.size.height

    }
    
    func setButtonConstraints(_ top:UIView) {
        button?.translatesAutoresizingMaskIntoConstraints = false
        if top == containerView {
            button?.topAnchor.constraint(equalTo: top.topAnchor).isActive = true
        }
        else {
            button?.topAnchor.constraint(equalTo: top.bottomAnchor, constant: buttonTopSpacing).isActive = true
            containerHeight.constant = containerHeight.constant+buttonTopSpacing

        }
        button?.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        button?.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        containerHeight.constant = containerHeight.constant+buttonHeight
    }
}
