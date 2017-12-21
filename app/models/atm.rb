class Atm < ApplicationRecord
  class NotEnoughMoneyError < StandardError
  end

  def self.dispense(money_attributes)
    money_to_dispense = Money.new(money_attributes)
    money_in_atm = instance.money_in_machine
    gt = money_in_atm + money_to_dispense
    new(money_in_machine: gt).persist
  end

  def self.instance
    loaded_instance = order(created_at: :desc).limit(1).first || new
    loaded_instance.money_in_machine = Money.new(loaded_instance)
    loaded_instance
  end

  def persist
    Atm::Money.attribute_names.each do |item|
      self.send("#{item}=", money_in_machine.send(item))
    end
    save
  end


  attr_accessor :remainder
  attr_accessor :money_to_give
  attr_accessor :money_in_machine

  def withdraw(amount)
    self.remainder = amount
    self.money_to_give = Money.new
    try_to_give(:hundreds)
    try_to_give(:fifties)
    try_to_give(:quarters)
    try_to_give(:tens)
    try_to_give(:fives)
    try_to_give(:twos)
    try_to_give(:ones)

    if remainder == 0
      self.class.new(money_in_machine: money_in_machine, withdraw_amount: amount).persist
    else
      raise NotEnoughMoneyError
    end
  end

  def try_to_give(name)
    number = remainder / Money::NOMINALS[name]
    notes_in_machine = money_in_machine.send(name)
    number_to_take = notes_in_machine > number ? number : notes_in_machine
    handle_money name, number_to_take
  end

  private
  def handle_money(name, amount)
    handle_money_to_give name, amount
    handle_money_in_machine name, amount
    handle_remainder name, amount
  end

  def handle_remainder(name, amount)
    self.remainder = remainder - amount * Money::NOMINALS[name]
  end

  def handle_money_to_give(name, amount)
    self.money_to_give = money_to_give + get_money_object(name, amount)
  end

  def handle_money_in_machine(name, amount)
    self.money_in_machine = money_in_machine - get_money_object(name, amount)
  end

  def get_money_object(name, number)
    h = {}
    h[name] = number
    Money.new(h)
  end

end
