# Treestore

An implementation of the key-value store similar to git's internal
mechanism. Uses redis as the actual store, but other backends could be
developed.

Essentially, there are two objects: trees and blobs. Blobs contain raw
data. Trees contain only references to other trees and/or blobs. In
this manner, trees can reference each other.

No versioning as been implemented yet.

# Install
`gem install treestore`

# API
### class TreeStore
**initialize**(backend=RedisBackend.new)

Return a new instance of a treestore

**add**(item)

Create a new blob with data in *item*, return its key.

**retrieve**(key)

Retrieve the blob or tree stored at *key*, and return the data (if
*key* was a blob) or the list of keys of the children (if *key* was a
tree)

**make_tree**(keys)

Pass of list of keys, which can be either trees or blobs, and create a
new tree with those keys as children. Return the key of the
newly-created tree.

**ref**(name)

Return the key referenced by *name*.

**make_ref**(name, key)

Create a new reference name, that, if **retrieve** (see above), will
fetch the value stored at *key*

**delete**(key)

Delete *key*. Be careful to clean up all references and trees that
point to this *key* too!

**type**(key)

Returns :tree if *key* stores a tree, :blob otherwise

**exists?**(key)

Does *key* exist in the store? Returns true or false

# Example
```
irb> require 'treestore'
=> true

irb> t = TreeStore.new
=> #<TreeStore:0x007f8d2a980a58 @backend=#<RedisBackend:0x007f8d2a980a30 @redis=#<Redis client v3.1.0 for redis://127.0.0.1:6379/0>>, @namespace="tree-store">

irb> t.add("foo")
=> "0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33"

irb> a = _
=> "0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33"

irb> items = [a]
=> ["0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33"]

irb> items << t.add("bar")
=> ["0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33", "62cdb7020ff920e5aa642c3d4066950dd1f01f4d"]

irb> tree = t.make_tree(items)
=> "3eb4e0e693987b4bcb871a44e943b7223b5dd2e5"

irb> t.retrieve(tree)
=> ["62cdb7020ff920e5aa642c3d4066950dd1f01f4d", "0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33"]

irb> t.retrieve(t.retrieve(tree).first)
=> "bar"

irb> t.retrieve(t.retrieve(tree)[1])
=> "foo"

irb> t.type(tree)
=> :tree

irb> t.type(t.retrieve(tree)[1])
=> :blob

irb> t.retrieve(tree)[1]
=> "0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33"

irb> t.retrieve(t.retrieve(tree)[1])
=> "foo"

irb> t.make_ref("foo's name", t.retrieve(tree)[1])
=> "foo's name"

irb> t.retrieve("foo's name")
=> "foo"

irb> t.ref("foo's name")
=> "0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33"

irb> t.type("foo's name")
=> :blob

```
