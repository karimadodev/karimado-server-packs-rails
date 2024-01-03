class CreateKarimadoUserSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :karimado_user_sessions do |t|
      t.string :access_token_base, null: false, index: {unique: true}
      t.string :refresh_token_base, null: false, index: {unique: true}

      t.references :user, null: false, foreign_key: false

      t.timestamps
    end
  end
end
