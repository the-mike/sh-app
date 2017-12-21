class Atm < ApplicationRecord
  def self.dispense(money_attributes)
    create(money_attributes)
  end

  def self.instance
    order(created_at: :desc).limit(1).first
  end

  attr_accessor :remainder

  def withdraw(amount)
    self.remainder = amount
    try_to_give_hundreds
    try_to_give_fifties
    try_to_give_quarters
    try_to_give_tens
    try_to_give_fives
    try_to_give_twos
    try_to_give_ones

    if remainder == 0
      self.class.create(self.attributes.without('id', 'created_at'))
    else
      raise
    end
  end
  
  def try_to_give_hundreds
    number = remainder / 100
    if hundreds > number
      self.hundreds = hundreds - number
      self.reminder = remainder % 100
    else
      self.remainder = remainder - hundreds*100
      self.hundreds = 0
    end
  end

  def try_to_give_fifties
    number = remainder / 50
    if fifties > number
      self.fifties = fifties - number
      self.remainder = remainder % 50
    else
      self.remainder = remainder - fifties*50
      self.fifties = 0
    end
  end

  def try_to_give_quarters
    number = remainder / 25
    if quarters > number
      self.quarters = quarters - number
      self.remainder = remainder % 25
    else
      self.remainder = remainder - quarters*25
      self.quarters = 0
    end
  end

  def try_to_give_tens
    number = remainder / 10
    if tens > number
      self.tens = tens - number
      self.remainder = remainder % 10
    else
      self.remainder = remainder - tens*10
      self.tens = 0
    end
  end

  def try_to_give_fives
    number = remainder / 5
    if fives > number
      self.fives = fives - number
      self.remainder = remainder % 5
    else
      self.remainder = remainder - fives*5
      self.fives = 0
    end
  end

  def try_to_give_twos
    number = remainder / 2
    if twos > number
      self.twos = twos - number
      self.remainder = remainder % 2
    else
      self.remainder = remainder - twos*2
      self.twos = 0
    end
  end

  def try_to_give_ones
    number = remainder
    if ones > number
      self.ones = ones - number
      self.remainder = remainder % 2
    else
      self.remainder = remainder - ones*2
      self.ones = 0
    end
  end

end
