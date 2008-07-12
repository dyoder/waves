class InitialSchema < ActiveRecord::Migration

  def self.up
    create_table :entries do |t|
      t.text :name
      t.text :title
      t.text :summary
      t.text :content
    end
  end

  def self.down
    drop_table :entries
  end

end
