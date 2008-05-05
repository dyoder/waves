class AddComments < Sequel::Migration

  def up
    create_table :comments do
      primary_key :id
      foreign_key :entry_id, :table => :entries
      text :name
      text :email
      text :conten
      timestamp :created_on
    end
  end

  def down
    drop_table :comments
  end

end
