genres = [
  {id: 1, name: "勉強"},
  {id: 2, name: "スポーツ"},
  {id: 3, name: "芸術"},
  {id: 4, name: "食育"},
  {id: 5, name: "しつけ"}
]

genres.each do |genre|
  Genre.find_or_create_by(genre)
end