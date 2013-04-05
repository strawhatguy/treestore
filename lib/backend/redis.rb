require 'redis'
require File.expand_path(File.dirname(__FILE__)) + '/backend'

class RedisBackend < Backend
  def initialize(redis=nil)
    @redis = redis || Redis.new
  end

  def retrieve(key)
    type = @redis.type(key)

    case type
    when "string"
      @redis.get(key)
    when "set"
      @redis.smembers(key)
    end
  end

  def addblob(key, value)
    @redis.set(key, value)
  end

  def addtree(treekey, keys)
    @redis.sadd(treekey, keys)
  end
  
  def ref(name)
    @redis.get(name)
  end

  def make_ref(name, key)
    @redis.set(name, key)
  end

  def delete(key)
    @redis.del(key)
  end

  def exists?(key)
    @redis.exists(key)
  end

  def type(key)
    case @redis.type(key)
    when "string"
      :blob
    when "set"
      :tree
    end
  end
end


