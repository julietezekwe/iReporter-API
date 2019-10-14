class AddReporterToComments < ActiveRecord::Migration[5.2]
  def change
    add_reference :comments, :reporter, foreign_key: true
  end
end
