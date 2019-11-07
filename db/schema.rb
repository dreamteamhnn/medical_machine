# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20191107045931) do

  create_table "admins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "blog_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_blog_categories_on_slug"
  end

  create_table "blog_category_relations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.bigint "blog_id"
    t.bigint "blog_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blog_category_id"], name: "index_blog_category_relations_on_blog_category_id"
    t.index ["blog_id"], name: "index_blog_category_relations_on_blog_id"
  end

  create_table "blog_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "title"
    t.string "url"
    t.text "description"
    t.string "caption"
    t.string "alt"
    t.bigint "blog_id"
    t.boolean "is_feature"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blog_id"], name: "index_blog_images_on_blog_id"
  end

  create_table "blog_tag_relations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.bigint "blog_id"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blog_id"], name: "index_blog_tag_relations_on_blog_id"
    t.index ["tag_id"], name: "index_blog_tag_relations_on_tag_id"
  end

  create_table "blogs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "title"
    t.bigint "template_id"
    t.text "content"
    t.boolean "is_important", default: false
    t.bigint "blog_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "relation_blog_id_1"
    t.integer "relation_blog_id_2"
    t.boolean "is_service"
    t.string "slug"
    t.integer "order"
    t.index ["blog_category_id"], name: "index_blogs_on_blog_category_id"
    t.index ["slug"], name: "index_blogs_on_slug", unique: true
    t.index ["template_id"], name: "index_blogs_on_template_id"
  end

  create_table "brands", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "name"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "home_order"
    t.string "image"
    t.text "description"
    t.string "slug"
    t.index ["slug"], name: "index_brands_on_slug", unique: true
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "name"
    t.integer "level"
    t.integer "category_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "home_block_id"
    t.integer "home_order_id"
    t.text "description"
    t.string "slug"
    t.string "img"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "category_relations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.integer "parent_id"
    t.integer "children_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ckeditor_assets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "companies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.text "about"
    t.string "phone"
    t.string "work_time"
    t.string "email"
    t.string "facebook"
    t.string "instagram"
    t.string "contact_info"
    t.text "hn_address"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.float "hn_map_lat", limit: 24
    t.float "hn_map_lng", limit: 24
    t.string "contact_name"
    t.string "logo"
    t.string "logo_title"
    t.string "logo_alt"
    t.string "watermark"
    t.string "sg_address"
    t.float "sg_map_lat", limit: 24
    t.float "sg_map_lng", limit: 24
    t.string "order_phone"
    t.string "sg_phone"
    t.string "hn_phone"
  end

  create_table "custom_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "name"
    t.string "custom_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customer_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.bigint "product_id"
    t.string "customer_name"
    t.string "phone_number"
    t.string "email"
    t.string "shipping_address"
    t.string "billing_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_customer_orders_on_product_id"
  end

  create_table "feedbacks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "name"
    t.text "company"
    t.string "position"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar"
  end

  create_table "fields", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "name"
    t.integer "product_field_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "menu_order"
    t.text "description"
    t.string "slug"
    t.index ["slug"], name: "index_fields_on_slug", unique: true
  end

  create_table "folders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendly_id_slugs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "image_url"
    t.integer "imageable_id"
    t.string "imageable_type"
    t.integer "folder_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "desc"
    t.string "caption"
    t.string "alt"
  end

  create_table "labels", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "title"
    t.string "short_title"
    t.integer "block_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "media", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "title"
    t.text "description"
    t.string "url"
    t.integer "media_type"
    t.integer "field_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "product_id"
    t.string "video_url"
    t.integer "custom_category_id"
    t.index ["custom_category_id"], name: "index_custom_category_id"
  end

  create_table "product_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.bigint "product_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "home_order"
    t.integer "list_order"
    t.index ["category_id"], name: "index_product_categories_on_category_id"
    t.index ["product_id"], name: "index_product_categories_on_product_id"
  end

  create_table "product_fields", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.bigint "product_id"
    t.bigint "field_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "list_order"
    t.index ["field_id"], name: "index_product_fields_on_field_id"
    t.index ["product_id"], name: "index_product_fields_on_product_id"
  end

  create_table "product_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "title"
    t.string "url"
    t.text "desc"
    t.string "caption"
    t.string "alt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_media_relations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.bigint "product_id"
    t.bigint "medium_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medium_id"], name: "index_product_media_relations_on_medium_id"
    t.index ["product_id"], name: "index_product_media_relations_on_product_id"
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.bigint "brand_id"
    t.bigint "label_id"
    t.text "name"
    t.text "model"
    t.text "location"
    t.integer "price"
    t.integer "discount_price"
    t.text "product_type"
    t.text "description"
    t.text "short_description"
    t.integer "label_order"
    t.integer "category_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "home_order"
    t.text "parameter"
    t.boolean "is_parameter_table"
    t.string "slug"
    t.string "img_1"
    t.string "img_2"
    t.string "img_1_title"
    t.string "img_1_desc"
    t.string "img_1_caption"
    t.string "img_1_alt"
    t.string "img_2_title"
    t.string "img_2_desc"
    t.string "img_2_caption"
    t.string "img_2_alt"
    t.integer "no_order"
    t.string "meta_title"
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["label_id"], name: "index_products_on_label_id"
    t.index ["slug"], name: "index_products_on_slug", unique: true
  end

  create_table "slider_catalogs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "title"
    t.string "url"
    t.text "desc"
    t.text "caption"
    t.text "alt"
    t.string "image_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link"
    t.integer "home_order"
  end

  create_table "subcribers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.string "title"
    t.string "phone"
    t.text "content"
  end

  create_table "tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "name"
    t.string "tag_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "templates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  add_foreign_key "blog_category_relations", "blog_categories"
  add_foreign_key "blog_category_relations", "blogs"
  add_foreign_key "blog_images", "blogs"
  add_foreign_key "blog_tag_relations", "blogs"
  add_foreign_key "blog_tag_relations", "tags"
  add_foreign_key "customer_orders", "products"
  add_foreign_key "product_categories", "categories"
  add_foreign_key "product_categories", "products"
  add_foreign_key "product_fields", "fields"
  add_foreign_key "product_fields", "products"
  add_foreign_key "product_media_relations", "media"
  add_foreign_key "product_media_relations", "products"
  add_foreign_key "products", "brands", on_delete: :cascade
  add_foreign_key "products", "labels"
end
