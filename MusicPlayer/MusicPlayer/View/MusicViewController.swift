//
//  MusicViewController.swift
//  MusicPlayer
//
//  Created by 김기현 on 2020/11/20.
//

import UIKit
import SnapKit

class MusicViewController: UIViewController {
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    private var singer = ""
    private var album = ""
    private var songTitle = ""
    private var duration: Double = 0
    private var image = ""
    private var file = ""
    private var lyrics = ""
    private var lyricsArr: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeConstraint()
        dataLoad()
        // Do any additional setup after loading the view.
    }
    
    private func makeConstraint() {
        self.view.backgroundColor = .black
        songTitleLabel.textColor = .white
        singerLabel.textColor = .white
        
        songTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
        
        singerLabel.snp.makeConstraints { make in
            make.top.equalTo(songTitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        albumImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(60)
            make.trailing.equalToSuperview().offset(-60)
        }
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
            
            self.album = album
            self.duration = duration
            self.file = file
            self.lyricsArr = lyrics.components(separatedBy: "\n").map { String($0) }
            
            self.singerLabel.text = singer
            self.songTitleLabel.text = songTitle
            self.albumImageView.sd_setImage(with: URL(string: image), completed: nil)
            print("lyrics: \(self.lyricsArr)")
        }
    }

}
