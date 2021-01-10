//
//  TopMoviesDetailView.swift
//  Walmart_Spark
//
//  Created by Francis Chan on 1/8/21.
//

import UIKit

class TopMoviesDetailView: UIViewController,
                           TopMoviesDetailViewModelDelegate {
    var viewModel:TopMoviesDetailViewModel = TopMoviesDetailViewModel()
    var selectedRow: DataModel.Result = DataModel.Result()
    
    @IBOutlet weak var titleString: UILabel!
    @IBOutlet weak var overview: UITextView!
    @IBOutlet weak var release_date: UILabel!
    @IBOutlet weak var original_language: UILabel!
    @IBOutlet weak var original_title: UILabel!
    @IBOutlet weak var popularity: UILabel!
    @IBOutlet weak var vote_average: UILabel!
    @IBOutlet weak var vote_count: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var genre_names: UILabel!
    @IBOutlet weak var poster_path_image: UIImageView!
    @IBOutlet weak var homepage: UILabel!
    
    //TopMoviesDetailViewModel Delegate Method(s)
    func didMakeRequestSuccess(_ homepage:String) {
        DispatchQueue.main.async {
            self.homepage.text = homepage
        }
    }
    
    func didMakeRequestFailed(_ errorMsg:String) {
        DispatchQueue.main.async {
            Utils.displayAlert("", message: errorMsg,vc:self)
        }
    }

    //View life cycle method(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.getMovie(selectedRow.id)
        
        titleString.text = viewModel.titleString(selectedRow.title)
        overview.text = viewModel.overview(selectedRow.overview)
        release_date.text = viewModel.release_date(selectedRow.release_date)
        original_language.text = viewModel.original_language(selectedRow.original_language)
        popularity.text = viewModel.popularity(selectedRow.popularity)
        vote_average.text = viewModel.vote_average(selectedRow.vote_average)
        vote_count.text = viewModel.vote_count(selectedRow.vote_count)
        id.text = viewModel.id(selectedRow.id)
        genre_names.text = viewModel.genre_names(selectedRow.genre_names)
        poster_path_image.image = UIImage(data: viewModel.poster_path_image(selectedRow.poster_path_imageData))
    }
}

