class Atm
  class Money
    include ActiveModel::Model

    NOMINALS = {
      ones: 1,
      twos: 2,
      fives: 5,
      tens: 10,
      quarters: 25,
      fifties: 50,
      hundreds: 100,
    }.freeze

    def self.attribute_names
      NOMINALS.keys
    end

    attr_accessor *NOMINALS.keys

    def initialize(attributes = {})
      attributes = NOMINALS.keys.each_with_object({}) do |nominal, hash|
        hash[nominal] = attributes[nominal] || 0
      end
      super attributes
    end

    def +(other)
      attributes = NOMINALS.keys.each_with_object({}) do |nominal, hash|
        hash[nominal] = send(nominal) + other.send(nominal)
      end
      self.class.new(attributes)
    end

    def -(other)
      attributes = NOMINALS.keys.each_with_object({}) do |nominal, hash|
        hash[nominal] = send(nominal) - other.send(nominal)
      end
      self.class.new(attributes)
    end

    def ==(other)
      NOMINALS.keys.reject { |nominal| send(nominal) == other.send(nominal) }.empty?
    end
  end
end
