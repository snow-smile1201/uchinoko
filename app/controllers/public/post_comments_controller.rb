class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :detect_inapporopriate_comment, only: [:create]

  def create
    @post = Post.find(params[:post_id])
    comment = current_user.post_comments.new(post_comment_params)
    comment.post_id = @post.id
    comment.score = Language.get_data(post_comment_params[:comment])
    comment.save
  end

  def destroy
    @post = Post.find(params[:post_id])
    comment = PostComment.find(params[:id])
    comment.destroy
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment, :is_banned, :score)
  end

  def detect_inapporopriate_comment
    score = Language.get_data(post_comment_params[:comment])
    if score < 0
      redirect_to request.referer, alert: "ネガティブな内容が含まれているため投稿できません。"
    end
  end
end
