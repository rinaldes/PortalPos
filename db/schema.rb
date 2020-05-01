# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151206014605) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apps_updaters", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "areas", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bank_accounts", force: true do |t|
    t.string   "name"
    t.string   "account_number"
    t.string   "bank_name"
    t.string   "branch"
    t.integer  "supplier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "city"
  end

  create_table "beats", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "distrik_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "branch_prices", force: true do |t|
    t.integer  "branch_id"
    t.integer  "product_id"
    t.float    "nominal"
    t.float    "percentage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "branches", force: true do |t|
    t.string   "branch_name"
    t.string   "description"
    t.string   "warehouse"
    t.string   "contact_person"
    t.integer  "departement_id"
    t.string   "phone_number"
    t.string   "fax_number"
    t.string   "mobile_phone"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brands", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cash_in_cash_outs", force: true do |t|
    t.float    "cash_value"
    t.string   "description"
    t.integer  "jurnal_id"
    t.integer  "number_id"
    t.date     "transaction_date"
    t.string   "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tipe"
  end

  create_table "categories", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "division_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "province_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "colours", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "colours", ["code"], name: "index_colours_on_code", using: :btree
  add_index "colours", ["name"], name: "index_colours_on_name", using: :btree

  create_table "contact_people", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "pinbb"
    t.string   "email"
    t.integer  "supplier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
  end

  create_table "discount_hargas", force: true do |t|
    t.string   "code"
    t.integer  "min"
    t.integer  "max"
    t.string   "jenis"
    t.float    "percent"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "discount_id"
  end

  create_table "discount_products", force: true do |t|
    t.string   "sku_id"
    t.integer  "min"
    t.integer  "max"
    t.float    "percent"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "discount_id"
  end

  create_table "discounts", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.date     "start"
    t.date     "end"
    t.string   "pilihan"
    t.string   "multi"
    t.string   "flag"
    t.integer  "batas"
    t.integer  "multi_persen"
    t.integer  "multi_nilai"
    t.string   "cakupan"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "distributors", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "address"
    t.string   "telp1"
    t.string   "telp2"
    t.string   "email"
    t.string   "fax"
    t.integer  "area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "distriks", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "distributor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "divisions", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "principal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "edc_machines", force: true do |t|
    t.string   "bank_name"
    t.string   "branch"
    t.string   "edc_serial_number"
    t.string   "account_number"
    t.string   "owner"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feature_names", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "module_name"
  end

  create_table "features", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id"
    t.integer  "feature_name_id"
  end

  create_table "good_transfer_details", force: true do |t|
    t.integer  "size"
    t.integer  "quantity"
    t.integer  "origin_store_id"
    t.integer  "good_transfer_id"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "barcode"
    t.string   "description"
  end

  add_index "good_transfer_details", ["code"], name: "index_good_transfer_details_on_code", using: :btree
  add_index "good_transfer_details", ["good_transfer_id"], name: "index_good_transfer_details_on_good_transfer_id", using: :btree
  add_index "good_transfer_details", ["origin_store_id"], name: "index_good_transfer_details_on_origin_store_id", using: :btree
  add_index "good_transfer_details", ["quantity"], name: "index_good_transfer_details_on_quantity", using: :btree
  add_index "good_transfer_details", ["size"], name: "index_good_transfer_details_on_size", using: :btree

  create_table "good_transfers", force: true do |t|
    t.integer  "origin_branch_id"
    t.integer  "destination_branch_id"
    t.string   "status"
    t.date     "transfer_date"
    t.integer  "receiver_id"
    t.date     "received_date"
    t.string   "code"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "no_surat_jalan"
  end

  add_index "good_transfers", ["code"], name: "index_good_transfers_on_code", using: :btree
  add_index "good_transfers", ["destination_branch_id"], name: "index_good_transfers_on_destination_branch_id", using: :btree
  add_index "good_transfers", ["origin_branch_id"], name: "index_good_transfers_on_origin_branch_id", using: :btree
  add_index "good_transfers", ["received_date"], name: "index_good_transfers_on_received_date", using: :btree
  add_index "good_transfers", ["receiver_id"], name: "index_good_transfers_on_receiver_id", using: :btree
  add_index "good_transfers", ["status"], name: "index_good_transfers_on_status", using: :btree
  add_index "good_transfers", ["transfer_date"], name: "index_good_transfers_on_transfer_date", using: :btree
  add_index "good_transfers", ["user_id"], name: "index_good_transfers_on_user_id", using: :btree

  create_table "histories", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shop_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "counter"
  end

  create_table "import_data", force: true do |t|
    t.string   "file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_type"
  end

  create_table "item_receipt_details", force: true do |t|
    t.integer  "item_id"
    t.integer  "item_receipt_id"
    t.float    "price"
    t.integer  "receipt_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_receipt_payments", force: true do |t|
    t.string   "account_bank_destination"
    t.string   "account_bank_source"
    t.string   "account_branch_destination"
    t.string   "account_branch_source"
    t.string   "account_name_destination"
    t.string   "account_name_source"
    t.string   "account_number_destination"
    t.string   "account_number_source"
    t.integer  "cashier_id"
    t.integer  "item_receipt_id"
    t.float    "nominal"
    t.float    "pay_left"
    t.date     "payment_date"
    t.string   "payment_number"
    t.integer  "payment_type"
    t.integer  "supplier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cashier_name"
  end

  create_table "item_receipts", force: true do |t|
    t.string   "description"
    t.float    "discountNominal"
    t.date     "due_date"
    t.integer  "employee_id"
    t.float    "nett"
    t.integer  "paid"
    t.integer  "payment_type"
    t.string   "po_number"
    t.date     "receipt_date"
    t.string   "receipt_number"
    t.string   "receiver_name"
    t.integer  "retur"
    t.integer  "supplier_id"
    t.float    "tax"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kecamatans", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kelurahans", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "kecamatan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "licenses", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "used"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "jumlah"
  end

  create_table "m2classes", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "mclass_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "m3classes", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "m2class_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "m4classes", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "m3class_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "m_classes", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "level"
  end

  add_index "m_classes", ["code"], name: "index_m_classes_on_code", using: :btree
  add_index "m_classes", ["name"], name: "index_m_classes_on_name", using: :btree

  create_table "mclasses", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "department_id"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", force: true do |t|
    t.integer  "active"
    t.string   "address_home"
    t.string   "barcode"
    t.date     "birth_date"
    t.string   "birth_place"
    t.string   "code"
    t.float    "credit_limit"
    t.float    "discountpercent"
    t.string   "email"
    t.string   "foto"
    t.string   "noidentitas"
    t.integer  "identity_type"
    t.integer  "jenis"
    t.integer  "member_category_id"
    t.integer  "member_group_id"
    t.string   "mobile"
    t.string   "name"
    t.string   "npwp_alamat"
    t.string   "npwp_nama"
    t.string   "npwp_no"
    t.string   "occupation"
    t.string   "phone"
    t.integer  "pin"
    t.integer  "point_used"
    t.date     "registration_date"
    t.string   "religion"
    t.string   "sex"
    t.integer  "status"
    t.integer  "term_of_payment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offices", force: true do |t|
    t.string   "head_office_name"
    t.string   "description"
    t.string   "warehouse"
    t.string   "contact_person"
    t.integer  "departement_id"
    t.string   "phone_number"
    t.string   "fax_number"
    t.string   "mobile_phone"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plus", force: true do |t|
    t.string   "code"
    t.integer  "sku_id"
    t.integer  "h_jual"
    t.integer  "h_beli"
    t.string   "satuan"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "principals", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "address"
    t.string   "no_telp1"
    t.string   "no_telp2"
    t.string   "fax"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_details", force: true do |t|
    t.integer  "product_id"
    t.integer  "size_detail_id"
    t.integer  "min_stock"
    t.integer  "warehouse_id"
    t.integer  "available_qty"
    t.integer  "allocated_qty"
    t.integer  "freezed_qty"
    t.integer  "rejected_qty"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status2"
  end

  create_table "product_prices", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "h_jual_kecil"
    t.integer  "h_jual_menengah"
    t.integer  "h_jual_besar"
    t.integer  "price_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.integer  "type_id"
    t.integer  "brand_id"
    t.string   "article"
    t.string   "barcode"
    t.integer  "size_id"
    t.integer  "unit_id"
    t.string   "status"
    t.integer  "colour_id"
    t.float    "cost_of_products"
    t.float    "purchase_price"
    t.float    "selling_price"
    t.float    "discount_price"
    t.float    "discount_price2"
    t.float    "discount_price3"
    t.string   "code"
    t.float    "percentage_price"
    t.integer  "netto"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "cost_date"
    t.date     "sell_price_date"
    t.integer  "m_class_id"
    t.date     "purchase_price_date"
    t.string   "image"
    t.integer  "colour2_id"
    t.integer  "colour3_id"
    t.integer  "colour4_id"
    t.string   "status1"
    t.string   "status3"
    t.date     "first_po"
    t.float    "margin_percent1"
    t.float    "margin_percent2"
    t.float    "margin_percent3"
    t.float    "margin_percent4"
    t.float    "margin_rp"
  end

  add_index "products", ["article"], name: "index_products_on_article", using: :btree
  add_index "products", ["barcode"], name: "index_products_on_barcode", using: :btree
  add_index "products", ["brand_id"], name: "index_products_on_brand_id", using: :btree
  add_index "products", ["code"], name: "index_products_on_code", using: :btree
  add_index "products", ["colour_id"], name: "index_products_on_colour_id", using: :btree
  add_index "products", ["cost_of_products"], name: "index_products_on_cost_of_products", using: :btree
  add_index "products", ["discount_price"], name: "index_products_on_discount_price", using: :btree
  add_index "products", ["discount_price2"], name: "index_products_on_discount_price2", using: :btree
  add_index "products", ["discount_price3"], name: "index_products_on_discount_price3", using: :btree
  add_index "products", ["netto"], name: "index_products_on_netto", using: :btree
  add_index "products", ["percentage_price"], name: "index_products_on_percentage_price", using: :btree
  add_index "products", ["purchase_price"], name: "index_products_on_purchase_price", using: :btree
  add_index "products", ["selling_price"], name: "index_products_on_selling_price", using: :btree
  add_index "products", ["size_id"], name: "index_products_on_size_id", using: :btree
  add_index "products", ["status"], name: "index_products_on_status", using: :btree
  add_index "products", ["type_id"], name: "index_products_on_type_id", using: :btree
  add_index "products", ["unit_id"], name: "index_products_on_unit_id", using: :btree

  create_table "promotion_products", force: true do |t|
    t.integer  "promotion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sku_id"
  end

  create_table "promotions", force: true do |t|
    t.string   "code"
    t.date     "start"
    t.date     "end"
    t.integer  "flag_range"
    t.integer  "max_apply"
    t.integer  "min_bruto"
    t.integer  "bruto_value"
    t.integer  "multipler_purchase_limit"
    t.integer  "multipler_getpercent"
    t.integer  "multipler_getprice"
    t.integer  "multipler_getquantity"
    t.integer  "min_price"
    t.integer  "all_outtype"
    t.integer  "all_outgroup"
    t.integer  "all_salesman"
    t.integer  "all_outlet"
    t.integer  "all_team"
    t.string   "flag_multiple"
    t.string   "coverage_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "provinces", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "wilayah_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regions", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "retur_order_details", force: true do |t|
    t.float    "base_price"
    t.integer  "item_id"
    t.integer  "quantity"
    t.integer  "retur_order_id"
    t.float    "selling_price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "retur_orders", force: true do |t|
    t.string   "description"
    t.integer  "member_id"
    t.integer  "sales_order_id"
    t.float    "total"
    t.date     "transaction_date"
    t.string   "transaction_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "retur_to_supplier_details", force: true do |t|
    t.float    "price"
    t.integer  "item_id"
    t.integer  "quantity"
    t.integer  "retur_to_supplier_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "retur_to_suppliers", force: true do |t|
    t.integer  "receipt_id"
    t.string   "note"
    t.integer  "supplier_id"
    t.float    "total"
    t.date     "transaction_date"
    t.string   "transaction_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
  end

  create_table "sale_order_details", force: true do |t|
    t.float    "base_price"
    t.integer  "count"
    t.float    "discount_nominal"
    t.float    "discount_percent"
    t.integer  "item_id"
    t.integer  "promotion_id"
    t.integer  "retur_quantity"
    t.integer  "sales_order_id"
    t.float    "selling_price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sale_transaction_details", force: true do |t|
    t.float    "base_price"
    t.integer  "count"
    t.float    "discount_nominal"
    t.float    "discount_percent"
    t.integer  "item_id"
    t.integer  "promotional_id"
    t.integer  "retur_quatity"
    t.float    "selling_price"
    t.integer  "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sale_transactions", force: true do |t|
    t.integer  "credit_card_bank_id"
    t.string   "credit_card_number"
    t.integer  "debit_card_bank_id"
    t.string   "debit_card_number"
    t.float    "discount_nominal"
    t.float    "discount_percent"
    t.integer  "employee_id"
    t.float    "gross"
    t.integer  "member_id"
    t.float    "nett"
    t.float    "pay_cash"
    t.float    "pay_credit_card"
    t.float    "pay_debit_card"
    t.float    "pay_voucher"
    t.date     "transaction_date"
    t.string   "transaction_number"
    t.string   "voucher_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales_order_payments", force: true do |t|
    t.string   "account_bank_destination"
    t.string   "account_bank_source"
    t.string   "account_branch_destination"
    t.string   "account_branch_source"
    t.string   "account_name_destination"
    t.string   "account_name_source"
    t.string   "account_number_destination"
    t.string   "account_number_source"
    t.integer  "cashier_id"
    t.integer  "credit_card_bank_id"
    t.string   "credit_card_number"
    t.integer  "debit_card_bank_id"
    t.string   "debit_card_number"
    t.integer  "member_id"
    t.float    "nominal"
    t.float    "pay_left"
    t.date     "payment_date"
    t.string   "payment_number"
    t.integer  "payment_type"
    t.integer  "sales_order_id"
    t.integer  "salesman_id"
    t.string   "voucher_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cashier_name"
  end

  create_table "sales_orders", force: true do |t|
    t.integer  "cashier_id"
    t.integer  "delivered"
    t.date     "delivery_date"
    t.string   "delivery_instruction"
    t.float    "discount_nominal"
    t.string   "dispatched_by"
    t.date     "due_date"
    t.float    "fat"
    t.float    "gross"
    t.integer  "member_id"
    t.float    "nett"
    t.string   "ordered_by"
    t.float    "paid"
    t.integer  "pengirim_id"
    t.integer  "promotion_id"
    t.string   "remarks"
    t.integer  "retur"
    t.date     "sales_order_date"
    t.integer  "salesman_id"
    t.string   "so_number"
    t.integer  "supervisor_id"
    t.float    "tax"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cashier_name"
  end

  create_table "schedules", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.time     "time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "setting_point_members", force: true do |t|
    t.integer  "point"
    t.integer  "price"
    t.text     "description"
    t.integer  "user_id"
    t.date     "expired_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shop_addresses", force: true do |t|
    t.string   "contact_person"
    t.string   "position"
    t.string   "phone1"
    t.string   "phone2"
    t.date     "birthday"
    t.string   "email"
    t.integer  "shop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shop_jps", force: true do |t|
    t.string   "salesman_name"
    t.string   "day"
    t.string   "week1"
    t.string   "week2"
    t.string   "week3"
    t.string   "week4"
    t.string   "route"
    t.integer  "shop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shops", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "address"
    t.string   "telp"
    t.string   "fax"
    t.string   "email"
    t.string   "npwp"
    t.integer  "kelurahan_id"
    t.integer  "subbeat_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "size_details", force: true do |t|
    t.integer  "size_number"
    t.integer  "size_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "size_details", ["size_id"], name: "index_size_details_on_size_id", using: :btree
  add_index "size_details", ["size_number"], name: "index_size_details_on_size_number", using: :btree

  create_table "sizes", force: true do |t|
    t.text     "description"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skus", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "brand_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stock_op_details", force: true do |t|
    t.integer  "actual_quantity"
    t.integer  "item_id"
    t.string   "note"
    t.integer  "stok_op_id"
    t.integer  "virtual_quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stock_ops", force: true do |t|
    t.integer  "approved"
    t.date     "approved_date"
    t.string   "description"
    t.date     "transaction_date"
    t.string   "transaction_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subbeats", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "beat_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suppliers", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "send_address"
    t.string   "phone"
    t.string   "fax"
    t.string   "hp1"
    t.string   "email"
    t.string   "person"
    t.string   "send_city"
    t.float    "setup_discount"
    t.string   "hp2"
    t.string   "pinbb"
    t.string   "no_bill"
    t.string   "bank"
    t.string   "branch"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "province"
    t.string   "zip"
    t.integer  "term"
    t.string   "suptype"
    t.float    "ppn"
    t.string   "paytype"
    t.string   "share"
    t.integer  "long_term"
  end

  add_index "suppliers", ["address"], name: "index_suppliers_on_address", using: :btree
  add_index "suppliers", ["bank"], name: "index_suppliers_on_bank", using: :btree
  add_index "suppliers", ["branch"], name: "index_suppliers_on_branch", using: :btree
  add_index "suppliers", ["city"], name: "index_suppliers_on_city", using: :btree
  add_index "suppliers", ["code"], name: "index_suppliers_on_code", using: :btree
  add_index "suppliers", ["email"], name: "index_suppliers_on_email", using: :btree
  add_index "suppliers", ["fax"], name: "index_suppliers_on_fax", using: :btree
  add_index "suppliers", ["hp1"], name: "index_suppliers_on_hp1", using: :btree
  add_index "suppliers", ["hp2"], name: "index_suppliers_on_hp2", using: :btree
  add_index "suppliers", ["name"], name: "index_suppliers_on_name", using: :btree
  add_index "suppliers", ["no_bill"], name: "index_suppliers_on_no_bill", using: :btree
  add_index "suppliers", ["person"], name: "index_suppliers_on_person", using: :btree
  add_index "suppliers", ["phone"], name: "index_suppliers_on_phone", using: :btree
  add_index "suppliers", ["pinbb"], name: "index_suppliers_on_pinbb", using: :btree
  add_index "suppliers", ["send_address"], name: "index_suppliers_on_send_address", using: :btree
  add_index "suppliers", ["send_city"], name: "index_suppliers_on_send_city", using: :btree
  add_index "suppliers", ["setup_discount"], name: "index_suppliers_on_setup_discount", using: :btree

  create_table "type_ulinons", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "units", force: true do |t|
    t.string   "name"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "birth_place"
    t.datetime "birth_date"
    t.string   "email"
    t.text     "password_hash"
    t.text     "password_salt"
    t.string   "status"
    t.integer  "organization_id"
    t.string   "privilege"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "username"
    t.integer  "head_office_id"
    t.integer  "branch_id"
    t.integer  "role_id"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "wilayahs", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
