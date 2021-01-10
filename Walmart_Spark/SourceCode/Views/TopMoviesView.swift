//
//  TopMoviesView.swift
//  Walmart_Spark
//
//  Created by Francis Chan on 1/8/21.
//

import UIKit

class TopMoviesView: UITableViewController,
                     TopMoviesViewModelDelegate {
    @IBOutlet var customFooter: CustomFooter!
    var viewModel:TopMoviesViewModel = TopMoviesViewModel()

    //ViewModel delegate method(s)
    func didMakeRequestSuccess(){
        DispatchQueue.main.async {
           self.tableView.reloadData()
           self.customFooter.isHidden = true
        }
    }
    
    func didMakeRequestFailed(_ errorMsg:String){
        DispatchQueue.main.async {
            self.customFooter.isHidden = true
            Utils.displayAlert("", message: errorMsg,vc:self)
        }
    }

    //View life cycle method(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        customFooter.isHidden = true
        viewModel.delegate = self
        viewModel.getTopMovies()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //When app is running out of memory, remove all images
        //from images cache.
        viewModel.removeAll()
    }
    
    //Tableview method(s)
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifierFromStoryboard:String = "CustomCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierFromStoryboard, for: indexPath) as! CustomCell

        //poster_path
        viewModel.poster_path(indexPath.row) { (data) in
            DispatchQueue.main.async {
                cell.poster_path.image = UIImage(data: data)
            }
        }

        //title
        cell.title.text = viewModel.title(indexPath.row)
        
        //genre
        cell.genre.text = viewModel.genre(indexPath.row)

        //popularity
        cell.popularity.text = viewModel.popularity(indexPath.row)

        //release_date
        cell.release_date.text = viewModel.release_date(indexPath.row)

        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath){
        if viewModel.isLoading == true {
            return
        }

        viewModel.setSelectedRow(indexPath.row)
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    //Storyboard
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let obj = ((segue.destination) as! TopMoviesDetailView)
            obj.selectedRow = viewModel.getSelectedRow
        }
    }

    //Used for fetching data
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (maximumOffset - currentOffset) <= 40 {
            if viewModel.isLoading == true ||
               (viewModel.getCurrentPage > viewModel.maxPages) {
                return
            }
        
            customFooter.isHidden = false
            viewModel.getTopMovies()
        }
    }
}
