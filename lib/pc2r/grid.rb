require 'matrix'

module Pc2r
  class Grid
    attr_reader :matrix, :grid_size
    EMPTY_CHAR = '0'

    def initialize(grid_size = 15)
      @grid_size = grid_size
      #@rows = Array.new(@grid_size) { Array.new(@grid_size) { EMPTY_CHAR } }
      @matrix = Matrix.build(@grid_size) { EMPTY_CHAR }
      @empty = true
    end

    # @param placement [String]
    def set!(placement)
      if (word = valid?(placement))
        raise "le mot <#{word}> n'est pas dans le dictionnaire" unless word.exist_in_dictuonary?
        @matrix = to_matrix placement
        @empty = false
        word
      else
        raise 'disposition des lettres invalide'
      end
    end

    # @return [String]
    def to_s
      io = StringIO.new
      io.puts '+' + ('-' * @grid_size) + '+'
      @matrix.each_with_index do |elem, row, column|
        io.putc('|') if column == 0
        io.putc ((elem == EMPTY_CHAR) ? ' ' : elem)
        io.puts('|') if column == @grid_size-1
      end
      io.puts '+' + ('-' * @grid_size) + '+'
      io.string
    end

    private
    # @param placement [String]
    def valid?(placement)
      # TODO refactor plusbesoin de mot
      old, new, range, indexes = stat(to_matrix placement)
      word = extract_word(old, new, range)
      if range.to_a == indexes
        dif = false
        (0 ... @grid_size).each { |i|
          unless indexes.include? i
            dif = word if old[i] != EMPTY_CHAR
          end
        }
        @empty ? word : dif
      else
        new[range].include?(EMPTY_CHAR) ? false : word
      end
    end

    # @param old [Array]
    # @param new [Array]
    # @param range [Range]
    # @return [String]
    def extract_word(old, new, range)
      word = Array.new(@grid_size) { EMPTY_CHAR }
      (range.begin-1).downto(0) { |i| old[i]!=EMPTY_CHAR ? word[i] = old[i] : break }
      (range.last+1 ... @grid_size).each { |i| old[i]!=EMPTY_CHAR ? word[i] = old[i] : break }
      range.each { |i| word[i] = new[i] }
      word.join.delete EMPTY_CHAR
    end

    # @param matrix [Matrix]
    # @return [Hash]
    def stat(matrix)
      dif = difference matrix
      not_nil_rows, not_nil_cols = [], []
      @grid_size.times do |x|
        not_nil_rows << x unless dif.row(x).all? { |e| e.nil? }
        not_nil_cols << x unless dif.column(x).all? { |e| e.nil? }
      end
      if not_nil_rows.count == 1
        [@matrix.row(not_nil_rows.first), matrix.row(not_nil_rows.first), not_nil_cols.first .. not_nil_cols.last, not_nil_cols]
      elsif not_nil_cols.count == 1
        [@matrix.column(not_nil_cols.first), matrix.column(not_nil_cols.first), not_nil_rows.first .. not_nil_rows.last, not_nil_rows]
      else
        raise 'disposition des lettres invalide: pas de nouvelle lettre' if not_nil_rows.count == 0 && not_nil_cols.count == 0
        raise 'disposition des lettres invalide: lettres sur plusieur lignes et colones'
      end
    end

    # @param matrix [Matrix]
    # @return [Matrix]
    def difference(matrix)
      rows = Array.new(@grid_size) { Array.new(@grid_size) { nil } }
      @matrix.each_with_index do |elem, row, column|
        rows[row][column] = matrix[row, column] if elem != matrix[row, column]
      end
      Matrix.rows(rows)
    end

    # transforme la chaine de caractere +placement+ en objet Matrix
    # @param placement [String]
    # @return [Matrix]
    def to_matrix(placement)
      raise "Le placement donné doit être une chaîne de #{@grid_size ** 2} characters" if placement.length != @grid_size ** 2
      Matrix.build(@grid_size) { |row, col| placement[row * @grid_size + col] }
    end

  end
end