require 'tty-reader'
require 'io/console'

def start_game
    puts "Pi Digits Practice v0.0.1"
    puts "Press any key when you're ready to start."
    puts "-----------------------------------------"
    STDIN.getch
    print "\r"
    game_loop
end

def game_loop
  digitsGuessed = 0 # Increments every time the user makes a correct guess.
  reader = TTY::Reader.new # Reads input from tty so we can evaluate right or wrong as we go.

  # Using Rabinowitz and Wagon's spigot algorithm.
  pi_digits = Enumerator.new do |y|
    q, r, t, k, n, l = 1, 0, 1, 1, 3, 3
    loop do
      if 4 * q + r - t < n * t
        y << n 
        nr = 10 * (r - n * t)
        n = ((10 * (3 * q + r)) / t) - 10 * n
        q *= 10
        r = nr
      else
        nr = (2 * q + r) * l
        nn = (q * (7 * k + 2) + r * l) / (t * l)
        q *= k
        t *= l
        l += 2
        k += 1
        n = nn
        r = nr
      end
    end
  end

  print "#{pi_digits.next}."
  loop {
      current_pi = pi_digits.next
      next_digit = reader.read_char.to_i # Doesn't matter if we get something wrong as it'll eject the player anyway.
      if next_digit != current_pi
          puts "\nThat's wrong, the correct digit is: #{current_pi}"
          break
      else
          digitsGuessed += 1
          print next_digit
      end
  }
  puts "Game over. You got #{digitsGuessed} digits of pi."

  if(File.exist?("highscore")) 
    scoreFile = File.read("highscore").split
    oldHighScore = scoreFile[0].to_i # Gives us something meaningless if it's not an actual number, so it would set a new high score anyway.
    if digitsGuessed > oldHighScore
      File.write("highscore", digitsGuessed)
      puts "Very nice work, that's a new high score!"
    end
  else 
    File.write("highscore", digitsGuessed)
  end
end

start_game