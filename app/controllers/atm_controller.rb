class AtmController < ApplicationController
  def dispense
    Atm.dispense(money_attributes)
    render json: Atm.instance.to_json, status: 201
  end

  private
  def money_attributes
    params.require(:money).permit(Atm::NOMINALS.keys)
  end
end
