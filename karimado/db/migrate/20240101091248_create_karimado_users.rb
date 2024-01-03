class CreateKarimadoUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :karimado_users do |t|
      t.string :uid, null: false, index: {unique: true}

      t.timestamps
    end
  end
end
