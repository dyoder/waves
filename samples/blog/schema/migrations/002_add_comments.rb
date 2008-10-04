class AddComments < Sequel::Migration

  def up
    create_table :comments do
      primary_key :id
      foreign_key :entry_id, :table => :entries
      string :name
      string :email
      text :content
      timestamp :updated_on
    end
  end

  def down
    drop_table :comments
  end

end
