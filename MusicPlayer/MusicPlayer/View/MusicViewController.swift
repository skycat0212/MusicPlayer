//
//  MusicViewController.swift
//  MusicPlayer
//
//  Created by 김기현 on 2020/11/20.
//

import UIKit
import SnapKit
import AVFoundation

class MusicViewController: UIViewController {
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    private var audioPlayer: AVAudioPlayer?
    
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
//        self.view.backgroundColor = .black
//        songTitleLabel.textColor = .white
//        singerLabel.textColor = .white
//        minLabel.textColor = .white
//        maxLabel.textColor = .white
        
        songTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
        }
        
        singerLabel.snp.makeConstraints { make in
            make.top.equalTo(songTitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        albumImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(60)
            make.trailing.equalToSuperview().offset(-60)
            make.top.equalTo(singerLabel.snp.bottom).offset(-self.view.bounds.height / 2)
        }
        
        timeSlider.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-200)
            make.leading.equalToSuperview().offset(60)
            make.trailing.equalToSuperview().offset(-60)
        }
        
        minLabel.snp.makeConstraints { make in
            make.top.equalTo(timeSlider).offset(50)
            make.leading.equalToSuperview().offset(60)
        }
        
        maxLabel.snp.makeConstraints { make in
            make.top.equalTo(timeSlider).offset(50)
            make.trailing.equalToSuperview().offset(-60)
        }
    }
    
    private func dataLoad() {
        NetworkRequest.shared.request { [weak self] (response: MusicModel) in
            guard let self = self,
                  let singer = response.singer,
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
            
            self.timeSlider.minimumValue = Float(0)
            self.timeSlider.maximumValue = Float(self.duration)
            
            let time = self.timeSlider.maximumValue
            let minute = Int(time) / 60
            let second = Int(time) % 60
            
            self.setTimeLabel(minute: minute, second: second)
            
        }
    }
    
    private func setTimeLabel(minute: Int, second: Int) {
        var components = DateComponents()
        components.setValue(minute, for: .minute)
        components.setValue(second, for: .second)
        
        if let date = Calendar.current.date(from: components) {
            let formatter = DateFormatter()
            formatter.dateFormat = "mm:ss"
            self.minLabel.text = "00:00"
            self.maxLabel.text = "\(formatter.string(from: date))"
        }
    }

}
