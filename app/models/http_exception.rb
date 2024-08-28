class HttpException < StandardError
    attr_reader :error_code
  
    def initialize(error_code, message = nil)
      super(message)
      @error_code = error_code
    end
end