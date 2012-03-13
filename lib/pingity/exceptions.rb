module Pingity::Exceptions
  class GeneralException < ::Exception
  end
  
  class NetworkError < GeneralException
  end
end
