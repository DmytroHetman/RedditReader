//
//  CommentDetails.swift
//  RedditComments
//
//  Created by Dmytro Hetman on 18.08.2022.
//

import SwiftUI

struct CommentDetails: View {
    
    var comment: Comment
    
    func shareCommentLink(commentLink: String) {
        guard let commentURL = URL(string: commentLink) else { return }
        let activityVC = UIActivityViewController(activityItems: [commentURL], applicationActivities: nil)
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        windowScene?.keyWindow?.rootViewController?.present(activityVC, animated: true)
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15) {
            Text("Comment Details")
                .font(.headline)
                
            Divider()
            
            HStack {
                Text(comment.username)
                Spacer()
                Text(comment.created)
            }
            
        
            
            Text(comment.body)
                .fixedSize(horizontal: false, vertical: true)
                .font(.footnote)
                .padding(.horizontal, 15)
                
            
            Text("Rating: " + String(comment.rating))
            Divider()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.size.width - 40)
        .background(Color(uiColor: .systemGray4))
        .cornerRadius(15)
        
        
        Button("Share") {
            shareCommentLink(commentLink: "https://www.reddit.com\(comment.permalink)")
        }
        .frame(width: UIScreen.main.bounds.size.width - 20, height: 50, alignment: .center)
        .background(Color(uiColor: .systemGray4))
        .cornerRadius(25)
        .padding(.horizontal, 20)
        
        Spacer()
            
        
    }
}

//struct CommentDetails_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentDetails(comment: CommentRepository(subreddit: "ios", limit: 5, depth: 1, postID: "t3_wli6ud").comments[0])
//    }
//}
