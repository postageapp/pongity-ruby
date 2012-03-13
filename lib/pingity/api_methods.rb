module Pingity::ApiMethods
  def sample_push(path, value)
    api_call(
      :sample_push,
      :path => path,
      :value => value
    )
  end
end
