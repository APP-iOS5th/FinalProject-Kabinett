//
//  UserSelectionViewModel.swift
//  Kabinett
//
//  Created by Song Kim on 8/13/24.
//

import Foundation
import SwiftUI
import Combine

class DummyData: ObservableObject {
    @Published var dummyUsers: [Writer] = [
        Writer(name: "Alice", kabinettNumber: 111111, profileImage: "https://cdn.pixabay.com/photo/2022/06/25/13/33/landscape-7283516_1280.jpg"),
        Writer(name: "Bob", kabinettNumber: 234234, profileImage: nil),
        Writer(name: "Charlie", kabinettNumber: 111112, profileImage: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpxjfCS04oKkgLWiCPCQg026DciIS5ayfvTg&s"),
        Writer(name: "David", kabinettNumber: 111131, profileImage: nil),
        Writer(name: "Eve", kabinettNumber: 111141, profileImage: nil),
        Writer(name: "Frank", kabinettNumber: 111151, profileImage: nil),
        Writer(name: "Grace", kabinettNumber: 111161, profileImage: nil),
    ]
    
    @Published var dummyStationerys: [String] = [
        "https://mblogthumb-phinf.pstatic.net/20160919_30/imyubin__1474262310932ObRLl_PNG/image_7947265321474262300520.png?type=w800",
        "https://mblogthumb-phinf.pstatic.net/20160919_122/imyubin__1474262528136yOuds_PNG/image_6979828871474262466901.png?type=w800",
        "https://mblogthumb-phinf.pstatic.net/20160919_30/imyubin__1474262310932ObRLl_PNG/image_7947265321474262300520.png?type=w800",
        "https://mblogthumb-phinf.pstatic.net/20160919_30/imyubin__1474262310932ObRLl_PNG/image_7947265321474262300520.png?type=w800",
        "https://mblogthumb-phinf.pstatic.net/20160919_30/imyubin__1474262310932ObRLl_PNG/image_7947265321474262300520.png?type=w800",
        "https://mblogthumb-phinf.pstatic.net/20160919_30/imyubin__1474262310932ObRLl_PNG/image_7947265321474262300520.png?type=w800",
        "https://mblogthumb-phinf.pstatic.net/20160919_30/imyubin__1474262310932ObRLl_PNG/image_7947265321474262300520.png?type=w800",
        "https://mblogthumb-phinf.pstatic.net/20160919_30/imyubin__1474262310932ObRLl_PNG/image_7947265321474262300520.png?type=w800",
        "https://mblogthumb-phinf.pstatic.net/20160919_30/imyubin__1474262310932ObRLl_PNG/image_7947265321474262300520.png?type=w800",
        "https://mblogthumb-phinf.pstatic.net/20160919_30/imyubin__1474262310932ObRLl_PNG/image_7947265321474262300520.png?type=w800"
    ]
}
