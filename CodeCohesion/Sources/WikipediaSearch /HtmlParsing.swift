//
//  HtmlParsing.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/11.
//

import Foundation

//html <img> tag로 넘어오는걸 url로 바꿔주나보다
func parseImageURLsfromHTML(_ html: NSString) throws -> [URL]  {
    let regularExpression = try NSRegularExpression(pattern: "<img[^>]*src=\"([^\"]+)\"[^>]*>", options: [])
    
    let matches = regularExpression.matches(in: html as String, options: [], range: NSMakeRange(0, html.length))
    
    return matches.map { match -> URL? in
        if match.numberOfRanges != 2 {
            return nil
        }
        
        let url = html.substring(with: match.range(at: 1))
        
        var absoluteURLString = url
        if url.hasPrefix("//") {
             absoluteURLString = "http:" + url
        }
        
        return URL(string: absoluteURLString)
    }.filter { $0 != nil }.map { $0! }
}

func parseImageURLsfromHTMLSuitableForDisplay(_ html: NSString) throws -> [URL] {
    return try parseImageURLsfromHTML(html).filter {
        //range(of:)
        //문자열 내에서 주어진 문자열이 처음 나타나는 범위를 찾아 반환합니다.
        $0.absoluteString.range(of: ".svg.") == nil
        
        /*
         SVG(Scalable Vector Graphic)는 무엇인가?
         2차원 벡터 그래픽을 표현하기 위한 XML 기반의 파일 형식입니다.
         백터 이미지는 특성상 확대를 해도 픽셀이 깨지지 않기 때문에 웹 사이트, 모바일 등에서 많이 사용됩니다.
         
         PDF vs SVG
         PDF 파일은 Xcode 6, iOS 8, OS X 10.9 부터 지원이 됩니다.
         반면 SVG는 iOS 13, iPadOS 13, or macOS 10.15 부터 지원이 됩니다.
         둘 다 벡터 방식입니다.
         SVG와 PDF 파일의 결과는 이미지 종류와, 자료의 디테일, export 구성에 따라 달라지기 떄문에 무엇이 더 좋다고 말하기 힘듭니다.
         단, 대부분의 경우에서 SVG가 PDF보다 사이즈가 작습니다.
         또, 웹 개발에 있어서 SVG가 많이 사용되고 이에 최적화 되어 있는 것을 찾을 수 있습니다.
         */
    }
}
