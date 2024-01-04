class CreateKarimadoUserSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :karimado_user_sessions do |t|
      t.string :public_id, null: false, index: {unique: true}
      t.string :access_token_base, null: false
      t.string :refresh_token_base, null: false
      t.datetime :discarded_at, index: true

      t.references :user, null: false, foreign_key: false

      t.timestamps
    end
  end
end
