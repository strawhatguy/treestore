require 'rubygems'
require 'digest/sha1'
require 'backend/redis'

class TreeStore
  def initialize(backend=RedisBackend.new)
    raise RuntimeError, "#{backend} is not an appropriate backend" if not backend.kind_of? Backend
    @backend = backend
    @namespace = "tree-store"
  end

  def add(item)
    key = Digest::SHA1.hexdigest(item)
    @backend.addblob(make_object_key(key), item)
    key
  end
  
  def retrieve(key)
    realkey = make_object_key(ref(key) || key)
    @backend.retrieve(realkey)
  end

  def make_tree(keys)
    realkeys = {}
    keys.each do |key|
      realkey = ref(key) || key
      unless exists?(realkey)
        raise RuntimeError, "Can't make tree, no item with key of #{key} or #{realkey} exists, make it first"
      end
      realkeys[realkey] = true
    end

    realkeys = realkeys.keys
    treekey = Digest::SHA1.hexdigest(realkeys.join)
    @backend.addtree(make_object_key(treekey), realkeys)
    treekey
  end

  def ref(name)
    @backend.ref(make_ref_key(name))
  end

  def make_ref(name, key)
    realkey = ref(key) || key
    @backend.make_ref(make_ref_key(name), realkey)
    name
  end

  def delete(key)
    ref = ref(key)
    if ref.nil?
      @backend.delete(make_object_key(key))
    else
      @backend.delete(make_ref_key(key))
    end
  end

  def type(key)
    @backend.type(make_object_key(ref(key) || key))
  end

  def exists?(key)
    @backend.exists?(make_object_key(ref(key) || key))
  end

  private
  
  def make_object_key(key)
    "#{@namespace}:object:#{key}"
  end

  def make_ref_key(key)
    "#{@namespace}:ref:#{key}"
  end
end

