class CreateArticleTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :article_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
