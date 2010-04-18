$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'arel-mongo'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  config.before do
    db = ::Mongo::Connection.new('localhost', 27017).db('test')
    Arel::Collection.engine = Arel::Mongo::Engine.new(db)
  end
end