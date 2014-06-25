cats = Category.where(ancestry: nil).order :id

cats[0].update_attributes alt_text: "A gaming session", question: "What kinds of games do you play?"
cats[1].update_attributes alt_text: "Playing sports", question: "What sports do you play?"
cats[2].update_attributes alt_text: "An outdoor adventure", question: "What kinds of outdoor activities do you like?"
cats[3].update_attributes alt_text: "Listening to music", question: "What kinds music do you listen to?"
cats[4].update_attributes alt_text: "Watching TV", question: "What kinds shows do you watch?"
cats[5].update_attributes alt_text: "Watching a movie", question: "What kinds of movies do you watch?"