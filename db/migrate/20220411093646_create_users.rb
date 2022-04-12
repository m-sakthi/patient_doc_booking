class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.boolean :is_patient, default: true
      t.boolean :is_doctor, default: false
      t.boolean :is_admin, default: false
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
