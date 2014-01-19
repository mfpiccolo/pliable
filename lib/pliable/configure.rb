module Pliable
  module Configure

    def configure
      yield self if block_given?
    end

    def added_scrubber(&block)
      Pliable::Ply.send(:define_method, :added_scrubber, &block)
    end
  end
end
