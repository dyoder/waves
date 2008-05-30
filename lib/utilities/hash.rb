class Hash

  def stringify_keys
    inject({}) do |options, (key, value)|
      options[key.to_s] = value
      options
    end
  end

  # Destructively convert all keys to symbols.
  def symbolize_keys!
    keys.each do |key|
      unless key.is_a?(Symbol)
        self[key.to_sym] = self[key]
        delete(key)
      end
    end
    self
  end


end