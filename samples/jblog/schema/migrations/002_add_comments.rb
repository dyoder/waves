class AddComments < ActiveRecord::Migration

  def self.up
    create_table :comments do |t|
      t.integer :entry_id
     t.text :name
     t.text :email
     t.text :content
     t.datetime :updated_on
    end
  end

  def self.down
    drop_table :comments
  end

end
