# frozen_string_literal: true

require 'test_helper'

require 'gitw/repository_error'

describe Gitw::RepositoryError do
  it 'can be raised' do
    assert_raises(Gitw::RepositoryError) do
      raise Gitw::RepositoryError, 'repository error ...'
    end
  end
end
