class InitialSchema < Sequel::Migration

  def up
    create_table :entries do
      primary_key :id
      text :name
      text :title
      text :summary
      text :content
    end
  end

  def down
    drop_table :entries
  end

end
