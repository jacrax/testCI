//
//  EventTableViewCell.swift
//  UpcomingEvents
//
//  Created by Carlos Perez on 11/5/19.
//  Copyright © 2019 Carlos Perez. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    // MARK: - UI Variables
    var eventTitleLabel: UILabel!
    var eventStartLabel: UILabel!
    var eventEndLabel: UILabel!
    var conflictLabel: UILabel!
    var conflictContainer: UIView!
    
    // MARK: - Constants
    
    struct Constants {
        static let hourLabelSpacing: CGFloat = 10.0
        static let eventFontSize: CGFloat = 16.0
        static let hourFontSize: CGFloat = 12.0
        
        static let bottomSpacing: CGFloat = -5
        static let topSpacing: CGFloat = 5
        static let stackViewSpacing: CGFloat = 10
        static let divisorWidth: CGFloat = 3
    }
    
    
    var viewModel: EventViewModel? {
        didSet {
            updateUI()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAutolayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setAutolayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateUI() {
        eventTitleLabel.text = viewModel?.eventTitle
        eventStartLabel.text = viewModel?.startDateShortString
        eventEndLabel.text = viewModel?.endDateShortString
        conflictLabel.text = "Conflict"
        if let conflict = viewModel?.hasConflict, conflict {
            conflictContainer.isHidden = false
        } else {
            conflictContainer.isHidden = true
        }
    }

}

// MARK: - Autolayout
extension EventTableViewCell {
    func setAutolayout() {
        
        /*
             -------------------------------------------
            |   Start     |  EventTitle      Conflict   |
            |   End       |                             |
             -------------------------------------------
         
         */
        
        // Setting Hours Stack view
        let hourStackView = UIStackView(frame: .zero)
        hourStackView.translatesAutoresizingMaskIntoConstraints = false
        hourStackView.axis = .vertical
        hourStackView.spacing = Constants.hourLabelSpacing
        hourStackView.alignment = .center
        
        // Setting hour labels
        let startLabel = UILabel(frame: .zero)
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        startLabel.font = UIFont.systemFont(ofSize: Constants.hourFontSize, weight: .regular)
        startLabel.numberOfLines = 1
        startLabel.textColor = .black
        
        let endLabel = UILabel(frame: .zero)
        endLabel.translatesAutoresizingMaskIntoConstraints = false
        endLabel.font = UIFont.systemFont(ofSize: Constants.hourFontSize, weight: .regular)
        endLabel.numberOfLines = 1
        endLabel.textColor = .lightGray
        
        
        hourStackView.addArrangedSubview(startLabel)
        hourStackView.addArrangedSubview(endLabel)
        
        contentView.addSubview(hourStackView)
        self.eventEndLabel = endLabel
        self.eventStartLabel = startLabel
        
        // Setting Divisor
        
        let divisorView = UIView(frame: .zero)
        divisorView.translatesAutoresizingMaskIntoConstraints = false
        divisorView.backgroundColor = .customBlue
        
        contentView.addSubview(divisorView)
        
        // Setting TitleLabel
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: Constants.eventFontSize, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        
        contentView.addSubview(titleLabel)
        self.eventTitleLabel = titleLabel
        
        // Setting conflict badge
        let conflict = UILabel()
        conflict.translatesAutoresizingMaskIntoConstraints = false
        conflict.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        conflict.textColor = .labelRed
        conflict.numberOfLines = 1
        
        let containerConflict = UIView()
        containerConflict.translatesAutoresizingMaskIntoConstraints = false
        containerConflict.layer.cornerRadius = 8.0
        containerConflict.backgroundColor = .containerRed
        
        containerConflict.addSubview(conflict)
        contentView.addSubview(containerConflict)
        self.conflictLabel = conflict
        self.conflictContainer = containerConflict
        
        // Setting Constraints
        
        
        NSLayoutConstraint.activate([
            hourStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topSpacing),
            hourStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.bottomSpacing),
            hourStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.stackViewSpacing),
            hourStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25)
        ])
        
        NSLayoutConstraint.activate([
            divisorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topSpacing*2),
            divisorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.bottomSpacing*2),
            divisorView.widthAnchor.constraint(equalToConstant: Constants.divisorWidth),
            divisorView.leadingAnchor.constraint(equalTo: hourStackView.trailingAnchor, constant: Constants.stackViewSpacing)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.bottomSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: divisorView.trailingAnchor, constant: Constants.stackViewSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: containerConflict.leadingAnchor, constant: Constants.stackViewSpacing/2)
        ])
        
        NSLayoutConstraint.activate([
            containerConflict.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.stackViewSpacing),
            containerConflict.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.15),
            containerConflict.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            containerConflict.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            conflict.centerYAnchor.constraint(equalTo: containerConflict.centerYAnchor),
            conflict.centerXAnchor.constraint(equalTo: containerConflict.centerXAnchor)
        ])
    }
}
