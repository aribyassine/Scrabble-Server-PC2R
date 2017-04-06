require 'configatron'
require 'config'

module Pc2r
  class Configutation
    def self.load
      Config.load_and_set_settings(File.expand_path('../../../config/settings.yml', __FILE__))

      configatron.dict = File.expand_path("../../../#{Settings.dictuonary.file ||'/assets/ods.txt'}", __FILE__)
      configatron.wiktionary = Settings.dictuonary.wiktionary || false
      configatron.web_dir = File.expand_path("../../../#{Settings.web.dir||'/lib/web/scores'}", __FILE__)
      configatron.web_bind = Settings.web.bind || '0.0.0.0'
      configatron.web_port = Settings.web.port || 8000

      configatron.port = Settings.port || 2017
      configatron.grid_size = Settings.game.grid.size.to_i || 15
      configatron.bag_take = Settings.game.bag.pop.to_i || 7

      # Timers
      configatron.deb = Settings.timers.debut || 20
      configatron.rec = Settings.timers.recherche || 60 * 5
      configatron.sou = Settings.timers.soumission || 60 * 2
      configatron.res = Settings.timers.resultat || 10

      configatron.inter_session_time = Settings.timers.inter_session || 60 * 2

      configatron.bag_letters = Settings.game.bag.letters.to_h || {
          A: 9, B: 2, C: 2, D: 3,
          E: 15, F: 2, G: 2, H: 2,
          I: 8, J: 1, K: 1, L: 5,
          M: 3, N: 6, O: 6, P: 2,
          Q: 1, R: 6, S: 6, T: 6,
          U: 6, V: 2, W: 1, X: 1,
          Y: 1, Z: 1
      }
      configatron.letters_values = Settings.game.scrabble.score.to_h || {
          E: 1, A: 1, I: 1, N: 1, O: 1, R: 1, S: 1, T: 1, U: 1, L: 1,
          D: 2, M: 2, G: 2,
          B: 3, C: 3, P: 3,
          F: 4, H: 4, V: 4,
          J: 8, Q: 8,
          K: 10, W: 10, X: 10, Y: 10, Z: 10,
      }

    end
  end
end