//
//  TopMoviesDetailView.swift
//  Walmart_Spark
//
//  Created by Francis Chan on 1/8/21.
//

import UIKit

class TopMoviesDetailView: UIViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleString.text = viewModel.titleString(selectedRow.title)
        self.overview.text = viewModel.overview(selectedRow.overview)
        self.release_date.text = viewModel.release_date(selectedRow.release_date)
        self.original_language.text = viewModel.original_language(selectedRow.original_language)
        self.popularity.text = viewModel.popularity(selectedRow.popularity)
        self.vote_average.text = viewModel.vote_average(selectedRow.vote_average)
        self.vote_count.text = viewModel.vote_count(selectedRow.vote_count)
        self.id.text = viewModel.id(selectedRow.id)
        self.genre_names.text = viewModel.genre_names(selectedRow.genre_names)
        self.poster_path_image.image = UIImage(data: viewModel.poster_path_image(selectedRow.poster_path_imageData))
    }
}

