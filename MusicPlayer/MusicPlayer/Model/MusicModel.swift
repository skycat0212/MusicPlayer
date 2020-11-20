//
//  MusicData.swift
//  MusicPlayer
//
//  Created by 김기현 on 2020/11/20.
//

import Foundation

struct MusicModel: Codable {
    let singer: String?
    let album: String?
    let title: String?
    let duration: Int?
    let image: String?
    let file: String?
    let lyrics: String?
}
