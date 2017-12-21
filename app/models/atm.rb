class Atm < ApplicationRecord
  NOMINALS = {
    ones: 1,
    twos: 2,
    fives: 5,
    tens: 10,
    quarters: 25,
    fifties: 50,
    hundreds: 100,
  }.freeze

  def self.dispense(money_attributes)
    create(money_attributes)
  end

  def self.instance
    order(created_at: :desc).limit(1).first
  end

  attr_accessor :remainder

  def withdraw(amount)
    self.remainder = amount
    try_to_give(:hundreds)
    try_to_give(:fifties)
    try_to_give(:quarters)
    try_to_give(:tens)
    try_to_give(:fives)
    try_to_give(:twos)
    try_to_give(:ones)

    if remainder == 0
      self.class.create(self.attributes.without('id', 'created_at'))
    else
      raise
    end
  end
  

  def try_to_give(name)
    number = remainder / NOMINALS[name]
    if send(name) > number
      send("#{name}=", send(name) - number)
      self.remainder = remainder % NOMINALS[name]
    else
      self.remainder = remainder - send(name)*NOMINALS[name]
      send("#{name}=", 0)
    end

  end

end
