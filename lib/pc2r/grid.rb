require 'matrix'

module Pc2r
  class Grid
    attr_reader :matrix, :grid_size
    EMPTY_CHAR = '0'

    def initialize(grid_size = 15)
      # TODO copy immutable matrix
      @grid_size = grid_size
      #@rows = Array.new(@grid_size) { Array.new(@grid_size) { EMPTY_CHAR } }
      @matrix = Matrix.build(@grid_size) { EMPTY_CHAR }
      @empty = true
    end

    # @param placement [String]
    def set!(placement)
      if (mot = valid?(placement))
        puts mot.join.delete(EMPTY_CHAR) if mot.respond_to? :join
        @matrix = to_matrix placement
        @empty = false
      else
        raise 'disposition des lettres invalide: espace entre les lettres'
      end
    end

    # @return [String]
    def to_s
      io = StringIO.new
      io.puts '+' + ('-' * @grid_size) + '+'
      @matrix.each_with_index do |elem, row, column|
        io.putc('|') if column == 0
        io.putc ((elem == EMPTY_CHAR) ? ' ' : elem)
        io.putc('|') if column == @grid_size-1
      end
      io.puts '+' + ('-' * @grid_size) + '+'
      io.string
    end

    private
    # @param placement [String]
    def valid?(placement)
      old, new, range, indexes = stat(to_matrix placement).values
      #return new[range].all? { |letter| letter != EMPTY_CHAR } if @empty
      mot = extract_word(old, new, range)
      pp old, new, range, indexes,mot.join
      if range.to_a == indexes
        dif = false
        (0 ... @grid_size).each { |i|
          unless indexes.include? i
            dif = mot if old[i] != EMPTY_CHAR
          end
        }
        @empty ? mot : dif
      else
        mot[range].include?(EMPTY_CHAR) ? false : mot
      end
    end

    # @param old [Array]
    # @param new [Array]
    # @param range [Range]
    # @return [String]
    def extract_word(old, new, range)
      mot = Array.new(@grid_size) { EMPTY_CHAR }
      (range.begin-1 .. 0).each { |i| old[i]!=EMPTY_CHAR ? mot[i] = old[i] : break }
      (range.last+1 .. @grid_size).each { |i| old[i]!=EMPTY_CHAR ? mot[i] = old[i] : break }
      range.each { |i| mot[i] = new[i] }
      mot
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
        {old: @matrix.row(not_nil_rows.first), new: matrix.row(not_nil_rows.first), range: not_nil_cols.first .. not_nil_cols.last, indexes: not_nil_cols}
      elsif not_nil_cols.count == 1
        {old: @matrix.column(not_nil_cols.first), new: matrix.column(not_nil_cols.first), range: not_nil_rows.first .. not_nil_rows.last, indexes: not_nil_rows}
      else
        raise 'disposition des lettres invalide: lettres sur plusieur lignes ou colones'
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