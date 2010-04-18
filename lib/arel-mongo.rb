$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'arel'
require 'mongo'

require 'arel-mongo/util/patches'
require 'arel-mongo/engine'
require 'arel-mongo/relations'
require 'arel-mongo/primitives'
require 'arel-mongo/predicates'
require 'arel-mongo/modifiers'