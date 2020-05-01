class Member < ActiveRecord::Base
  has_many :retur_orders
  def self.import_xml(file)
    # open file
    doc = Nokogiri::XML(File.open(file))

    # select head node
      count = doc.css('DataITrust').count
      doc.css('DataITrust').each_with_index do |node, i|
        children = node.children
        # save to database
          Member.create(
          :active => children.css('Aktif').inner_text.to_i,
          :address_home => children.css('Alamat Rumah').inner_text,
          :barcode => children.css('Barcode').inner_text,
          :birth_date => children.css('Tanggal Lahir').inner_text,
          :birth_place => children.css('Tempat Lahir').inner_text,
          :code => children.css('Kode').inner_text,
          :credit_limit => children.css('Batas Kredit').inner_text.to_f.round(2),
          :discountpercent => children.css('Diskon Persen').inner_text.to_f.round(2),
          :email => children.css('Email').inner_text,
          :foto => children.css('Foto').inner_text,
          :noidentitas => children.css('No Identitas').inner_text,
          :identity_type => children.css('Tipe Identitas').inner_text.to_i,
          :jenis => children.css('Jenis').inner_text.to_i,
          :member_category_id => children.css('Kategori Anggota').inner_text.to_i,
          :member_group_id => children.css('Grup Anggota').inner_text.to_i,
          :mobile => children.css('Hp').inner_text,
          :name => children.css('Nama').inner_text,
          :npwp_alamat => children.css('Alamat NPWP').inner_text,
          :npwp_nama => children.css('Nama NPWP').inner_text,
          :npwp_no => children.css('No NPWP').inner_text,
          :occupation => children.css('Occupation').inner_text,
          :phone => children.css('Telepon').inner_text,
          :pin => children.css('Pin').inner_text.to_i,
          :point_used => children.css('Poin yang Digunakan').inner_text.to_i,
          :registration_date => children.css('Tanggal Daftar').inner_text,
          :religion => children.css('Agama').inner_text,
          :sex => children.css('Jenis Kelamin').inner_text,
          :status => children.css('Status').inner_text.to_i,
          :term_of_payment => children.css('Term of Payment').inner_text.to_i
          )
          if i == count-1
            sep = Scylla.last
            sep.count = 1
            sep.save
          end
      end

  end

  def self.api(params)
    ActiveSupport::JSON.decode(params).each do |d|
      member = self.new
      member.active = d["active"]
      member.address_home = d["address_home"]
      member.barcode = d["barcode"]
      member.birth_date = d["birth_date"]
      member.birth_place = d["birth_place"]
      member.code = d["code"]
      member.credit_limit = d["credit_limit"]
      member.discountpercent = d["discountpercent"]
      member.email = d["email"]
      member.foto = d["foto"]
      member.noidentitas = d["noidentitas"]
      member.identity_type = d["identity_type"]
      member.jenis = d["jenis"]
      member.member_category_id = d["member_category_id"]
      member.member_group_id = d["member_group_id"]
      member.mobile = d["mobile"]
      member.name = d["name"]
      member.npwp_alamat = d["npwp_alamat"]
      member.npwp_nama = d["npwp_nama"]
      member.npwp_no = d["npwp_no"]
      member.occupation = d["occupation"]
      member.phone = d["phone"]
      member.pin = d["pin"]
      member.point_used = d["point_used"]
      member.registration_date = d["registration_date"]
      member.religion = d["religion"]
      member.sex = d["sex"]
      member.status = d["status"]
      member.term_of_payment = d["term_of_payment"]
      member.save!
    end
  end

end