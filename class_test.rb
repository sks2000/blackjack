
class Test
	attr_accessor :x
	def initialize
		@x = 5
	end

	def f1
		puts x
		x = 10
	end

	def f1
		puts x
		@x = 10
	end
end

test = Test.new
test.f1
puts test.x

test.f2
puts test.x

