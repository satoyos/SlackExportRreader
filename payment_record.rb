class PaymentRecord
  attr_reader :date, :goods, :price
  def initialize(time_stamp:, content_str:)
    @date = Time.at(time_stamp.to_i, in: "+09:00")
    m = content_str.match(/^\s*([^　 ]+)[　 ]+([0-9]+)/)
    @goods = m[1]
    @price = m[2].to_i
  end
end
