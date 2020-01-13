class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :name
      t.text :text
      t.integer :article_type_id
      t.integer :story_id

      t.timestamps
    end
  end
end
