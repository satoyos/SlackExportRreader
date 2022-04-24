require 'date'

class PaymentRecord
  attr_reader :date, :goods, :price
  def initialize(date_str:, content_str:)
    @date = Date.parse(date_str)
    m = content_str.match(/^\s*([^　 ]+)[　 ]+([0-9]+)/)
    @goods = m[1]
    @price = m[2].to_i
  end
end
