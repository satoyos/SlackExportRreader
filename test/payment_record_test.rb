require 'minitest/autorun'
require_relative '../payment_record'

class TestPaymentRecord < Minitest::Test
  def test_initialize_with全角区切り
    record = PaymentRecord.new(date_str: "2011-05-01", content_str: "おやつ　90")
    assert_equal(record.date.year, 2011)
    assert_equal(record.goods, "おやつ")
    assert_equal(record.price, 90)
  end

  def test_init_with半角区切り
    record = PaymentRecord.new(date_str: "2011-05-01", content_str: "定期代 43430")
    assert_equal(record.goods, "定期代")
    assert_equal(record.price, 43430)
  end
end