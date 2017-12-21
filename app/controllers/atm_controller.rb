class AtmController < ApplicationController
  def dispense
    Atm.dispense(money_attributes)
    render json: Atm.instance.to_json, status: 201
  end


  def withdraw
    instance = Atm.instance
    instance.withdraw(params.require(:amount))
    render json: instance.money_to_give, status: 200
  rescue Atm::NotEnoughMoneyError
    render json: { error: "Not enoght money" }, status: 422

  end
  

  private
  def money_attributes
    params.require(:money).permit(Atm::Money::NOMINALS.keys)
  end

end
