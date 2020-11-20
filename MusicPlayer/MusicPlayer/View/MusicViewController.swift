//
//  MusicViewController.swift
//  MusicPlayer
//
//  Created by 김기현 on 2020/11/20.
//

import UIKit

class MusicViewController: UIViewController {
    
    private var singer = ""
    private var album = ""
    private var songTitle = ""
    private var duration = 0
    private var image = ""
    private var file = ""
    private var lyrics = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        dataLoad()
        // Do any additional setup after loading the view.
    }
    
    private func dataLoad() {
        NetworkRequest.shared.request { (response: MusicModel) in
            guard let singer = response.singer,
                  let album = response.album,
                  let songTitle = response.title,
                  let duration = response.duration,
                  let image = response.image,
                  let file = response.file,
                  let lyrics = response.lyrics else { return }
            
            self.singer = singer
            self.album = album
            self.songTitle = songTitle
            self.duration = duration
            self.image = image
            self.file = file
            self.lyrics = lyrics
        }
    }

}
