# frozen_string_literal: true

module SerializerHelper
  def serialize(payload)
    ActiveModelSerializers::SerializableResource.new(payload)
  end
end
