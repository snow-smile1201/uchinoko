module Public::PostsHelper
  def place_holder
    <<-"EOS".strip_heredoc
    子育てのエピソードを記入してください。
    工夫したこと・褒めたり喜んだこと、
    注意したり叱ったこと、
    どんな気持ちでしたか？
    EOS
  end
end
