$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'arel'
require 'mongo'

require 'arel-mongo/util/patches'
require 'arel-mongo/util/mongo'
require 'arel-mongo/core_extensions/array'
require 'arel-mongo/core_extensions/hash'
require 'arel-mongo/core_extensions/object'
require 'arel-mongo/attributes'
require 'arel-mongo/engine'
require 'arel-mongo/relations'
require 'arel-mongo/primitives'
require 'arel-mongo/predicates'
require 'arel-mongo/modifiers'
require 'arel-mongo/formatters'