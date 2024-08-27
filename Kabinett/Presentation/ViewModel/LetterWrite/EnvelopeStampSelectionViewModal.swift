//
//  EnvelopeStampSelectionViewModal.swift
//  Kabinett
//
//  Created by Song Kim on 8/27/24.
//

import Foundation
import SwiftUI

class EnvelopeStampSelectionViewModal: ObservableObject {
    @Published var dummyEnvelopes: [String] = [
        "https://postfiles.pstatic.net/MjAxODAzMDNfMjEz/MDAxNTIwMDQyMTEwNDIz.5VmOjx84M8Z39Bym-LC9fHRseOw8TBNRzaTx1poYm2Yg.hZ88aZCRcD7dFk1R35FD9LcAe3tbYiw-2CjenFvb45Eg.PNG.osy2201/11_%28%ED%9A%8C%EC%83%89_1%29_%ED%9A%8C%EC%83%89_%EB%8B%A8%EC%83%89_%EB%B0%B0%EA%B2%BD%ED%99%94%EB%A9%B4_180303.png?type=w3840",
        "https://postfiles.pstatic.net/MjAxODAzMDNfMTc5/MDAxNTIwMDQxNzQwODYx.qQDg_PbRHclce0n3s-2DRePFQggeU6_0bEnxV8OY1yQg.4EZpKfKEOyW_PXOVvy7wloTrIUzb71HP8N2y-YFsBJcg.PNG.osy2201/1_%2835%ED%8D%BC%EC%84%BC%ED%8A%B8_%ED%9A%8C%EC%83%89%29_%ED%9A%8C%EC%83%89_%EB%8B%A8%EC%83%89_%EB%B0%B0%EA%B2%BD%ED%99%94%EB%A9%B4_180303.png?type=w966",
        "https://postfiles.pstatic.net/MjAxODAzMDNfMjEz/MDAxNTIwMDQyMTEwNDIz.5VmOjx84M8Z39Bym-LC9fHRseOw8TBNRzaTx1poYm2Yg.hZ88aZCRcD7dFk1R35FD9LcAe3tbYiw-2CjenFvb45Eg.PNG.osy2201/11_%28%ED%9A%8C%EC%83%89_1%29_%ED%9A%8C%EC%83%89_%EB%8B%A8%EC%83%89_%EB%B0%B0%EA%B2%BD%ED%99%94%EB%A9%B4_180303.png?type=w3840",
        "https://postfiles.pstatic.net/MjAxODAzMDNfMjEz/MDAxNTIwMDQyMTEwNDIz.5VmOjx84M8Z39Bym-LC9fHRseOw8TBNRzaTx1poYm2Yg.hZ88aZCRcD7dFk1R35FD9LcAe3tbYiw-2CjenFvb45Eg.PNG.osy2201/11_%28%ED%9A%8C%EC%83%89_1%29_%ED%9A%8C%EC%83%89_%EB%8B%A8%EC%83%89_%EB%B0%B0%EA%B2%BD%ED%99%94%EB%A9%B4_180303.png?type=w3840",
        "https://postfiles.pstatic.net/MjAxODAzMDNfMjEz/MDAxNTIwMDQyMTEwNDIz.5VmOjx84M8Z39Bym-LC9fHRseOw8TBNRzaTx1poYm2Yg.hZ88aZCRcD7dFk1R35FD9LcAe3tbYiw-2CjenFvb45Eg.PNG.osy2201/11_%28%ED%9A%8C%EC%83%89_1%29_%ED%9A%8C%EC%83%89_%EB%8B%A8%EC%83%89_%EB%B0%B0%EA%B2%BD%ED%99%94%EB%A9%B4_180303.png?type=w3840",
        "https://postfiles.pstatic.net/MjAxODAzMDNfMjEz/MDAxNTIwMDQyMTEwNDIz.5VmOjx84M8Z39Bym-LC9fHRseOw8TBNRzaTx1poYm2Yg.hZ88aZCRcD7dFk1R35FD9LcAe3tbYiw-2CjenFvb45Eg.PNG.osy2201/11_%28%ED%9A%8C%EC%83%89_1%29_%ED%9A%8C%EC%83%89_%EB%8B%A8%EC%83%89_%EB%B0%B0%EA%B2%BD%ED%99%94%EB%A9%B4_180303.png?type=w3840"
    ]
    
    @Published var dummpStamps: [String] = [
    "https://cdn-icons-png.flaticon.com/256/4481/4481191.png",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcToaQupjlrXtCckBSuufHyena8ZgQ_CRxOxRw&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcToaQupjlrXtCckBSuufHyena8ZgQ_CRxOxRw&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcToaQupjlrXtCckBSuufHyena8ZgQ_CRxOxRw&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcToaQupjlrXtCckBSuufHyena8ZgQ_CRxOxRw&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcToaQupjlrXtCckBSuufHyena8ZgQ_CRxOxRw&s"
    ]
    
}
