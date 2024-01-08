class CreateKarimadoUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :karimado_users do |t|
      t.string :public_id, null: false, index: {unique: true}
      t.string :uid, null: false, index: {unique: true}
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
