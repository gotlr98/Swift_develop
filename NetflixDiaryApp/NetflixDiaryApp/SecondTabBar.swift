//
//  SecondTabBar.swift
//  NetflixDiaryApp
//
//  Created by HaeSik Jang on 2023/06/29.
//

import Foundation
import UIKit

class SecondTabBar: UIViewController{
    
//    let pop = popularMoviewView()
    
    lazy var collectionView: UICollectionView = {
       
        
        let lay = UICollectionViewFlowLayout()
        lay.scrollDirection = .horizontal
        
        lay.minimumLineSpacing = 50
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: lay)
        view.backgroundColor = .white
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가하기", image: UIImage(systemName: "magnifyingglass"), target: nil, action: nil)

        self.navigationItem.rightBarButtonItem!.menu = UIMenu(children: [
                        UIAction(title: "리뷰쓰기", attributes: .destructive, handler: { _ in

                            self.navigationController?.pushViewController(writeReviewModal(), animated: true)
                        })
                    ])
        
//        let refresh = UIRefreshControl()
//
//        refresh.addTarget(self, action: #selector(getData), for: .valueChanged)
        
    }
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
//        self.view.backgroundColor = .white
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func getData(){
        
        
        var timer: Int = 0
        
        findPopularFilm()
        
    }
    
    @objc func findPopularFilm() {

        let API_KEY = "e8cb2a054ca6f112d66b1e816e239ee6"
        var movieSearchURL = URLComponents(string: "https://api.themoviedb.org/3/discover/movie?")

        // 쿼리 아이템 정의
        let apiQuery = URLQueryItem(name: "api_key", value: API_KEY)
        let languageQuery = URLQueryItem(name: "language", value: "ko-KR")
//        let searchQuery = URLQueryItem(name: "query", value: name)
        let watchProvider = URLQueryItem(name: "with_watch_providers", value: "8")

        movieSearchURL?.queryItems?.append(apiQuery)
        movieSearchURL?.queryItems?.append(languageQuery)
//        movieSearchURL?.queryItems?.append(searchQuery)
        movieSearchURL?.queryItems?.append(watchProvider)
        
        guard let requestMovieSearchURL = movieSearchURL?.url else { return }
        
        let config = URLSessionConfiguration.default

        // session 설정
        let session = URLSession(configuration: config)
        
        let dataTask = session.dataTask(with: requestMovieSearchURL, completionHandler: { (data, response, error) -> Void in
              if (error != nil) {
                print(error as Any)
              } else {
                  guard let resultData = data else { return }
                  do{
                      let decoder = JSONDecoder()
                      let respons = try decoder.decode(Response.self, from: resultData)
                      let searchMovie = respons.result
                      
                      for i in searchMovie{
                          print("영화 제목 : \(i.title ?? "")")
                          print("영화 평점 : \(i.rating ?? 0)")
                          print("영화 줄거리 : \(i.summary ?? "")")
                          print("포스터 경로 : \(i.post ?? "")")
    
                          print("--------------------------")
//                          self.title_url[i.title!] = "https://image.tmdb.org/t/p/w220_and_h330_face" + i.post!
                      }
                      
                  }catch let error{
                      print(error.localizedDescription)
                  }
              }
            })
            dataTask.resume()
        
    }
    
    
}
