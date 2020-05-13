//
//  EventsViewController.swift
//  UpcomingEvents
//
//  Created by Carlos Perez on 11/5/19.
//  Copyright © 2019 Carlos Perez. All rights reserved.
//

import UIKit

/// The main View Controller to present all event elements in form of a list, this its embed in a NavigationController to provide a title screen for better understanding of the screen
class EventsViewController: UIViewController {
    
    // MARK: - Variables
    /// Presenter in charge of getting the data from the models via UseCases
    var presenter: EventPresenter!
    
    struct Constants {
        static let viewTitle = "Upcoming Events"
        static let cellIdentifier = "EventCell"
        static let errorAlertTitle = "Something went wrong"
        static let errorButtonTitle = "Ok"
    }
    
    // MARK: - UI Variables
    var tableView: UITableView!
    
    /// Set the view to load programatically using Autolayout
    /// see EventsViewController+Autolayout for implementation
    override func loadView() {
        super.loadView()
        setAutoLayout()
        setUp()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    func setUp() {
        presenter = EventPresenter()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Constants.viewTitle
    }
    
    /// Get the data from the presenter and update the view accordingly
    func setData() {
        presenter.getGroupedAndOrderedModels { [weak self] (response) in
            // Catch the response from getting the data. If succeds reload the tableView, if it fails show an alert indicating the error
            switch response {
            case .success:
                self?.tableView.reloadData()
            case .failure(let error):
                self?.showErrorAlert(error: error.localizedDescription)
            }
        }
    }
    
    private func showErrorAlert(error: String) {
        let alertView = UIAlertController(title: Constants.errorAlertTitle, message: error, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.errorButtonTitle, style: .default, handler: nil)
        alertView.addAction(okAction)
        present(alertView, animated: true, completion: nil)
    }
}

// MARK: - TableView Data Source
extension EventsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.groupedEventViewModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.groupedEventViewModels[section].events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? EventTableViewCell else {
            return UITableViewCell()
        }
        
        cell.viewModel = presenter.groupedEventViewModels[indexPath.section].events[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.groupedEventViewModels[section].dateString
    }
}

// MARK: - TableView Delegate
extension EventsViewController: UITableViewDelegate {
    
}
