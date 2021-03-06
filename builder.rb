# Build the Markhov chain generator


class WordEntry
  attr_reader :word

  def initialize(word)
    @word = word
    @counts = {}
  end

  def followedBy(word)
    @counts[word] = 0 unless @counts.has_key?(word)
    @counts[word] += 1
  end

  def normalizedCounts
    total = totalCounts() + 0.0

    result = @counts.keys.map {|k| [k, @counts[k]] }
    result.sort! {|a, b| a[1] <=> b[1]}
    result.map! {|entry| [entry[0], entry[1]/total]}

    return result
  end

  def totalCounts
    return @counts.values.inject(0) {|memo, cnt| memo + cnt}
  end

  # Return the list (sorted) of words following this word
  def followers
    result = @counts.keys.sort! {|a, b| a <=> b}
  end

  private

end


class MCBuilder
  def initialize()
    @words = {}
  end

  def addWordPair(firstWord, secondWord)
    entry = entryFor(firstWord)
    entry.followedBy(secondWord)
  end

  def extrude(filename)
    filename += '.rb' unless filename.end_with?('.rb')

    bigHash = createDataHash()
    writeBigHash(bigHash, filename)
  end

  #
  # Queries for testing (mostly):
  #

  def knows?(word)
    return @words.has_key?(word)
  end

  def followers(word)
    return [] unless @words[word]
    return @words[word].followers
  end

  private

  def entryFor(theWord)
    @words[theWord] = WordEntry.new(theWord) unless @words.has_key?(theWord)
    return @words[theWord]
  end

  def createDataHash
    result = {}

    for k in @words.keys
      result[k] = @words[k].normalizedCounts()
    end

    return result
  end

  def writeBigHash(bigHash, filename)
    # Code goes here
  end
end

