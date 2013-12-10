class Fish
attr_reader :amount,:limit
  def initialize(amount)
    @amount = amount
    @limit = 72
  end

  def rot
    @limit -= 1
  end

  def limit_gage
    str = ""
    (@limit/6).times do
      str += "|"
    end
    str
  end

end