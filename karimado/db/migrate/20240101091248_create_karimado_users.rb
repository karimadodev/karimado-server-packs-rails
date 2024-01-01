class CreateKarimadoUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :karimado_users do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
