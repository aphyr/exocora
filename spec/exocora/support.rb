require File.dirname(__FILE__) + '/../helper.rb'

describe 'exocora support' do
  describe 'binding' do
    it 'should bind hashes to instance variables' do
      eval('@a', Exocora::Support.bind({:a => 2})).should.equal 2
    end
  
    it 'should not persist previous values' do
      eval('@a', Exocora::Support.bind({:b => 2})).should.be.nil
    end
  end
end
