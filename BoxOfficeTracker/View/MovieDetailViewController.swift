//
//  MovieDetailViewController.swift
//  BoxOfficeTracker
//
//  Created by 송하경 on 2/23/24.
//
import Combine
import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var movieNmLabel: UILabel!
    @IBOutlet weak var openDtLabel: UILabel!
    @IBOutlet weak var showTmLabel: UILabel!
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var directorCollectionView: UICollectionView!
    @IBOutlet weak var actorCollectionView: UICollectionView!
    @IBOutlet weak var companyCollectionView: UICollectionView!
    
    @IBOutlet weak var genreView: UIView!
    @IBOutlet weak var directorView: UIView!
    @IBOutlet weak var actorView: UIView!
    @IBOutlet weak var companyView: UIView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var movieCd: String?
    
    var viewModel = MovieDetailViewModel()
    var movieInfo: MovieEntity.Response.MovieInfoResult.MovieInfo?
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        networkRequest()
        
        setUI()
    }
    
    private func setUI() {
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
        
        directorCollectionView.delegate = self
        directorCollectionView.dataSource = self
        
        actorCollectionView.delegate = self
        actorCollectionView.dataSource = self
        
        companyCollectionView.delegate = self
        companyCollectionView.dataSource = self
        
        activityIndicatorView.hidesWhenStopped = true
    }
    
    private func bind() {
        viewModel.movieDetailSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] movieInfo in
                self?.movieInfo = movieInfo
                self?.movieNmLabel.text = movieInfo?.movieNm
                self?.openDtLabel.text = convertDate(inputDate: movieInfo?.openDt ?? "", stringType: "yyyyMMdd")
                self?.showTmLabel.text = "\(movieInfo?.showTm ?? "")분"
                
                self?.genreCollectionView.reloadData()
                self?.directorCollectionView.reloadData()
                self?.actorCollectionView.reloadData()
                self?.companyCollectionView.reloadData()
                
                self?.genreView.isHidden = movieInfo?.genres?.isEmpty ?? true
                self?.directorView.isHidden = movieInfo?.directors?.isEmpty ?? true
                self?.actorView.isHidden = movieInfo?.actors?.isEmpty ?? true
                self?.companyView.isHidden = movieInfo?.companys?.isEmpty ?? true
                
                self?.activityIndicatorView.stopAnimating()
            }.store(in: &cancellables)
    }
    
    private func networkRequest() {
        guard let movieCd = movieCd else { return }
        activityIndicatorView.startAnimating()
        
        Task {
            await viewModel.getMovieDetailResult(movieCd: movieCd)
        }
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case genreCollectionView:
            return movieInfo?.genres?.count ?? 0
        case directorCollectionView:
            return movieInfo?.directors?.count ?? 0
        case actorCollectionView:
            return movieInfo?.actors?.count ?? 0
        case companyCollectionView:
            return movieInfo?.companys?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case genreCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OneLabelTypeCollectionViewCell.identifier, for: indexPath) as? OneLabelTypeCollectionViewCell else { return UICollectionViewCell() }
            
            let item = movieInfo?.genres?[indexPath.row]
            cell.firstLabel.text = item?.genreNm
            return cell
        case directorCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OneLabelTypeCollectionViewCell.identifier, for: indexPath) as? OneLabelTypeCollectionViewCell else { return UICollectionViewCell() }
            
            let item = movieInfo?.directors?[indexPath.row]
            cell.firstLabel.text = item?.peopleNm
            return cell
        case actorCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TwoLabelTypeCollectionViewCell.identifier, for: indexPath) as? TwoLabelTypeCollectionViewCell else { return UICollectionViewCell() }
            
            let item = movieInfo?.actors?[indexPath.row]
            cell.topLabel.text = item?.peopleNm
            if let cast = item?.cast, !cast.isEmpty {
                cell.bottomLabel.text = "\(cast)역"
            }
            return cell
        case companyCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TwoLabelTypeCollectionViewCell.identifier, for: indexPath) as? TwoLabelTypeCollectionViewCell else { return UICollectionViewCell() }
            
            let item = movieInfo?.companys?[indexPath.row]
            cell.topLabel.text = item?.companyNm
            cell.bottomLabel.text = item?.companyPartNm
            return cell
        default:
            break
        }
        
        return UICollectionViewCell()
    }
}
