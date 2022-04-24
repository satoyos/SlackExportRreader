# require 'minitest/autorun'

# class TestHelloWorld < Minitest::Test
#   def test_何も指定されていない場合は規定の挨拶を返す
#     assert_equal('Hello from Ruby', hello_world)
#   end

#   def test_指定された名前で挨拶を返す
#     assert_equal('Hello from VSCode', hello_world('VSCode'))
#   end
# end

def hello_world(name = 'Ruby')
  "Hello from #{name}"
end
