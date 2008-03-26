require File.dirname(__FILE__) + '/../helper.rb'

describe 'validation' do
  it 'should not persist previous values' do
    eval('@a', Exocora::Support.bind({:b => 2})).should.be.nil
  end
end
