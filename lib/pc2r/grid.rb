require 'matrix'

module Pc2r
  class Grid

    attr_reader :matrix, :grid_size
    EMPTY_CHAR = '0'

    def initialize(grid_size = configatron.grid_size)
      @grid_size = grid_size
      @matrix = Matrix.build(@grid_size) { EMPTY_CHAR }
      @empty = true
    end

    # @param placement [String]
    def set!(placement)
      if valid? placement
        word = extract_word placement
        raise "le mot <#{word}> n'est pas dans le dictionnaire" unless word.exist_in_dictuonary?
        @matrix = to_matrix placement
        @empty = false
        word
      else
        raise 'disposition des lettres invalide'
      end
    end

    # @param placement [String]
    def letters_used(placement)
      matrix = to_matrix placement
      dif = Set.new
      @matrix.each_with_index do |elem, row, column|
        dif << matrix[row, column] if elem != matrix[row, column]
      end
      dif
    end

    # @return [String]
    def to_s
      io = StringIO.new
      @matrix.each { |elem| io.putc elem }
      io.s
    end

    # @return [String]
    def pretty
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

    # @param placement [String]
    def valid?(placement)
      old, new, range, indexes = stat(to_matrix placement)
      if range.to_a == indexes #prefix ou suffix
        return true if @empty
        (0 ... @grid_size).each { |i|
          unless indexes.include? i
            return true if old[i] != EMPTY_CHAR
          end
        }
        false
      else
        !new[range].include?(EMPTY_CHAR)
      end
    end

    # @param placement [String]
    # @return [String]
    def extract_word(placement)
      old, new, range = stat(to_matrix placement)
      word = Array.new(@grid_size) { EMPTY_CHAR }
      (range.begin-1).downto(0) { |i| old[i]!=EMPTY_CHAR ? word[i] = old[i] : break }
      (range.last+1 ... @grid_size).each { |i| old[i]!=EMPTY_CHAR ? word[i] = old[i] : break }
      range.each { |i| word[i] = new[i] }
      word.join.delete EMPTY_CHAR
    end

    private
    # @param matrix [Matrix]
    # @return [Array]
    def stat(matrix)
      dif = difference matrix
      not_nil_rows, not_nil_cols = [], []
      @grid_size.times do |x|
        not_nil_rows << x unless dif.row(x).all? { |e| e.nil? }
        not_nil_cols << x unless dif.column(x).all? { |e| e.nil? }
      end
      row_index, col_index = not_nil_rows.first, not_nil_cols.first
      row_count, col_count =not_nil_rows.count, not_nil_cols.count
      if row_count == 1 && not_nil_cols.count == 1 # one letter added
        if @matrix.row(row_index - 1)[col_index] != EMPTY_CHAR || @matrix.row(row_index + 1)[col_index] != EMPTY_CHAR
          [@matrix.column(col_index), matrix.column(col_index), not_nil_rows.first .. not_nil_rows.last, not_nil_rows]
        elsif @matrix.column(col_index - 1)[row_index] != EMPTY_CHAR || @matrix.column(col_index + 1)[row_index] != EMPTY_CHAR
          [@matrix.row(row_index), matrix.row(row_index), not_nil_cols.first .. not_nil_cols.last, not_nil_cols]
        else
          raise 'disposition des lettres invalide: la lettre n\'est rattacher a aucun mot '
        end
      elsif row_count == 1
        [@matrix.row(row_index), matrix.row(row_index), not_nil_cols.first .. not_nil_cols.last, not_nil_cols]
      elsif col_count == 1
        [@matrix.column(col_index), matrix.column(col_index), not_nil_rows.first .. not_nil_rows.last, not_nil_rows]
      else
        raise 'disposition des lettres invalide: pas de nouvelle lettre' if row_count == 0 && col_count == 0
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