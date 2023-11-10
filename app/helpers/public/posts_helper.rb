module Public::PostsHelper
  def place_holder
    <<-"EOS".strip_heredoc
    子育てのエピソードを記入してください。
    工夫したこと・褒めたり喜んだこと、
    注意したり叱ったこと、
    どんな気持ちでしたか？

    "#"をつけることで、ハッシュタグを設定できます。
    EOS
  end
  #ハッシュタグにリンクを挿入する
  def render_with_hashtags(body)
    body.gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/){|word| link_to word, "/post/hashtag/#{word.delete("#")}"}.html_safe
  end
end
