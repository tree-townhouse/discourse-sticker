# frozen_string_literal: true

class CreateStickerPackModels < ActiveRecord::Migration[7.2]
  def change
    create_table :discourse_sticker_sticker_packs do |t|
      t.bigint :owner_id, null: false
      t.bigint :current_revision_id
      t.string :slug, null: false, limit: 80
      t.timestamps
    end

    create_table :discourse_sticker_sticker_pack_revisions do |t|
      t.bigint :sticker_pack_id, null: false
      t.bigint :created_by_id, null: false
      t.bigint :cover_upload_id
      t.integer :version, null: false
      t.integer :status, null: false, default: 0
      t.string :title, null: false, limit: 120
      t.text :description
      t.datetime :published_at
      t.timestamps
    end

    create_table :discourse_sticker_stickers do |t|
      t.bigint :sticker_pack_revision_id, null: false
      t.bigint :upload_id, null: false
      t.string :name, null: false, limit: 80
      t.integer :position, null: false
      t.timestamps
    end

    add_index :discourse_sticker_sticker_packs, :slug, unique: true
    add_index :discourse_sticker_sticker_packs, :owner_id
    add_index :discourse_sticker_sticker_packs, :current_revision_id

    add_index :discourse_sticker_sticker_pack_revisions,
              %i[sticker_pack_id version],
              unique: true,
              name: "idx_sticker_pack_revisions_pack_version"
    add_index :discourse_sticker_sticker_pack_revisions, %i[sticker_pack_id status]
    add_index :discourse_sticker_sticker_pack_revisions, :created_by_id
    add_index :discourse_sticker_sticker_pack_revisions, :cover_upload_id

    add_index :discourse_sticker_stickers,
              %i[sticker_pack_revision_id name],
              unique: true,
              name: "idx_stickers_revision_name"
    add_index :discourse_sticker_stickers,
              %i[sticker_pack_revision_id position],
              unique: true,
              name: "idx_stickers_revision_position"
    add_index :discourse_sticker_stickers, :upload_id

    add_foreign_key :discourse_sticker_sticker_pack_revisions,
                    :discourse_sticker_sticker_packs,
                    column: :sticker_pack_id
    add_foreign_key :discourse_sticker_stickers,
                    :discourse_sticker_sticker_pack_revisions,
                    column: :sticker_pack_revision_id
    add_foreign_key :discourse_sticker_sticker_packs,
                    :discourse_sticker_sticker_pack_revisions,
                    column: :current_revision_id
  end
end
