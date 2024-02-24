//
//  BoxOfficeListViewController.swift
//  BoxOfficeTracker
//
//  Created by 송하경 on 2/23/24.
//
import Combine
import CombineCocoa
import UIKit

class BoxOfficeListViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var weekendButton: UIButton!
    @IBOutlet weak var weekdayButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var noDataView: UIView!
    
    var viewModel = BoxOfficeListViewModel()
    var boxOfficeList: [BoxOfficeListEntity.Response.BoxOfficeResult.WeeklyBoxOffice] = []
    var cancellables = Set<AnyCancellable>()
    
    var targetDate = getDateFormat(date: oneWeekBefore)
    var weekGb = BoxOfficeListEntity.WeekGB.weekly
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "BoxOffice 순위"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        bind()
        observe()
        networkRequest()
        
        activityIndicatorView.hidesWhenStopped = true
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.date = oneWeekBefore
    }
    
    private func bind() {
        viewModel.boxOfficeListSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] boxOfficeList in
                self?.boxOfficeList = boxOfficeList
                self?.tableView.reloadData()
                self?.activityIndicatorView.stopAnimating()
                
                self?.noDataView.isHidden = !boxOfficeList.isEmpty
            }.store(in: &cancellables)
    }
    
    private func observe() {
        weeklyButton.tapPublisher
            .sink { [weak self] in
                self?.initUI()
                self?.weeklyButton.isSelected.toggle()
                self?.weekGb = .weekly
                self?.networkRequest()
            }.store(in: &cancellables)
        
        weekendButton.tapPublisher
            .sink { [weak self] in
                self?.initUI()
                self?.weekendButton.isSelected.toggle()
                self?.weekGb = .weekend
                self?.networkRequest()
            }.store(in: &cancellables)
        
        weekdayButton.tapPublisher
            .sink { [weak self] in
                self?.initUI()
                self?.weekdayButton.isSelected.toggle()
                self?.weekGb = .weekday
                self?.networkRequest()
            }.store(in: &cancellables)
    }
    
    private func networkRequest() {
        activityIndicatorView.startAnimating()
        
        Task {
            await viewModel.getBoxOfficeListResult(targetDate: targetDate, weekGb: weekGb)
        }
    }
    
    private func initUI(buttonEventFlag: Bool = true) {
        noDataView.isHidden = true
        
        if buttonEventFlag {
            weeklyButton.isSelected = false
            weekendButton.isSelected = false
            weekdayButton.isSelected = false
        }
        
        boxOfficeList.removeAll()
        tableView.reloadData()
    }
    
    @objc func datePickerValueChanged(_ datePicker: UIDatePicker) {
        let selectedDate = datePicker.date
        targetDate = getDateFormat(date: selectedDate)

        initUI(buttonEventFlag: false)
        networkRequest()
        
        self.dismiss(animated: false)
    }
}

extension BoxOfficeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boxOfficeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BoxOfficeTableViewCell.identifier, for: indexPath) as? BoxOfficeTableViewCell else { return UITableViewCell() }
        let item = boxOfficeList[indexPath.row]
        cell.rankLabel.text = "\(item.rank)위"
        cell.rankOldAndNewLabel.text = item.rankOldAndNew == .NEW ? "N" : ""
        cell.movieNmLabel.text = item.movieNm
        cell.openDateLabel.text = "개봉일: \(item.openDt?.replacingOccurrences(of: "-", with: ".") ?? "")"
        cell.audienceAccLabel.text = "누적관객수: \(addCommasToNumberString(item.audiAcc ?? "") ?? "")명"
        cell.salesAccLabel.text = "누적매출액: \(addCommasToNumberString(item.salesAcc ?? "") ?? "")원"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = boxOfficeList[indexPath.row]
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController, let movieCd = item.movieCd else { return }
        vc.movieCd = movieCd
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
