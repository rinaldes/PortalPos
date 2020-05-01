Rails.application.routes.draw do
  root 'sale_transactions#index'

#API
  namespace :api, defaults: {format: 'json'} do
    resources :sales_orders, :only => [:create, :update]
    resources :sale_order_details, :only => [:create]
    resources :sales_order_payments, :only => [:create]
    resources :item_receipts, :only => [:create]
    resources :item_receipt_details, :only => [:create]
    resources :item_receipt_payments, :only => [:create]
    resources :sale_transactions, :only => [:create]
    resources :sale_transaction_details, :only => [:create]
    resources :stock_ops, :only => [:create]
    resources :stock_op_details, :only => [:create]
    resources :retur_orders, :only => [:create]
    resources :retur_order_details, :only => [:create]
    resources :retur_to_suppliers, :only => [:create]
    resources :retur_to_supplier_details, :only => [:create]
    resources :members, :only => [:create]
    resources :cash_in_cash_out, :only => [:create]
    resources :pengiriman_barang, :only => [:create]
    resources :plus, :only => [:index]
    resources :regions, :only => [:index]
    resources :areas, :only => [:index]
    resources :distributors, :only => [:index]
    resources :distriks, :only => [:index]
    resources :beats, :only => [:index]
    resources :subbeats, :only => [:index]
    resources :wilayahs, :only => [:index]
    resources :provinces, :only => [:index]
    resources :cities, :only => [:index]
    resources :kecamatans, :only => [:index]
    resources :kelurahans, :only => [:index]
  end

#Index API / Transaction
  resources :sale_transactions, only: [:show, :index]
  resources :sales_orders, only: [:show, :index]
  resources :sales_order_payments, only: [:show, :index]
  resources :item_receipts, only: [:show, :index]
  resources :item_receipt_payments, only: [:show, :index]
  resources :stock_ops, only: [:show, :index]
  resources :retur_to_suppliers, only: [:show, :index]
  resources :retur_orders, only: [:show, :index]
  resources :cash_in, only: [:show, :index]
  resources :cash_out, only: [:show, :index]

#Master Data

  resources :product_prices do
    collection do
      get :autocomplete_product_price_name
      post :import
      post :import
    end
  end
  resources :discounts do
    collection do
      get :autocomplete_discount_name
      get :add_discount_product
      get :add_discount_harga
      post :import
    end
  end
  resources :shops do
    collection do
      get :autocomplete_shop_name
      post :import
    end
  end
  resources :wilayahs do
    collection do
      get :autocomplete_wilayah_name
      post :import
    end
  end
  resources :provinces do
    collection do
      get :autocomplete_province_name
      post :import
    end
  end
  resources :cities do
    collection do
      get :autocomplete_city_name
      post :import
    end
  end
  resources :kecamatans do
    collection do
      get :autocomplete_kecamatan_name
      post :import
    end
  end
  resources :kelurahans do
    collection do
      get :autocomplete_kelurahan_name
      post :import
    end
  end
  resources :type_ulinons do
    collection do
      get :autocomplete_type_ulinon_name
      post :import
    end
  end
  resources :subbeats do
    collection do
      get :autocomplete_subbeat_name
      post :import
    end
  end
  resources :beats do
    collection do
      get :autocomplete_beat_name
      post :import
    end
  end
  resources :distriks do
    collection do
      get :autocomplete_distrik_name
      post :import
    end
  end
  resources :distributors do
    collection do
      get :autocomplete_distributor_name
      post :import
    end
  end
  resources :areas do
    collection do
      get :autocomplete_area_name
      post :import
    end
  end
  resources :regions do
    collection do
      get :autocomplete_region_name
      post :import
    end
  end
  resources :skus do
    collection do
      get :autocomplete_sku_name
      post :import
    end
  end
  resources :plus do
    collection do
      get :autocomplete_plus_name
      post :import
    end
  end
  resources :categories do
    collection do
      get :autocomplete_categories_name
      post :import
    end
  end
  resources :principals do
    collection do
      get :autocomplete_principal_name
      post :import
    end
  end
  resources :promotions do
    collection do
      get :search
      get :autocomplete_promotion_name
      get :add_promotion_product
      post :import
    end
  end
  resources :brands do
    collection do
      get :search
      get :autocomplete_brand_name
      post :import
    end
  end
  resources :divisions do
    collection do
      get :search
      get :autocomplete_division_name
      post :import
    end
  end
  resources :licenses do
    collection do
      get :search
    end
  end
  resources :apps_updaters do
    collection do
      get :search
    end
  end
  resources :histories, :only => [:index]
  resources :schedules, :only => [:index]

# ?
  
  resources :roles
  
  devise_for :users
  resources :users do
    collection do
      post :login
      get :logout
      get :new_session
      get :autocomplete_name
    end
  end
end
