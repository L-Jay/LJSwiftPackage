//
//  LJNetwork.swift
//
//
//  Created by 崔志伟 on 2023/4/27.
//

import Foundation
import Alamofire

// MARK: - LJNetwork

public enum LJNetwork {
    public static var baseUrl: String = "" {
        didSet {}
    }

    public static var codeKey: String?
    public static var successCode = 200
    public static var messageKey: String?

    public static var headers = [String: String]()
    public static var defaultParams = [String: Any]()

    public static func get<T>(
        _ urlOrPath: String,
        params: [String: Any]? = nil,
        extraHeaders: [String: String]? = nil,
        autoParse: Bool = true,
        success: @escaping (T) -> Void,
        failure: @escaping (LJNetworkError) -> Void
    ) {
        request(
            urlOrPath,
            method: .GET,
            params: params,
            extraHeaders: extraHeaders,
            autoParse: autoParse,
            success: success,
            failure: failure
        )
    }

    public static func post<T>(
        _ urlOrPath: String,
        params: [String: Any]? = nil,
        extraHeaders: [String: String]? = nil,
        autoParse: Bool = true,
        success: @escaping (T) -> Void,
        failure: @escaping (LJNetworkError) -> Void
    ) {
        request(
            urlOrPath,
            method: .POST,
            params: params,
            extraHeaders: extraHeaders,
            autoParse: autoParse,
            success: success,
            failure: failure
        )
    }

    public static func request<T>(
        _ urlOrPath: String,
        method: LJHTTPMethod,
        params: [String: Any]? = nil,
        extraHeaders: [String: String]? = nil,
        autoParse: Bool = true,
        success: @escaping (T) -> Void,
        failure: @escaping (LJNetworkError) -> Void
    ) {
        guard !autoParse || (codeKey != nil && messageKey != nil) else {
            debugPrint("请设置LJNetwork codekey、messageKey")
            return
        }

        var url = ""
        if urlOrPath.hasPrefix("http") || urlOrPath.hasPrefix("https") {
            url = urlOrPath
        } else {
            url = baseUrl + urlOrPath
        }

        let finalParams = defaultParams.merging(params ?? [:]) { _, new in new }
        let headers = headers.merging(extraHeaders ?? [:]) { _, new in new }

        AF.request(
            url,
            method: HTTPMethod(rawValue: method.rawValue),
            parameters: finalParams,
            headers: HTTPHeaders(headers)
        )
        .responseString { response in
            switch response.result {
            case let .success(jsonString):
                debugPrint("\(jsonString)")
            case let .failure(error):
                debugPrint(error)
            }
        }
        .responseData { response in
            switch response.result {
            case let .success(jsonData):
                debugPrint("\(jsonData)")
                do {
                    let dict = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! [String: Any]

                    if autoParse {
                        let code = dict[codeKey!] as? Int

                        if code == nil || code == successCode {
                            if let tType = T.self as? Decodable.Type {
                                let model = try JSONDecoder().decode(tType, from: jsonData) as! T
                                success(model)
                            } else {
                                success(dict as! T)
                            }
                        } else {
                            debugPrint(response.debugDescription)
                            if let bodyData = response.request?.httpBody {
                                let str = String(data: bodyData, encoding: String.Encoding.utf8)
                                debugPrint("request parmas:\(str ?? "")")
                            }
                            failure(LJNetworkError(
                                code: code ?? 10002,
                                message: dict[messageKey!] as? String ?? "",
                                url: response.response?.url?.absoluteString ?? ""
                            ))
                        }
                    } else {
                        success(dict as! T)
                    }
                } catch {
                    let nsError = error as NSError
                    failure(LJNetworkError(
                        code: nsError.code,
                        message: "JSON解析失败",
                        url: response.response?.url?.absoluteString ?? ""
                    ))
                }
            case let .failure(error):
                debugPrint(response.debugDescription)
                failure(LJNetworkError(
                    code: error.responseCode ?? 10000,
                    message: error.localizedDescription,
                    url: error.url?.absoluteString ?? response.response?.url?.absoluteString ?? ""
                ))
            }
        }
    }
}

// MARK: - LJHTTPMethod

public enum LJHTTPMethod: String {
    case GET, POST, PUT, DELETE
}

// MARK: - LJNetworkError

public struct LJNetworkError: Error {
    var code: Int
    var message: String
    var url: String
}
