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
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var lyricsTableView: UITableView!
    
    private var audioPlayer: AVAudioPlayer?
    var time: TimeInterval = 0
    
    private var singer = ""
    private var album = ""
    private var songTitle = ""
    private var duration: Double = 0
    private var image = ""
    private var file = ""
    private var lyrics = ""
    private var lyricsArr: [String] = []
    private var lyricsDict: [(Float, String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("bound width: \(UIScreen.main.nativeBounds.width)")
        print("bound height: \(UIScreen.main.nativeBounds.height)")
        print("frame width: \(self.view.frame.width)")
        print("frame height: \(self.view.frame.height)")
        
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
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
        }
        
        singerLabel.snp.makeConstraints { make in
            make.top.equalTo(songTitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(singerLabel.snp.height)
        }

        albumImageView.snp.makeConstraints { make in
            make.top.equalTo(singerLabel.snp.bottom).offset(20)
            make.leading.equalTo(80)
            make.trailing.equalTo(-80)
            make.height.equalTo(self.albumImageView.snp.width)
        }
        
        lyricsTableView.snp.makeConstraints { make in
            make.top.equalTo(albumImageView.snp.bottom)
            make.leading.equalTo(80)
            make.trailing.equalTo(-80)
            make.bottom.equalTo(progressView.snp.top).offset(-20)
        }
        
        progressView.progress = 0
        progressView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-self.view.bounds.height / 5)
            make.leading.equalTo(60)
            make.trailing.equalTo(-60)
        }
        
        minLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(60)
        }
        
        maxLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-60)
        }
        
        playButton.setImage(UIImage(named: "play"), for: .normal)
        playButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-50)
            make.top.equalTo(playButton.snp.bottom).offset(-50)
            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
            make.width.equalTo(self.playButton.snp.height)
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
            self.lyricsArr = lyrics.components(separatedBy: ["[", "]", "\n"]).map { String($0) }
            for i in 0..<self.lyricsArr.count {
                if i % 3 == 0 { continue }
                if i % 3 == 2 {
                    let num = self.lyricsArr[i-1].split(separator: ":").map { Float($0)! }
                    self.lyricsDict.append((num[0] * 60 + num[1] + num[2] / 1000, self.lyricsArr[i]))
                }
            }
            
            self.singerLabel.text = singer
            self.songTitleLabel.text = """
                                        \(songTitle)
                                        (\(album))
                                        """
            self.albumImageView.sd_setImage(with: URL(string: image), completed: nil)
            print("lyrics: \(self.lyricsArr)")
            print("lyricsDict: \(self.lyricsDict)")
            
            let time = self.duration
            let minute = Int(time) / 60
            let second = Int(time) % 60
            
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
    
    private func setTimeLabel(minute: Int, second: Int) {
        var components = DateComponents()
        components.setValue(minute, for: .minute)
        components.setValue(second, for: .second)
        
        if let date = Calendar.current.date(from: components) {
            let formatter = DateFormatter()
            formatter.dateFormat = "mm:ss"
            self.minLabel.text = "\(formatter.string(from: date))"
//            self.maxLabel.text = "\(formatter.string(from: date))"
        }
    }
    
    // MARK: - Audio 재생 관련 함수
    @IBAction func playAudioClick(_ sender: UIButton) {
        guard let url = URL(string: file) else { return }
        if sender.currentImage == UIImage(named: "play") {
            print("starttime: \(time)")
            downloadFileFromUrl(url: url)
            playButton.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            audioPlayer?.stop()
            time = audioPlayer!.currentTime
            print("pausetime: \(time)")
            playButton.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    
    private func downloadFileFromUrl(url: URL) {
        var downloadTask: URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url) { (url, response, error) in
            if let error = error {
                print("Download Error: \(error)")
            } else {
                guard let url = url else { return }
                self.play(url: url)
            }
        }
        
        downloadTask.resume()
    }
    
    private func play(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            guard let audioPlayer = audioPlayer else { return }
            
            audioPlayer.currentTime = self.time
            audioPlayer.play(atTime: audioPlayer.deviceCurrentTime)
            
            DispatchQueue.main.async {
                Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateProgressView), userInfo: nil, repeats: true)
//                self.progressView.setProgress(Float(audioPlayer.currentTime) / Float(audioPlayer.duration), animated: true)
            }
        } catch let error as NSError {
            print("Play Error: \(error)")
        } catch {
            print("AVAudioPlayer init failed")
        }
    }

    @objc func updateProgressView() {
        guard let audioPlayer = audioPlayer else { return }
        if audioPlayer.isPlaying {
            progressView.setProgress(Float(audioPlayer.currentTime) / Float(audioPlayer.duration), animated: true)
            let minute = Int(audioPlayer.currentTime) / 60
            let second = Int(audioPlayer.currentTime) % 60
            
            setTimeLabel(minute: minute, second: second)
        } else {
//            playButton.setImage(UIImage(named: "play"), for: .normal)
        }
    }
}

extension MusicViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        progressView.progress = 0
        minLabel.text = "00:00"
    }
}
