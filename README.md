# RecordList
   
RecordList is a library that implements many-to-many relationships by using an array-type column in a model table.
It does not modify or change the ActiveRecord base classes.

## Compatibility

* Ruby 3.2.0+ (MRI)
* Rails 7.1.0+

## Installation

1. Add `record_list` to your app’s `Gemfile`:

   ```ruby 
   gem 'record_list', '~> 1.0' 

2. Then, in your project directory:

   ```sh 
   $ bundle install

## Usage

1. Add column to ActiveRecord model

   ```ruby
    t.column :tags, :integer, array: true, null: false, default: []

2. Include RecordList module: 
    
   ```ruby
    include RecordList

3. Define relation between models  
    ```ruby 
    record_list :tags, class_name: 'Tag' 

4. If necessary, add a relation from the second model
    ```ruby 
    has_and_belongs_to_record_lists :albums, inverse_of: :tags, class_name: 'Album'

## Example

   ```ruby
   class Album < ApplicationRecord
      include RecordList
      record_list :tags, class_name: 'Tag'
   end

   class Tag < ApplicationRecord
      include RecordList
      has_and_belongs_to_record_lists :albums, inverse_of: :tags, class_name: 'Album'
   end
   ```

## Rspec matchers

RecordList comes with some RSpec matchers which you may find useful:

   ```ruby
   require 'record_list/test/matchers'

   describe Album do
      include RecordList::Test::Matchers
      
      subject { described_class.new }
      
      it { is_expected.to have_record_list(:tags).class_name("Tag") }
   end 

   describe Tag do
      include RecordList::Test::Matchers
      
      subject { described_class.new }
      
      it { is_expected.to have_and_belongs_to_record_lists(:albums).class_name("Tag").inverse_of(:tags) }
   end
   ```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/record_list.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
