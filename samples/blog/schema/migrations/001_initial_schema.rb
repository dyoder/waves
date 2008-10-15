class InitialSchema < Sequel::Migration

  def up
    create_table :entries do
      primary_key :id
      string :name
      string :title
      text :content
      timestamp :updated_on
    end
  end

  def down
    drop_table :entries
  end

end
