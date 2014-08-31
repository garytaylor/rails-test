module Sales
  module ControllerConcern
    extend ActiveSupport::Concern

    private
    def safe_params
      converted_params.permit(:sales => [:date, :code, :value])
    end
    #Converts from the params given to us by the UI to the params that the model expects
    #To allow for future parameters to be added, I am simply merging the date in here (which is the date and time added together) and removing the time field.
    #Also, this normalises the params so that a single item in the 'sales' item is stored in an array the same as multiples
    def converted_params
      return params unless params.key?(:sales)
      my_params = params.clone  #Lets not modify the original
      my_params[:sales] = [params[:sales]] unless params[:sales].is_a?(Array)
      my_params[:sales].each do |sale|
        sale.merge!(:date => sale[:date] + sale.delete(:time))
      end
      my_params
    end
  end
end