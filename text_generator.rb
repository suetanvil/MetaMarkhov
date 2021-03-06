class TextGenerator
  def initialize(data)
    @data = data
  end

  def generate(minimum_word_count)
    words = []
    word = nil
    until words.count >= minimum_word_count && terminal?(word)
      word = follow(word)
      append_word(words, word)
    end
    words.join(" ")
  end

  def follow(word)
    return starting_word if word.nil?
    select_word(@data.fetch(word))
  end

  private

  def select_word(weighted_list)
    value = Kernel.rand
    weighted_list.each do |(word, weighting)|
      value -= weighting
      return word if value < 0
    end
    weighted_list.last.first
  end

  # kind of a lame way, perhaps we could go by how
  # frequently words start sentences?
  def starting_word
    @data.keys.sample
  end
  
  def terminal?(word)
    [".", "?", "!"].include?(word)
  end

  def punctuation?(word)
    [".", "?", "!", ","].include?(word)
  end

  def append_word(words, word)
    if punctuation?(word)
      words.last << word
    else
      words << word
    end
  end
end
