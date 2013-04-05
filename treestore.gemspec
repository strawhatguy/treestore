Gem::Specification.new do |s|
  s.name        = 'treestore'
  s.version     = '0.1.0'
  s.date        = '2013-04-01'
  s.summary     = "Immutable storage of key values arranged in trees"
  s.description = "treestore stores two different types of data:
1) values, which are stored according to their SHA-1 hashcode
2) trees, which are sets of values and/or other trees, stored via a SHA-1 hashcode

In addition, there are references that allow you to 'bookmark' a SHA-1 hashcode for easier lookup.

If you think of the core git, but on any key-value backend store (like the included Redis one), you've got the right idea.
"
  s.authors     = ["Matthew Curry"]
  s.email       = 'mjcurry@gmail.com'
  s.executables = []
  s.files       = ["lib/treestore.rb", "lib/backend/backend.rb", "lib/backend/redis.rb"]
  s.add_dependency("redis")
end
