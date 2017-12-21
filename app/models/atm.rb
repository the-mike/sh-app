class Atm < ApplicationRecord
  class NotEngoughtMoney < StandardError

  end

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
    new_atm = new(money_attributes).tap do |new_instance|
      NOMINALS.keys.each do |nominal|
        new_instance.send("#{nominal}=", new_instance.send(nominal) + instance.send(nominal))
      end
    end
    new_atm.save
    new_atm
  end

  def self.instance
    order(created_at: :desc).limit(1).first || null_object
  end

  def self.null_object
    new.tap do |new_instance|
      NOMINALS.keys.each do |nominal|
        new_instance.send("#{nominal}=", 0)
      end
    end
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
      raise NotEngoughtMoney
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
