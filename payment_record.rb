require 'date'

class PaymentRecord
  attr_reader :date, :goods, :price
  def self.parse(time_stamp:, content_str:)
    date = Time.at(time_stamp.to_i, in: "+09:00").to_datetime
    m = content_str.match(/^\s*([^　 0123456789]+)?[　 ]?([0-9]+)/)
    raise("データ[#{content_str}]は、PaymentRecordとしてparseできません。") unless m
    goods = m[1] || 'ご飯'
    price = m[2].to_i
    return self.new(date: date, goods: goods, price: price)
  end

  def initialize(date:, goods:, price:)
    @date = date
    @goods = goods
    @price = price
  end
end
