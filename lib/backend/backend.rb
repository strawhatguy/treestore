class Backend
  def initialize
    raise NotImplementedError, "must instantiate a specific type of backend"
  end

  def retrieve(key)
    raise NotImplementedError, "must instantiate a specific type of backend"
  end

  def addblob(value)
    raise NotImplementedError, "must instantiate a specific type of backend"
  end

  def addtree(keys)
    raise NotImplementedError, "must instantiate a specific type of backend"
  end

  def ref(name)
    raise NotImplementedError, "must instantiate a specific type of backend"
  end

  def make_ref(name, key)
    raise NotImplementedError, "must instantiate a specific type of backend"
  end

  def delete(key)
    raise NotImplementedError, "must instantiate a specific type of backend"
  end

  def exists?(key)
    raise NotImplementedError, "must instantiate a specific type of backend"
  end

  def type(key)
    raise NotImplementedError, "must instantiate a specific type of backend"
  end
end

