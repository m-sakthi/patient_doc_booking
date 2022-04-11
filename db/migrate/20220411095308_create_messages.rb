class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.text :body
      t.references :outbox, null: false, foreign_key: true
      t.references :inbox, null: false, foreign_key: true
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
