User.create (first_name: "SUPER", last_name: "ADMIN", gender: "male", birth_place: 'hometown', birth_date: '2015-12-12 00:00:00', email: 'esurveypinus@gmail.com', status: 'active', confirmed_at: '2015-12-12 00:00:00', username: 'ADMIN', head_office_id: 1, branch_id: 2, password: '12345678')

Role.create name: 'Admin'
Role.create name: 'User'

[['Master Data', ['Principal', 'Division', 'Category', 'Brand', 'SKU', 'PLU', 'Region', 'Area', 'Distributor', 'Distrik', 'Beat', 'Subbeat', 'Zone', 'Province', 'City', 'Kecamatan',
  'Kelurahan', 'Type', 'Product Price', 'Promotion', 'Discount', 'Outlet']], ['Transaction', ['Sales Order', 'Product Receipt', 'Sales', 'Stock Opname', 'Sales Return',
  'Return to Supplier', 'Cash In']]].each{|feature|
  feature[1].each{|f|
    FeatureName.where(name: f, module_name: feature[0]).first_or_create
  }
}
