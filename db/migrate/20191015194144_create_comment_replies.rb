class CreateCommentReplies < ActiveRecord::Migration[5.2]
  def change
    create_table :comment_replies do |t|
      t.text :body
      t.references :reporter, foreign_key: true
      t.references :comment, foreign_key: true

      t.timestamps
    end
  end
end
