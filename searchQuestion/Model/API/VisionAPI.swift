import SwiftUI

// 環境変数から値を取得する関数
func getEnvironmentVariable(named name: String) -> String? {
    let env = ProcessInfo.processInfo.environment
    return env[name]
}

//UIImageをbase64に変換する
func convertImageToBase64(_ image: UIImage) -> String? {
    guard let imageData = image.jpegData(compressionQuality: 1.0) else { return nil }
    return imageData.base64EncodedString()
}

// OpenAI APIにリクエストを送る関数
func VisionApiRequest(image: UIImage) async -> String {
    let prompt = """
You generate the questions. This image contains social issues.

# Output Example
- As an example of the question, how does rain affect people?

# Careful.
- Don't give answers
- Ask unique questions
- A curious point of view
"""
    
    //base64に変換する
    guard let base64_image = convertImageToBase64(image) else{
        return "base64 error"
    }

    // 環境変数からAPIキーとを取得
//    guard let apiKey = getEnvironmentVariable(named: "OPENAI_API_KEY")else {
//        return "API keyが見つかりません"
//    }
    
    let ApiKey = "APIkey"
    
    guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
        return "URL error"
    }
    
    // URLRequestを作成
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    // ヘッダーを設定
    request.setValue("Bearer \(ApiKey)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let payload: [String: Any] = [
                "model": "gpt-4-vision-preview",
                "messages": [
                    [
                    "role": "user",
                    "content": [
                      [
                        "type": "text",
                        "text": "\(prompt)"
                      ],
                      [
                        "type": "image_url",
                        "image_url": [
                            "url": "data:image/jpeg;base64,\(base64_image)"
                        ]
                      ]
                    ]
                  ]
                ],
                "max_tokens":300
        ]
    
    do {
        let payloadData = try JSONSerialization.data(withJSONObject: payload, options: [])
        request.httpBody = payloadData
    } catch {
        print("JSON Serialization error: \(error)")
        return "JSON Serialization error: \(error)"
    }
    
    let payloadData = try! JSONSerialization.data(withJSONObject: payload, options: [])
    request.httpBody = payloadData

    // URLSessionでRequest
    guard let (data, urlResponse) = try? await URLSession.shared.data(for: request) else {
        return "URLSession error"
    }

    // ResponseをHTTPURLResponseにしてHTTPレスポンスヘッダを得る
    guard let httpStatus = urlResponse as? HTTPURLResponse else {
        return "HTTPURLResponse error"
    }

    // BodyをStringに、失敗したらレスポンスコードを返す
    guard let JsonResponse = String(data: data, encoding: .utf8) else {
        print("\(httpStatus.statusCode)")
        return "\(httpStatus.statusCode)"
    }
    print(JsonResponse)

    var response: String?

    if let jsonResponse = String(data: data, encoding: .utf8) {
        do {
            // JSONを解析
            if let json = try JSONSerialization.jsonObject(with: jsonResponse.data(using: .utf8)!, options: []) as? [String: Any],
               let choices = json["choices"] as? [[String: Any]],
               let firstChoice = choices.first,
               let message = firstChoice["message"] as? [String: Any],
               let content = message["content"] as? String {
                response = content
            }
        } catch {
            print("JSON解析エラー: \(error)")
        }
    }

    return response ?? "Content not found"
}
