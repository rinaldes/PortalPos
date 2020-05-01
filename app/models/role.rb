class Role < ActiveRecord::Base
  has_many :features

  def has_privilege feature
    Feature.find_by_role_id_and_feature_name_id(id, feature.id)
  end
end
