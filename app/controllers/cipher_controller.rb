class CipherController < ApplicationController
  def index
  end

  def encrypt
    @alphabet = params[:alphabet].upcase.gsub(/[^A-Z]/, "")
    @key = params[:key].upcase.gsub(/[^A-Z]/, "")
    @text = params[:text].upcase.gsub(/[^A-Z]/, "")

    @steps = []
    @result = playfair_cipher(@text, @key, @alphabet, :encrypt, @steps)

    @playfair_square = generate_playfair_square(@key, @alphabet)

    render :index
  end

  def decrypt
    @alphabet = params[:alphabet].upcase.gsub(/[^A-Z]/, "")
    @key = params[:key].upcase.gsub(/[^A-Z]/, "")
    @text = params[:text].upcase.gsub(/[^A-Z]/, "")

    @steps = []
    @result = playfair_cipher(@text, @key, @alphabet, :decrypt, @steps)

    @playfair_square = generate_playfair_square(@key, @alphabet)

    render :index
  end

  private

  def playfair_cipher(text, key, alphabet, mode, steps)
    biagrams = create_bigrams(text)
    result_text = ""

    biagrams.each do |bigram|
      step_result = process_bigram(bigram, key, alphabet, mode)
      steps << step_result[:description]
      result_text += step_result[:result]
    end


    result_text
  end

  def create_bigrams(text)
    text.chars.each_slice(2).map { |pair| pair.join }.reject(&:empty?)
  end

  def process_bigram(bigram, key, alphabet, mode)
    square = generate_playfair_square(key, alphabet)

    positions = bigram.chars.map { |char| find_position(char, square) }

    if positions[0][0] == positions[1][0] # В тому ж рядку
      new_positions = mode == :encrypt ? positions.map { |pos| [ pos[0], (pos[1] + 1) % 5 ] } : positions.map { |pos| [ pos[0], (pos[1] - 1) % 5 ] }
    elsif positions[0][1] == positions[1][1] # В тому ж стовпці
      new_positions = mode == :encrypt ? positions.map { |pos| [ (pos[0] + 1) % 5, pos[1] ] } : positions.map { |pos| [ (pos[0] - 1) % 5, pos[1] ] }
    else # Прямокутник
      new_positions = [ [ positions[0][0], positions[1][1] ], [ positions[1][0], positions[0][1] ] ]
    end

    new_bigram = new_positions.map { |pos| square[pos[0]][pos[1]] }.join

    {
      description: "Біграм '#{bigram}' -> #{mode == :encrypt ? 'Зашифровано' : 'Розшифровано'} в '#{new_bigram}'",
      result: new_bigram
    }
  end


  def find_position(char, square)
    square.each_with_index do |row, row_index|
      col_index = row.index(char)
      return [ row_index, col_index ] if col_index
    end
  end

  def generate_playfair_square(key, alphabet)
    combined = (key.chars + alphabet.chars).uniq
    square = combined.each_slice(5).to_a
    square
  end
end
