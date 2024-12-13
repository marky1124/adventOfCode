# frozen_string_literal: true

# Solve a puzzle from https://adventofcode.com
class Solve
  def initialize
    @answer = 0
    process_file(ARGV[0] || 'in13')
    least_button_presses
    puts "Answer = #{@answer}"
  end

  def process_file(file)
    @claw_machines = []
    ax = ay = bx = by = tx = ty = nil
    File.readlines(file, chomp: true).each do |line|
      case line
      when /Button A: X\+(\d+), Y\+(\d+)/
        ax = ::Regexp.last_match(1).to_i
        ay = ::Regexp.last_match(2).to_i
      when /Button B: X\+(\d+), Y\+(\d+)/
        bx = ::Regexp.last_match(1).to_i
        by = ::Regexp.last_match(2).to_i
      when /Prize: X=(\d+), Y=(\d+)/
        tx = ::Regexp.last_match(1).to_i
        ty = ::Regexp.last_match(2).to_i
        @claw_machines << [ax, ay, bx, by, tx, ty]
      end
    end
  end

  def least_button_presses
    @claw_machines.each do |ax, ay, bx, by, tx, ty|
      # Max number of button presses for A (maxa) and B (maxb)
      maxa = 100
      maxa = (tx / ax) if (tx / ax) < maxa
      maxa = (ty / ay) if (ty / ay) < maxa
      maxb = 100
      maxb = (tx / bx) if (tx / bx) < maxb
      maxb = (ty / by) if (ty / by) < maxb

      # Given equations ax*a + bx*b = tx
      #             and ay*a + by*b = ty
      # We multiply each by the total of the other to give us
      #     ty*ax*a + ty*bx*b = tx*ty = tx*ay*a + tx*by*b
      # Re-arranging for a on one side and b on the other gives us
      #     (tx*ay - ty*ax) * a = (tx*by - ty*bx) * b
      # a simple numa*a = numb*b which when solved means we have a solution
      numa = (ay * tx) - (ax * ty)
      numb = (bx * ty) - (by * tx)

      # Looking for numa * num_of_A_presses = numb * num_of_B_presses
      cheapest_answer = nil
      (1..maxa).each do |a|
        minb = [(tx - (a * ax)) / bx, (ty - (a * ay)) / by].max
        (minb..maxb).each do |b|
          if (numa * a) == (numb * b)
            tokens = (a * 3) + b
            cheapest_answer = tokens if cheapest_answer.nil? || tokens < cheapest_answer
          end
        end
      end

      @answer += cheapest_answer if cheapest_answer
    end
  end
end

Solve.new
